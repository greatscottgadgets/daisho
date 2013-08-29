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
	input   wire          phy1_crs,

	// DCE
	output	wire	DAISHO_RS232_A_RTS,
	output	wire	DAISHO_RS232_A_TXD,
	output	wire	DAISHO_RS232_A_DTR,
	input	wire	DAISHO_RS232_A_RXD,
	input	wire	DAISHO_RS232_A_CTS,
	input	wire	DAISHO_RS232_A_CD,
	input	wire	DAISHO_RS232_A_RI,
	input	wire	DAISHO_RS232_A_DSR,
	
	// DTE
	output	wire	DAISHO_RS232_B_RXD,
	output	wire	DAISHO_RS232_B_CTS,
	output	wire	DAISHO_RS232_B_CD,
	output	wire	DAISHO_RS232_B_RI,
	output	wire	DAISHO_RS232_B_DSR,
	input	wire	DAISHO_RS232_B_RTS,
	input	wire	DAISHO_RS232_B_TXD,
	input	wire	DAISHO_RS232_B_DTR,
	
	// DCE
	output	wire	DAISHO_RS232_C_RTS,
	output	wire	DAISHO_RS232_C_TXD,
	output	wire	DAISHO_RS232_C_DTR,
	input	wire	DAISHO_RS232_C_RXD,
	input	wire	DAISHO_RS232_C_CTS,
	input	wire	DAISHO_RS232_C_CD,
	input	wire	DAISHO_RS232_C_RI,
	input	wire	DAISHO_RS232_C_DSR,
	
	// DTE
	output	wire	DAISHO_RS232_D_RXD,
	output	wire	DAISHO_RS232_D_CTS,
	output	wire	DAISHO_RS232_D_CD,
	output	wire	DAISHO_RS232_D_RI,
	output	wire	DAISHO_RS232_D_DSR,
	input	wire	DAISHO_RS232_D_RTS,
	input	wire	DAISHO_RS232_D_TXD,
	input	wire	DAISHO_RS232_D_DTR,

	output	wire	DAISHO_RS232_SD_ALL
);

assign DAISHO_RS232_SD_ALL = 0;

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

wire uart_reset = reset;

assign DAISHO_RS232_B_CTS = 0;
assign DAISHO_RS232_B_CD = 0;
assign DAISHO_RS232_B_RI = 0;
assign DAISHO_RS232_B_DSR = 0;

uart_debug uart_debug_0 (
	.clk_50		( clk_50 ),
	.reset      ( uart_reset ),
	.mii_clk	( phy0_gm_rx_clk ),
	.mii_in		( phy0_gm_rxd ), 
	.mii_en		( phy0_gm_rx_dv ),
	.uart_tx	( DAISHO_RS232_B_RXD )
);

assign DAISHO_RS232_D_CTS = 0;
assign DAISHO_RS232_D_CD = 0;
assign DAISHO_RS232_D_RI = 0;
assign DAISHO_RS232_D_DSR = 0;

uart_debug uart_debug_1 (
	.clk_50		( clk_50 ),
	.reset      ( uart_reset ),
	.mii_clk	( phy1_gm_rx_clk ),
	.mii_in		( phy1_gm_rxd ), 
	.mii_en		( phy1_gm_rx_dv ),
	.uart_tx	( DAISHO_RS232_D_RXD )
);

endmodule
