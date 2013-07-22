//
// for DE2-115 board and GigE front-end
// Set initial settings for Micrel PHYs
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

module phy_init (
	input   wire            clk_i,

	input   wire            reset_i,
	output  wire            ready_o,

	// Inputs (outputs in configuration mode)
	output  wire    [7:0]   phy_rxd,
	output  wire            phy_rx_dv,
	output  wire    [4:0]   phy_addr,
	output  wire            phy_reset_n_o
);

wire    [4:0]   phy_phyad = 5'b00001;   // Set MIIM address to '1'
wire    [3:0]   phy_mode = 4'b0001;     // GMII/MII mode
wire            phy_clk_125_en = 1;     // Enable 125MHz clock output

parameter [3:0] ST_RESET        = 4'h00,
				ST_STRAP        = 4'h01,
				ST_WAIT         = 4'h02,
				ST_IDLE         = 4'h03
				;
reg     [3:0]   state = ST_RESET;

wire            state_reset = (state == ST_RESET);
wire            state_strap = (state == ST_STRAP);
assign          phy_reset_n_o = !state_reset;

wire            bootstrap = state_reset || state_strap;
assign          phy_addr = bootstrap ? phy_phyad : 5'bzzzzz;
assign          phy_rxd = bootstrap ? { 4'bzzzz, phy_mode } : 8'bzzzzzzzz;
assign          phy_rx_dv = bootstrap ? phy_clk_125_en : 1'bz;

reg             ready = 0;
assign          ready_o = ready;

reg     [23:0]  count = 0;

always @(posedge clk_i) begin
	ready <= 0;
	count <= count + 24'h1;

	if (reset_i) begin
		state <= ST_RESET;
		count <= 0;
	end
	else
	begin
		case(state)
		ST_RESET: begin
			state <= ST_RESET;
			if (count == 500000) begin    // Wait 10 msec.
				state <= ST_STRAP;
				count <= 0;
			end
		end

		ST_STRAP: begin
			state <= ST_STRAP;
			if (count == 50) begin      // Wait 1 usec.
				state <= ST_WAIT;
				count <= 0;
			end
		end
		
		ST_WAIT: begin
			state <= ST_WAIT;
			if (count == 5000) begin    // Wait 100 usec for MIIM ready.
				state <= ST_IDLE;
				count <= 0;
			end
		end

		ST_IDLE: begin
			state <= ST_IDLE;
			ready <= 1;
		end
		endcase
	end 
end

endmodule
