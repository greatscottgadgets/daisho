//
// Simple TX-only UART implementation
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

module uart_debug (
	input		wire		clk_50,
	input		wire		reset,

	input		wire		mii_clk,
	input		wire [3:0]	mii_in,
	input		wire		mii_en,

	output		wire		uart_tx
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
		if (baud_counter == 217) begin
			baud_counter <= 0;
			uart_shift_en <= 1;
		end
	end
end

wire [7:0] nibble_ascii;

nibble_ascii nibble_ascii_rxd (
	.nibble(mii_in),
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
reg				tx_bit;
assign uart_tx = tx_bit;

wire fifo_uart_reset = reset;

wire fifo_uart_i_clk = mii_clk;
wire fifo_uart_i_full;
wire fifo_uart_i_req = mii_en;
wire [7:0] fifo_uart_i_data = nibble_ascii;

wire fifo_uart_o_clk = clk_50;
wire fifo_uart_o_empty;
wire fifo_uart_o_not_empty = !fifo_uart_o_empty;
reg fifo_uart_o_req;
wire [7:0] fifo_uart_o_data;

reg fifo_uart_i_req_q;
wire end_of_packet = (fifo_uart_i_req == 0) && (fifo_uart_i_req_q == 1);

always @(posedge fifo_uart_i_clk) begin
	if (reset) begin
		fifo_uart_i_req_q <= 0;
	end
	else
	begin
		fifo_uart_i_req_q <= fifo_uart_i_req;
	end
end

fifo_uart	fifo_uart_inst (
	.aclr ( fifo_uart_reset ),

	.wrclk ( fifo_uart_i_clk ),
	.wrfull ( fifo_uart_i_full ),
	.wrreq ( fifo_uart_i_req || end_of_packet ),
	.data ( end_of_packet ? 8'h0a : fifo_uart_i_data ),

	.rdclk ( fifo_uart_o_clk ),
	.rdempty ( fifo_uart_o_empty ),
	.rdreq ( fifo_uart_o_req ),
	.q ( fifo_uart_o_data )
);

always @(posedge clk_50) begin
	fifo_uart_o_req <= 0;

	if (reset) begin
		state_uart <= ST_UART_IDLE;
		tx_bit <= 1;
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
				tx_bit <= 0;
				state_uart <= ST_UART_D0;
			end

			ST_UART_D0: begin
				tx_bit <= fifo_uart_o_data[0];
				state_uart <= ST_UART_D1;
			end

			ST_UART_D1: begin
				tx_bit <= fifo_uart_o_data[1];
				state_uart <= ST_UART_D2;
			end

			ST_UART_D2: begin
				tx_bit <= fifo_uart_o_data[2];
				state_uart <= ST_UART_D3;
			end

			ST_UART_D3: begin
				tx_bit <= fifo_uart_o_data[3];
				state_uart <= ST_UART_D4;
			end

			ST_UART_D4: begin
				tx_bit <= fifo_uart_o_data[4];
				state_uart <= ST_UART_D5;
			end

			ST_UART_D5: begin
				tx_bit <= fifo_uart_o_data[5];
				state_uart <= ST_UART_D6;
			end

			ST_UART_D6: begin
				tx_bit <= fifo_uart_o_data[6];
				state_uart <= ST_UART_D7;
			end

			ST_UART_D7: begin
				tx_bit <= fifo_uart_o_data[7];
				state_uart <= ST_UART_STOP;
			end

			ST_UART_STOP: begin
				tx_bit <= 1;
				state_uart <= ST_UART_IDLE;
			end

			endcase
		end
	end
end

endmodule
