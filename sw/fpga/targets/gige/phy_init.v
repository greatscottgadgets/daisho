//
// for DE2-115 board and GigE front-end
// Set initial settings for Micrel PHYs
//
// Copyright (c) 2013 Dominic Spill
//
// This file is part of Daisho.
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

module phy_init (

	input   wire          clk_50,	
	input   wire          reset_n,

	// Inputs (outputs in configuration mode)
	inout   wire  [7:0]   phy_gm_rxd,
	inout   wire          phy_gm_rx_dv,
	inout   wire  [4:0]   phy_addr,
	output  wire          phy_hw_rst,

	output  reg           phy_ready
);


	reg       [2:0] state;
	parameter [2:0] ST_RST          = 3'h0,
                    ST_CONFIG       = 3'h1,
                    ST_CONFIG_DELAY = 3'h2,
                    ST_IDLE         = 3'h3,
                    ST_ACTIVE       = 3'h4;

	reg hold_config;
	reg [4:0] phy_phyad;
	reg [3:0] phy_mode;
	reg phy_clk_125_en;
	assign phy_addr = (hold_config) ? phy_phyad : 5'bz;
	assign phy_gm_rxd[7:4] = 4'bz;
	assign phy_gm_rxd[3:0] = (hold_config) ? phy_mode : 4'bz;
	assign phy_gm_rx_dv = (hold_config) ? phy_clk_125_en : 1'bz;

	reg phy_hw_reset;
	assign phy_hw_rst = phy_hw_reset;

	reg [12:0] config_delay;

always @(posedge clk_50) begin
	if (reset_n) begin
		state <= ST_RST;
		phy_ready <= 0;
	end
	
	case(state)
	ST_RST: begin
		phy_hw_reset <= 1'b0;
		hold_config <= 1;
		state <= ST_CONFIG;
	end
	
	ST_CONFIG: begin
		// Assign config params, then wait for next state to de-assert reset
		phy_mode[3:0] <= {4'b0001};   // GMII/MII mode
		phy_clk_125_en <= 1'b1;       // enable 125MHz clock output
		phy_phyad[4:0] <= {5'b00001}; // Set MIIM address to '1'


		phy_hw_reset <= 1'b1;
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
		phy_ready <= 1;
	end
	endcase
	
end

endmodule
