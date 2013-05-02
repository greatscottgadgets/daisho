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
	reg  reset;

	reg	      [5:0] state;
	parameter [5:0] ST_RST          = 6'h00,
                    ST_CONFIG       = 6'h01,
                    ST_CONFIG_DELAY = 6'h02,
                    ST_IDLE         = 6'h03,
                    ST_ACTIVE       = 6'h04;

	reg hold_config;
	reg [4:0] phy0_phyad;
	reg [3:0] phy0_mode;
	reg phy0_clk_125_en;
	assign phy0_addr = (hold_config) ? phy0_phyad : 5'bz;
	assign phy0_gm_rxd[7:4] = 4'bz;
	assign phy0_gm_rxd[3:0] = (hold_config) ? phy0_mode : 4'bz;
	assign phy0_gm_rx_dv = (hold_config) ? phy0_clk_125_en : 1'bz;

	reg [4:0] phy1_phyad;
	reg [3:0] phy1_mode;
	reg phy1_clk_125_en;
	assign phy1_addr = (hold_config) ? phy1_phyad : 5'bz;
	assign phy1_gm_rxd[7:4] = 4'bz;
	assign phy1_gm_rxd[3:0] = (hold_config) ? phy1_mode : 4'bz;
	assign phy1_gm_rx_dv = (hold_config) ? phy1_clk_125_en : 1'bz;

	reg phy0_hw_reset;
	assign phy0_hw_rst = phy0_hw_reset;
	reg phy1_hw_reset;
	assign phy1_hw_rst = phy1_hw_reset;

	reg [12:0] config_delay;

always @(posedge clk_50) begin
	{reset_1, reset} <= {reset, ~KEY[0]};
	if (reset_1) begin
		state <= ST_RST;
	end
	
	case(state)
	ST_RST: begin
		{phy0_hw_reset, phy1_hw_reset} <= {2'b00};
		hold_config <= 1;
		state <= ST_CONFIG;
	end
	
	ST_CONFIG: begin
		// Assign config params, then wait for next state to de-assert reset
		phy0_mode[3:0] <= {4'b0001};   // GMII/MII mode
		phy0_clk_125_en <= 1'b1;       // enable 125MHz clock output
		phy0_phyad[4:0] <= {5'b00001}; // Set MIIM address to '1'

		phy1_mode[3:0] <= {4'b0001};   // GMII/MII mode
		phy1_clk_125_en <= 1'b1;       // enable 125MHz clock output
		phy1_phyad[4:0] <= {5'b00001}; // Set MIIM address to '1'

		{phy0_hw_reset, phy1_hw_reset} <= {2'b11};
		state <= ST_CONFIG_DELAY;
	end

	ST_CONFIG_DELAY: begin
		// Need to hold pins for a while (not sure how long), guessing at
		// 100us due to that being the delay befor using MIIM interface.
		// 100us is 5000 clk_50 ticks.
		config_delay <= config_delay + 1;
		if (config_delay == 13'd5000) begin
			state <= ST_IDLE;
			hold_config <= 0;
		end
	end
	
	ST_IDLE: begin
		led_g[6] <= 1;
	end
	endcase
	
end

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
