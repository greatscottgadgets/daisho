//
// Move data from GMII RX to FIFO.
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

module gmii_rx_to_fifo (
	input		wire				reset,
	input		wire				clock,
	input		wire				rx_dv,
	input		wire	[ 7:0]	rxd,
	input		wire				rx_er,
	output	wire				fifo_en,
	output	wire	[ 7:0]	fifo_d,
	output	wire				fifo_er,
	output	wire				fifo_frame_end
);

reg					rx_dv_1;
reg					rx_dv_2;

reg		[ 7:0]	rxd_1;
reg		[ 7:0]	rxd_2;

reg					rx_er_1;
reg					rx_er_2;

// RX pipeline
always @(posedge clock) begin
	if (reset) begin
		rx_dv_1 <= 0;
		rx_dv_2 <= 0;

		rxd_1 <= 0;
		rxd_2 <= 0;

		rx_er_1 <= 0;
		rx_er_2 <= 0;
	end
	else begin
		rx_dv_1 <= rx_dv;
		rx_dv_2 <= rx_dv_1;

		rxd_1 <= rxd;
		rxd_2 <= rxd_1;

		rx_er_1 <= rx_er;
		rx_er_2 <= rx_er_1;
	end
end

assign	fifo_en				= rx_dv_2;
assign	fifo_frame_end		= rx_dv_2 && !rx_dv_1;
assign	fifo_er				= rx_er_2;
assign	fifo_d				= rxd_2;

endmodule
