//
// Move data from FIFO to GMII TX.
//
// Copyright (c) 2014 Jared Boone, ShareBrained Technology, Inc.
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

module gmii_fifo_to_tx (
	input		wire				reset,
	input		wire				clock,
	input		wire				fifo_empty,
	output	reg				fifo_en,
	input		wire	[ 7:0]	fifo_d,
	input		wire				fifo_er,
	input		wire				fifo_frame_end,
	output	reg				tx_en,
	output	reg	[ 7:0]	txd,
	output	reg				tx_er
);

wire				fifo_not_empty = !fifo_empty;

parameter	[ 2:0]	ST_IDLE		= 3'b001,
							ST_WAIT		= 3'b010,
							ST_TX			= 3'b100
							;

reg			[ 2:0]	state = ST_IDLE;

reg			[ 5:0]	wait_count;

always @(posedge clock) begin
	wait_count <= 0;
	fifo_en <= 0;
	tx_en <= 0;
	txd <= 0;
	tx_er <= 0;

	if( reset ) begin
		state <= ST_IDLE;
	end
	else begin
		case(state)
		ST_IDLE: begin
			state <= ST_IDLE;
			if( fifo_not_empty ) begin
				state <= ST_WAIT;
				fifo_en <= 1;  // Retrieve first byte.
			end
		end

		ST_WAIT: begin
			// Wait a moment to buffer enough data to address small
			// RX:TX clock mismatches that might cause us to break a
			// frame in two.
			// At 50ppm, an 32768 byte packet will accumulate < 16
			// bytes of lead or lag. So wait 16 counts to
			// account for RX and TX clocks being at opposite extremes.
			wait_count <= wait_count + 1'b1;
			state <= ST_WAIT;

			if( wait_count == 32 ) begin
				wait_count <= 0;
				state <= ST_TX;
			end
		end

		ST_TX: begin
			fifo_en <= 1;
			tx_en <= 1;
			txd <= fifo_d;
			tx_er <= fifo_er;
			state <= ST_TX;
			if( fifo_frame_end ) begin
				state <= ST_IDLE;
				fifo_en <= 0;
			end

			// TODO: Test rx_empty for underflow?
		end

		endcase
	end
end

endmodule
