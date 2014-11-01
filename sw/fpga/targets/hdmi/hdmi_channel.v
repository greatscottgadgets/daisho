//
// HDMI channel tap
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

module hdmi_channel (
	input		wire				reset,
	input		wire				rxclk_raw,
	input		wire	[ 9:0]	rx,
	output	wire				txclk,
	output	wire	[ 9:0]	tx,
	input		wire				log_clk,
	output	wire				log_empty,
	input		wire				log_read,
	output	wire	[39:0]	log_data
);

// RXCLK PLL

wire						rxclk_pll;
wire						pll_locked;

pll_rxclk pll (
	.areset(reset),
	.inclk0(rxclk_raw),
	.c0(rxclk_pll),
	.locked(pll_locked)
);

// RX registering

reg		[ 9:0]		rx_q;

always @(posedge rxclk_pll) begin
	if( reset ) begin
		rx_q <= 0;
	end
	else begin
		rx_q <= rx;
	end
end

// TX clock output

ddio_txclk txclk_out (
	.aclr(reset),
	.datain_h(1'b1),
	.datain_l(1'b0),
	.outclock(rxclk_pll),
	.dataout(txclk)
);

// TX output

reg		[ 9:0]		tx_q;
assign					tx = tx_q;

always @(posedge rxclk_pll) begin
	if( reset )
		tx_q <= 0;
	else
		tx_q <= rx_q;
end

// RX FIFO write

reg	 [39:0]		rx_word;
reg	 [ 3:0]		rx_word_state;
reg					rx_word_write;

always @(posedge rxclk_pll) begin
	if( reset || !pll_locked ) begin
		rx_word <= 40'b0;
		rx_word_state <= 4'b0001;
		rx_word_write <= 1'b0;
	end
	else begin
		rx_word <= { rx_word[29:0], rx_q };
		rx_word_state <= { rx_word_state[2:0], rx_word_state[3] };
		rx_word_write <= rx_word_state[0];
	end
end

wire rx_fifo_full;

fifo_rx_usb fifo_rx (
	.wrclk(rxclk_pll),
	.wrfull(rx_fifo_full),
	.wrreq(rx_word_write),
	.data(rx_word),
	.rdclk(log_clk),
	.rdempty(log_empty),
	.rdreq(log_read),
	.q(log_data)
);

endmodule
