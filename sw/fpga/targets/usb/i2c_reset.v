//
// I2C peripheral reset controller
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

module i2c_reset (
	input		clock_i,
	input		reset_i,
	input		request_i,
	output	reset_o,
	output	ready_o
);

/* I2C peripheral reset controller */

parameter	[1:0]		ST_UNINIT	= 'd0,
							ST_RESET	= 'd1,
							ST_WAIT	= 'd2,
							ST_READY	= 'd3;

reg						reset_q = 0;
reg						ready_q = 0;

reg	[1:0]				state_q = ST_UNINIT;
reg	[31:0]			count_q = 0;

parameter				DURATION_RESET	= 'd50;	// 1us
parameter				DURATION_WAIT	= 'd50;	// 1us

assign	reset_o = reset_q;
assign	ready_o = ready_q;

always @(posedge clock_i) begin
	reset_q <= 0;
	ready_q <= 0;
	count_q <= 0;
	
	if( reset_i ) begin
		state_q <= ST_UNINIT;
	end
	else begin
		case( state_q )
		ST_UNINIT: begin
			if( request_i )
				state_q <= ST_RESET;
		end
		
		ST_RESET: begin
			reset_q <= 1;
			count_q <= count_q + 1;
			if( count_q == DURATION_RESET ) begin
				state_q <= ST_WAIT;
				count_q <= 0;
			end
		end
		
		ST_WAIT: begin
			count_q <= count_q + 1;
			if( count_q == DURATION_WAIT ) begin
				state_q <= ST_READY;
			end
		end
		
		ST_READY: begin
			ready_q <= 1;
			if( request_i )
				state_q <= ST_RESET;
		end
		
		default: begin
			state_q <= ST_RESET;
		end
		
		endcase
	end
end

endmodule
