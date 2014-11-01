//
// Move data from GMII RX to TX with logging tap.
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

module gmii_bridge (
	input		wire				reset,
	
	// GMII/MII: Receive
	input		wire				rx_clk,
	inout		wire				rx_dv,
	inout		wire	[ 7:0]	rxd,
	input		wire				rx_er,

	// GMII/MII: Transmit
	input		wire				gtx_clk,
	output	wire				tx_en,
	output	wire	[ 7:0]	txd,
	output	wire				tx_er,
	
	// Log out
	output	wire				log_clk,
	output	wire				log_en,
	output	wire	[ 7:0]	log_d,
	output	wire				log_frame_end
);

wire						rx_fifo_wr_en;
wire		[ 7:0]		rx_fifo_wr_d;
wire						rx_fifo_wr_er;
wire						rx_fifo_wr_frame_end;

gmii_rx_to_fifo rx_to_fifo_inst (
	.reset(reset),
	.clock(rx_clk),
	.rx_dv(rx_dv),
	.rxd(rxd),
	.rx_er(rx_er),
	.fifo_en(rx_fifo_wr_en),
	.fifo_d(rx_fifo_wr_d),
	.fifo_er(rx_fifo_wr_er),
	.fifo_frame_end(rx_fifo_wr_frame_end)
);

wire					rx_fifo_empty;
wire					rx_fifo_rd_en;
wire		[ 7:0]	rx_fifo_rd_d;
wire					rx_fifo_rd_er;
wire					rx_fifo_rd_frame_end;

gmii_fifo_to_tx fifo_to_tx_inst (
	.reset(reset),
	.clock(gtx_clk),
	.fifo_empty(rx_fifo_empty),
	.fifo_en(rx_fifo_rd_en),
	.fifo_d(rx_fifo_rd_d),
	.fifo_er(rx_fifo_rd_er),
	.fifo_frame_end(rx_fifo_rd_frame_end),
	.tx_en(tx_en),
	.txd(txd),
	.tx_er(tx_er)
);

fifo_packet fifo_packet_inst (
	.aclr(reset),
	.wrclk(rx_clk),
	.wrfull(),
	.wrreq(rx_fifo_wr_en),
	.data({ rx_fifo_wr_frame_end, rx_fifo_wr_er, rx_fifo_wr_d }),
	.rdclk(gtx_clk),
	.rdempty(rx_fifo_empty),
	.rdreq(rx_fifo_rd_en),
	.q({ rx_fifo_rd_frame_end, rx_fifo_rd_er, rx_fifo_rd_d })
);

assign	log_clk = rx_clk;
assign	log_en = rx_fifo_wr_en;
assign	log_d = rx_fifo_wr_d;
assign	log_frame_end = rx_fifo_wr_frame_end;

endmodule
