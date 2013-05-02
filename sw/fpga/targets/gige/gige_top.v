//
// 1000BASE-T passthrough,
// for DE2-115 board and GigE front-end
// top-level
//
// Copyright (c) 2013 Dominic Spill
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
	output  wire          phy0_gm_tx_clk,
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
	inout   wire  [0:4]   phy0_addr,

	input   wire          phy0_int_n,
	input   wire          phy0_clk125_ndo,
	input   wire          phy0_col,
	input   wire          phy0_crs,

	// Ethernet PHY 1
	output  wire  [7:0]   phy1_gm_txd,
	output  wire          phy1_gm_tx_en,
	output  wire          phy1_gm_tx_er,
	output  wire          phy1_gm_tx_clk,
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
	inout   wire  [0:4]   phy1_addr,

	input   wire          phy1_int_n,
	input   wire          phy1_clk125_ndo,
	input   wire          phy1_col,
	input   wire          phy1_crs
);
	reg [8:0] led_g;
	assign LEDG = led_g;

	reg  reset_1;
	reg  reset_2;

always @(posedge clk_50) begin
	{reset_2, reset_1} <= {reset_1, ~KEY[0]};
end

phy_init phy0_init (
	.clk_50 ( clk_50 ),
	.reset_n ( reset_2 ),

	.phy_gm_rxd ( phy0_gm_rxd ),
	.phy_gm_rx_dv ( phy0_gm_rx_dv ),
	.phy_addr ( phy0_addr ),
	.phy_hw_rst ( phy0_hw_rst ),

	.phy_ready ( phy0_ready )
);

phy_init phy1_init (
	.clk_50 ( clk_50 ),
	.reset_n ( reset_2 ),

	.phy_gm_rxd ( phy1_gm_rxd ),
	.phy_gm_rx_dv ( phy1_gm_rx_dv ),
	.phy_addr ( phy1_addr ),
	.phy_hw_rst ( phy1_hw_rst ),

	.phy_ready ( phy1_ready )
);

// 0-3 -> Register address
io_seg7 is0 (
	.disp_in	( 0 ),
	.disp_out	( HEX0 )
);

io_seg7 is1 (
	.disp_in	( 0 ),
	.disp_out	( HEX1 )
);

io_seg7 is2 (
	.disp_in	( 0 ),
	.disp_out	( HEX2 )
);

io_seg7 is3 (
	.disp_in	( 0 ),
	.disp_out	( HEX3 )
);

// 4-5 -> Read value
io_seg7 is4 (
	.disp_in	( 0 ),
	.disp_out	( HEX4 )
);

io_seg7 is5 (
	.disp_in	( 0 ),
	.disp_out	( HEX5 )
);

// 6-7 -> value to assign
io_seg7 is6 (
	.disp_in	( SW[11:8] ),
	.disp_out	( HEX6 )
);

io_seg7 is7 (
	.disp_in	( SW[15:12] ),
	.disp_out	( HEX7 )
);
endmodule
