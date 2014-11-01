//
// 100baseTX Ethernet passthrough
//
// Passes data from a source MII to a target MII.
//
// Copyright (c) 2013 Jared Boone, ShareBrained Technology, Inc.
//
// This file is part of Project Daisho.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street,
// Boston, MA 02110-1301, USA.
//

module mii_passthrough (
	input   wire            reset,

	// Source MII
	input   wire            rx_clk,
	input   wire            rx_dv,
	input   wire    [3:0]   rxd,
	input   wire            rx_er,
	input   wire            crs,
	input   wire            col,

	// Target MII
	input   wire            tx_clk,
	output  reg             tx_en,
	output  reg     [3:0]   txd,
	output  reg             tx_er,

	output  reg             rx_full_error,
	output  wire    [15:0]  rx_frame_count,
	output  wire    [15:0]  rx_total_nibble_count
);

reg             rx_dv_1;
reg             rx_dv_2;
reg             rx_dv_3;

reg     [3:0]   rxd_1;
reg     [3:0]   rxd_2;

reg             rx_er_1;
reg             rx_er_2;

// RX pipeline
always @(posedge rx_clk) begin
	if (reset) begin
		rx_dv_1 <= 0;
		rx_dv_2 <= 0;
		rx_dv_3 <= 0;

		rxd_1 <= 4'h0;
		rxd_2 <= 4'h0;

		rx_er_1 <= 0;
		rx_er_2 <= 0;
	end
	else
	begin
		rx_dv_1 <= rx_dv;
		rx_dv_2 <= rx_dv_1;
		rx_dv_3 <= rx_dv_2;

		rxd_1 <= rxd;
		rxd_2 <= rxd_1;

		rx_er_1 <= rx_er;
		rx_er_2 <= rx_er_1;
	end
end

wire            frame_start = rx_dv_2 && !rx_dv_3;
wire            frame_end = rx_dv_2 && !rx_dv_1;

reg     [15:0]  total_nibble_count;

assign rx_total_nibble_count = total_nibble_count;

always @(posedge rx_clk) begin
	if (reset) begin
		total_nibble_count <= 0;
	end
	else
	begin
		if (rx_dv) begin
			total_nibble_count <= total_nibble_count + 16'h1;
		end
	end
end

reg     [15:0]  nibble_count;

always @(posedge rx_clk) begin
	if (reset) begin
		nibble_count <= 0;
	end
	else
	begin
		if (frame_start) begin
			nibble_count <= 0;
		end
		else
		begin
			nibble_count <= nibble_count + 16'h1;
		end
	end
end

reg     [15:0]  frame_count;
assign rx_frame_count = frame_count;

always @(posedge rx_clk) begin
	if (reset) begin
		frame_count <= 0;
	end
	else
	begin
		if (frame_start) begin
			frame_count <= frame_count + 16'b1;
		end
	end
end

always @(posedge rx_clk) begin
	if (reset) begin
		rx_full_error <= 0;
	end
	else
	begin
		if (fifo_packet_i_full) begin
			rx_full_error <= 1;
		end
	end
end

// Packet FIFO
wire            fifo_reset = reset;

wire            fifo_packet_i_clk = rx_clk;
wire            fifo_packet_i_en = rx_dv_2;
wire            fifo_packet_i_full;
wire            fifo_packet_i_frame_end = frame_end;
wire            fifo_packet_i_er = rx_er_2;
wire    [3:0]   fifo_packet_i_nibble = rxd_2;
wire    [5:0]   fifo_packet_i_data = { fifo_packet_i_frame_end, fifo_packet_i_er, fifo_packet_i_nibble };

wire            fifo_packet_o_clk = tx_clk;
reg             fifo_packet_o_en;
wire    [5:0]   fifo_packet_o_data;
wire            fifo_packet_o_empty;
wire            fifo_packet_o_not_empty = !fifo_packet_o_empty;
wire            fifo_packet_o_frame_end = fifo_packet_o_data[5];
wire            fifo_packet_o_er = fifo_packet_o_data[4];
wire    [3:0]   fifo_packet_o_nibble = fifo_packet_o_data[3:0];

fifo_packet fifo_packet_inst (
	.aclr ( fifo_reset ),
 
	.wrclk ( fifo_packet_i_clk ),
	.wrfull ( fifo_packet_i_full ),
	.wrreq ( fifo_packet_i_en ),
	.data ( fifo_packet_i_data ),

	.rdclk ( fifo_packet_o_clk ),
	.rdempty ( fifo_packet_o_empty ),
	.rdreq ( fifo_packet_o_en ),
	.q ( fifo_packet_o_data )
);

parameter   [2:0]   ST_IDLE     = 3'b000,
					ST_WAIT     = 3'b001,
					ST_PREAMBLE = 3'b010,
					ST_TX       = 3'b011
					;
reg     [2:0]   tx_state = ST_IDLE;

reg     [5:0]   tx_wait_count;

always @(posedge tx_clk) begin
	tx_wait_count <= 0;
	fifo_packet_o_en <= 0;
	tx_en <= 0;
	txd <= 4'b0000;
	tx_er <= 0;

	if (reset) begin
		tx_state <= ST_IDLE;
	end
	else
	begin
		case(tx_state)
		ST_IDLE: begin
			tx_state <= ST_IDLE;
			if (fifo_packet_o_not_empty) begin
				tx_state <= ST_WAIT;
				fifo_packet_o_en <= 1;  // Retrieve first nibble.
			end
		end

		ST_WAIT: begin
			// Wait a moment to buffer enough data to address small
			// RX:TX clock mismatches that might cause us to break a
			// frame in two.
			// At 50ppm, an 32768 nibble packet will accumulate < 16
			// nibbles of lead or lag. So wait 32 counts to
			// account for RX and TX clocks being at opposite extremes.
			tx_wait_count <= tx_wait_count + 6'b1;
			tx_state <= ST_WAIT;

			if (tx_wait_count == 32) begin
				tx_wait_count <= 0;
				tx_state <= ST_TX;
			end
		end

		//ST_PREAMBLE: begin
		//    tx_wait_count <= tx_wait_count + 6'b1;

		//    tx_en <= 1;
		//    txd <= 4'b0101;
		//    tx_er <= 0;
		//    tx_state <= ST_PREAMBLE;

		//    if (tx_wait_count == 14) begin
		//        tx_state <= ST_TX;
		//    end
		//end

		ST_TX: begin
			fifo_packet_o_en <= 1;
			tx_en <= 1;
			txd <= fifo_packet_o_nibble;
			tx_er <= fifo_packet_o_er;
			tx_state <= ST_TX;
			if (fifo_packet_o_frame_end) begin
				tx_state <= ST_IDLE;
				fifo_packet_o_en <= 0;
			end

			// TODO: Test rx_empty for underflow?
		end

		endcase
	end
end

endmodule
