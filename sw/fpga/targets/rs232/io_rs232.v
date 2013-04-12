//
// RS232 to USB interface
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

module io_rs232 (

input	wire			clk,
input	wire			reset_n,

// USB endpoint
output	reg		[8:0]	buf_in_addr,
output	reg		[7:0]	buf_in_data,
output	reg				buf_in_wren,
input	wire			buf_in_ready,
output	reg				buf_in_commit,
output	reg		[9:0]	buf_in_commit_len,
input	wire			buf_in_commit_ack,

input	wire			vend_req_act,
input	wire	[7:0]	vend_req_request,
input	wire	[15:0]	vend_req_val,

// RS-232 lines
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
input	wire	DAISHO_RS232_B_DTR
);

	parameter [5:0]	ST_RST_0		= 6'd0,
					ST_RST_1		= 6'd1,
					ST_IDLE			= 6'd10;
	reg		[5:0]	state;

	reg 			reset_1, reset_2;
	reg				vend_req_act_1, vend_req_act_2;
	reg				buf_in_ready_1, buf_in_ready_2;

	reg		[10:0]	byte_count;
	reg		[15:0]	clock_divider;
	reg				active_buffer;
	reg				idle_full;
	reg		[4095:0] input_buffer[0:1];

always @(posedge clk) begin
	clock_divider <= clock_divider + 1;
	if(clock_divider[15]) begin
		clock_divider <= 0;
		active_buffer <= ~active_buffer;
	end
	
	{reset_2, reset_1} <= {reset_1, reset_n};
	{vend_req_act_2, vend_req_act_1} <= {vend_req_act_1, vend_req_act};
	{buf_in_ready_2, buf_in_ready_1} <= {buf_in_ready_1, buf_in_ready};

	buf_in_commit <= 0;
	
	case(state)
	ST_RST_0: begin
		// Setup
		byte_count <= 0;
		idle_full <= 0;
		active_buffer <= 0;
		input_buffer[0][4095:0] <= 4096'b0;
		input_buffer[1][4095:0] <= 4096'b1;

		state <= ST_RST_1;
	end
	ST_RST_1: begin
		state <= ST_IDLE;
	end

	ST_IDLE: begin
		if(vend_req_act_1 & ~vend_req_act_2) begin
			// vendor request!
			// wants to read from SRAM
			if(vend_req_request == 8'h01) begin
				idle_full <= 1;
			end
		end
		if(idle_full) begin
			state <= 20;
		end
	end
	
	// Write data from buffer to Endpoint
	20: begin
		if(buf_in_ready_2) state <= 21;
	end
	21: begin
		buf_in_data <= input_buffer[active_buffer][15:8];
		byte_count <= byte_count + 1'b1;
		state <= 22;
	end
	22: begin
		buf_in_wren <= 1;
		state <= 23;
	end
	23: begin
		buf_in_wren <= 0;
		state  <= 27;
	end
	27: begin
		buf_in_data <= input_buffer[active_buffer][7:0];
		buf_in_addr <= buf_in_addr + 1'b1;
		byte_count <= byte_count + 1'b1;
		state <= 24;
	end
	24: begin
		buf_in_wren <= 1;
		state <= 25;
	end
	25: begin	
		buf_in_wren <= 0;
		buf_in_addr <= buf_in_addr + 1'b1;
		state <= 20;
		
		if(byte_count == 512) begin
			state <= ST_IDLE;
			buf_in_commit <= 1;
			buf_in_commit_len <= 9'b1;
			idle_full <= 0;
			byte_count <= 0;
		end
	end
	endcase

	if(~reset_2) begin
		// reset
		state <= 0;
	end
end

assign DAISHO_RS232_A_TXD = DAISHO_RS232_B_TXD;
assign DAISHO_RS232_A_RTS = DAISHO_RS232_B_RTS;
assign DAISHO_RS232_A_DTR = DAISHO_RS232_B_DTR;
assign DAISHO_RS232_B_RXD = DAISHO_RS232_A_RXD;
assign DAISHO_RS232_B_CTS = DAISHO_RS232_A_CTS;
assign DAISHO_RS232_B_DSR = DAISHO_RS232_A_DSR;
assign DAISHO_RS232_B_CD = DAISHO_RS232_A_CD;
assign DAISHO_RS232_B_RI = DAISHO_RS232_A_RI;

endmodule
