//
// 1000BASE-T passthrough,
// for DE2-115 board and GigE front-end
// top-level
//
// Copyright (c) 2013 Dominic Spill
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

module gige_top (

	input   wire          clk_50,	

	// UART
	input   wire          UART_RXD,
	input   wire          UART_RTS,
	output  wire          UART_TXD,
	output  wire          UART_CTS,

	// Hex LEDs
	output  wire  [6:0]   HEX0,
	output  wire  [6:0]   HEX1,
	output  wire  [6:0]   HEX2,
	output  wire  [6:0]   HEX3,
	output  wire  [6:0]   HEX4,
	output  wire  [6:0]   HEX5,
	output  wire  [6:0]   HEX6,
	output  wire  [6:0]   HEX7,

	input	wire  [3:0]   KEY,
	input	wire  [17:0]  SW,
	output	wire  [17:0]  LEDR,
	output  wire  [8:0]   LEDG,

	// Ethernet PHY 0
	output  wire  [7:0]   phy0_gm_txd,
	output  wire          phy0_gm_tx_en,
	output  wire          phy0_gm_tx_er,
	input   wire          phy0_gm_tx_clk,
	output  wire          phy0_gm_gtx_clk,

	// Inputs (outputs in configuration mode)
	inout   wire  [7:0]   phy0_gm_rxd,
	inout   wire          phy0_gm_rx_dv,

	input   wire          phy0_gm_rx_err,
	input   wire          phy0_gm_rx_clk,

	// Have internal pull-up (not sure how that affects the FPGA)
	output  wire          phy0_gm_mdc,
	inout   wire          phy0_gm_mio,
	output  wire          phy0_hw_rst,

	// Used for configuration mode (LED states in all other modes)
	inout   wire  [4:0]   phy0_addr,

	input   wire          phy0_int_n,
	input   wire          phy0_clk125_ndo,
	input   wire          phy0_col,
	input   wire          phy0_crs,

	// Ethernet PHY 1
	output  wire  [7:0]   phy1_gm_txd,
	output  wire          phy1_gm_tx_en,
	output  wire          phy1_gm_tx_er,
	input   wire          phy1_gm_tx_clk,
	output  wire          phy1_gm_gtx_clk,

	// Inputs (outputs in configuration mode)
	inout   wire  [7:0]   phy1_gm_rxd,
	inout   wire          phy1_gm_rx_dv,

	input   wire          phy1_gm_rx_err,
	input   wire          phy1_gm_rx_clk,

	// Have internal pull-up (not sure how that affects the FPGA)
	output  wire          phy1_gm_mdc,
	inout   wire          phy1_gm_mio,
	output  wire          phy1_hw_rst,

	// Used for configuration mode (LED states in all other modes)
	inout   wire  [4:0]   phy1_addr,

	input   wire          phy1_int_n,
	input   wire          phy1_clk125_ndo,
	input   wire          phy1_col,
	input   wire          phy1_crs
);

assign LEDR = 18'b0;
assign LEDG[8:2] = 6'b0;

assign phy0_gm_gtx_clk = 0;
assign phy1_gm_gtx_clk = 0;

assign phy0_gm_mdc = 0;
assign phy1_gm_mdc = 0;

assign phy0_gm_mio = 1'bz;
assign phy1_gm_mio = 1'bz;

wire reset_raw = !KEY[0];
reg  reset_1;
reg  reset_2;
wire reset = reset_2;

always @(posedge clk_50) begin
	{reset_2, reset_1} <= {reset_1, reset_raw};
end

wire phy0_reset = reset;
wire phy0_ready;

phy_init phy0_init (
	.clk_i ( clk_50 ),
	.reset_i ( phy0_reset ),
	.ready_o ( phy0_ready ),

	.phy_rxd ( phy0_gm_rxd ),
	.phy_rx_dv ( phy0_gm_rx_dv ),
	.phy_addr ( phy0_addr ),
	.phy_reset_n_o ( phy0_hw_rst )
);

wire phy1_reset = reset;
wire phy1_ready;

phy_init phy1_init (
	.clk_i ( clk_50 ),
	.reset_i ( phy1_reset ),
	.ready_o ( phy1_ready ),

	.phy_rxd ( phy1_gm_rxd ),
	.phy_rx_dv ( phy1_gm_rx_dv ),
	.phy_addr ( phy1_addr ),
	.phy_reset_n_o ( phy1_hw_rst )
);

wire phys_not_ready = (!phy0_ready) || (!phy1_ready);

wire mii_pt_0to1_reset = phys_not_ready;
wire phy0_rx_full_error;
wire [15:0] phy0_rx_frame_count;
wire [15:0] phy0_rx_total_nibble_count;
assign LEDG[0] = phy0_rx_full_error;

mii_passthrough mii_pt_0to1 (
	.reset(mii_pt_0to1_reset),
	.rx_clk(phy0_gm_rx_clk),
	.rx_dv(phy0_gm_rx_dv),
	.rxd(phy0_gm_rxd),
	.rx_er(phy0_gm_rx_err),
	.crs(phy0_crs),
	.col(phy0_col),
	.tx_clk(phy1_gm_tx_clk),
	.tx_en(phy1_gm_tx_en),
	.txd(phy1_gm_txd),
	.tx_er(phy1_gm_tx_er),
	.rx_full_error(phy0_rx_full_error),
	.rx_frame_count(phy0_rx_frame_count),
	.rx_total_nibble_count(phy0_rx_total_nibble_count)
);

wire mii_pt_1to0_reset = phys_not_ready;
wire phy1_rx_full_error;
wire [15:0] phy1_rx_frame_count;
wire [15:0] phy1_rx_total_nibble_count;
assign LEDG[1] = phy1_rx_full_error;

mii_passthrough mii_pt_1to0 (
	.reset(mii_pt_1to0_reset),
	.rx_clk(phy1_gm_rx_clk),
	.rx_dv(phy1_gm_rx_dv),
	.rxd(phy1_gm_rxd),
	.rx_er(phy1_gm_rx_err),
	.crs(phy1_crs),
	.col(phy1_col),
	.tx_clk(phy0_gm_tx_clk),
	.tx_en(phy0_gm_tx_en),
	.txd(phy0_gm_txd),
	.tx_er(phy0_gm_tx_er),
	.rx_full_error(phy1_rx_full_error),
	.rx_frame_count(phy1_rx_frame_count),
	.rx_total_nibble_count(phy1_rx_total_nibble_count)
);

wire	[15:0]	is3_0 = SW[0] ? phy0_rx_total_nibble_count : phy0_rx_frame_count;
wire	[15:0]	is7_4 = SW[1] ? phy1_rx_total_nibble_count : phy1_rx_frame_count;

io_seg7 is0 (
	.disp_in	( is3_0[3:0] ),
	.disp_out	( HEX0 )
);

io_seg7 is1 (
	.disp_in	( is3_0[7:4] ),
	.disp_out	( HEX1 )
);

io_seg7 is2 (
	.disp_in	( is3_0[11:8] ),
	.disp_out	( HEX2 )
);

io_seg7 is3 (
	.disp_in	( is3_0[15:12] ),
	.disp_out	( HEX3 )
);

io_seg7 is4 (
	.disp_in	( is7_4[3:0] ),
	.disp_out	( HEX4 )
);

io_seg7 is5 (
	.disp_in	( is7_4[7:4] ),
	.disp_out	( HEX5 )
);

io_seg7 is6 (
	.disp_in	( is7_4[11:8] ),
	.disp_out	( HEX6 )
);

io_seg7 is7 (
	.disp_in	( is7_4[15:12] ),
	.disp_out	( HEX7 )
);

reg		[9:0]	baud_counter;
reg				uart_shift_en;

always @(posedge clk_50) begin
	uart_shift_en <= 0;

	if (reset) begin
		baud_counter <= 0;
	end
	else
	begin
		baud_counter <= baud_counter + 10'b1;
		if (baud_counter == 434) begin
			baud_counter <= 0;
			uart_shift_en <= 1;
		end
	end
end

wire [7:0] nibble_ascii;

nibble_ascii nibble_ascii_rxd (
	//.nibble(phy0_gm_rxd[3:0]),
	.nibble(phy1_gm_txd[3:0]),
	.ascii(nibble_ascii)
);

parameter	[3:0]	ST_UART_IDLE	= 0,
					ST_UART_START	= 1,
					ST_UART_D0		= 2,
					ST_UART_D1		= 3,
					ST_UART_D2		= 4,
					ST_UART_D3		= 5,
					ST_UART_D4		= 6,
					ST_UART_D5		= 7,
					ST_UART_D6		= 8,
					ST_UART_D7		= 9,
					ST_UART_STOP	= 10
					;
reg		[3:0]	state_uart;
reg				uart_tx;

wire fifo_uart_reset = reset;

//wire fifo_uart_i_clk = phy0_gm_rx_clk;
wire fifo_uart_i_clk = phy1_gm_tx_clk;
wire fifo_uart_i_full;
//wire fifo_uart_i_req = phy0_gm_rx_dv;
wire fifo_uart_i_req = phy1_gm_tx_en;
wire [7:0] fifo_uart_i_data = nibble_ascii;

wire fifo_uart_o_clk = clk_50;
wire fifo_uart_o_empty;
wire fifo_uart_o_not_empty = !fifo_uart_o_empty;
reg fifo_uart_o_req;
wire [7:0] fifo_uart_o_data;

fifo_uart	fifo_uart_inst (
	.aclr ( fifo_uart_reset ),

	.wrclk ( fifo_uart_i_clk ),
	.wrfull ( fifo_uart_i_full ),
	.wrreq ( fifo_uart_i_req ),
	.data ( fifo_uart_i_data ),

	.rdclk ( fifo_uart_o_clk ),
	.rdempty ( fifo_uart_o_empty ),
	.rdreq ( fifo_uart_o_req ),
	.q ( fifo_uart_o_data )
);

assign UART_TXD = uart_tx;
assign UART_CTS = 0;

always @(posedge clk_50) begin
	fifo_uart_o_req <= 0;

	if (reset) begin
		state_uart <= ST_UART_IDLE;
		uart_tx <= 1;
	end
	else
	begin
		if (uart_shift_en) begin
			case(state_uart)
			ST_UART_IDLE: begin
				if (fifo_uart_o_not_empty) begin
					fifo_uart_o_req <= 1;
					state_uart <= ST_UART_START;
				end
			end

			ST_UART_START: begin
				uart_tx <= 0;
				state_uart <= ST_UART_D0;
			end

			ST_UART_D0: begin
				uart_tx <= fifo_uart_o_data[0];
				state_uart <= ST_UART_D1;
			end

			ST_UART_D1: begin
				uart_tx <= fifo_uart_o_data[1];
				state_uart <= ST_UART_D2;
			end

			ST_UART_D2: begin
				uart_tx <= fifo_uart_o_data[2];
				state_uart <= ST_UART_D3;
			end

			ST_UART_D3: begin
				uart_tx <= fifo_uart_o_data[3];
				state_uart <= ST_UART_D4;
			end

			ST_UART_D4: begin
				uart_tx <= fifo_uart_o_data[4];
				state_uart <= ST_UART_D5;
			end

			ST_UART_D5: begin
				uart_tx <= fifo_uart_o_data[5];
				state_uart <= ST_UART_D6;
			end

			ST_UART_D6: begin
				uart_tx <= fifo_uart_o_data[6];
				state_uart <= ST_UART_D7;
			end

			ST_UART_D7: begin
				uart_tx <= fifo_uart_o_data[7];
				state_uart <= ST_UART_STOP;
			end

			ST_UART_STOP: begin
				uart_tx <= 1;
				state_uart <= ST_UART_IDLE;
			end

			endcase
		end
	end
end

endmodule
