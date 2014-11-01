//
// TCA6416A I2C writer for configuration and I/O
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

module i2c_tca6416a_writer (
	input					clock_i,
	input					reset_i,
	
	input					unit_i,
	input		[7:0]		command_i,
	input		[7:0]		data_0_i,
	input		[7:0]		data_1_i,
	
	input					start_i,
	output				stop_o,
	
	input		[1:0]		bit_phase_i,
	input					bit_phase_inc_i,
	
	output				scl_o,
	output				sda_o
);

/* I2C constants */

parameter	I2C_DIR_WRITE	= 1'b0,
				I2C_DIR_READ	= 1'b1;

parameter SLAVE_ADDR_PREFIX = 6'b010000;

wire 			[6:0]		slave_address = { SLAVE_ADDR_PREFIX, unit_i };

parameter XFER_LENGTH = 'd39;

/* NOTE: Array indexed in reverse to make addressing simpler. */
wire [0:XFER_LENGTH - 1] xfer_data = {
	1'b0,				// Start
	slave_address,
	I2C_DIR_WRITE,
	1'b1,				// Ack from slave
	command_i,
	1'b1,				// Ack from slave
	data_0_i,		// Data: Configuration port 0
	1'b1,				// Ack from slave
	data_1_i,		// Data: Configuration port 1
	1'b1,				// Ack from slave
	1'b0,				// Stop
	1'b1				// Idle
};

/* NOTE: Array indexed in reverse to make addressing simpler. */
wire [0:XFER_LENGTH - 1] xfer_clock_skip = {
	1'b0,				// Start
	7'b0000000,		// IO expander address
	1'b0,				// Direction
	1'b0,				// Ack
	8'b00000000,	// Command
	1'b0,				// Ack
	8'b00000000,	// Data
	1'b0,				// Ack
	8'b00000000,	// Data
	1'b0,				// Ack
	1'b1,				// Stop
	1'b1				// Idle
};

reg		[5:0]		index_q = 0;

reg					scl_q = 0;
reg					sda_q = 0;
reg					running_q = 0;
reg					stop_q = 0;

assign	scl_o = scl_q;
assign	sda_o = sda_q;
assign	stop_o = stop_q;

always @(posedge clock_i) begin
	stop_q <= 0;

	if( reset_i ) begin
		scl_q <= 1;
		sda_q <= 1;
		running_q <= 0;
		index_q <= 0;
	end
	else begin
		if( bit_phase_inc_i ) begin
			if( running_q ) begin
				case( bit_phase_i )
				0: begin
					sda_q <= xfer_data[index_q];
				end
				
				1: begin
					scl_q <= 1;
				end
				
				2: begin
				end
				
				3: begin
					scl_q <= xfer_clock_skip[index_q];
					if( index_q < XFER_LENGTH ) begin
						index_q <= index_q + 1'b1;
					end
					else begin
						stop_q <= 1;
						running_q <= 0;
					end
				end
				
				endcase
			end
			else begin
				scl_q <= 1;
				sda_q <= 1;
				index_q <= 0;
				if( start_i && (bit_phase_i == 3) )
					running_q <= 1;
			end
		end
	end
end

endmodule
