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
input	wire	DAISHO_RS232_D_DTR
);

	parameter [5:0]	ST_RST_0		= 6'd0,
					ST_RST_1		= 6'd1,
					ST_IDLE			= 6'd10;
	reg		[5:0]	state;

	reg 			reset_1, reset_2;
	reg				vend_req_act_1, vend_req_act_2;
	reg				buf_in_ready_1, buf_in_ready_2;

	reg		[10:0]	in_byte_count;
	reg		[11:0]	in_bit_count;
	reg		[10:0]	out_byte_count;
	reg		[15:0]	clock_divider;
	reg				idle_buffer;
	reg				idle_full;
	reg		[64:0] input_buffer[0:1];
	reg		[7:0]	line_state_ab;
	reg		[7:0]	line_state_ab_1;
	reg		[7:0]	line_state_cd;
	reg		[7:0]	line_state_cd_1;
	
always @(posedge clk) begin
	{reset_2, reset_1} <= {reset_1, reset_n};
	{vend_req_act_2, vend_req_act_1} <= {vend_req_act_1, vend_req_act};
	{buf_in_ready_2, buf_in_ready_1} <= {buf_in_ready_1, buf_in_ready};

	buf_in_commit <= 0;
	
	case(state)
	ST_RST_0: begin
		// Setup
		out_byte_count <= 0;
		idle_full <= 0;
		idle_buffer <= 0;

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
				idle_buffer <= ~idle_buffer;
				idle_full <= 1;
				//in_bit_count <= 0;
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
		buf_in_data <= input_buffer[idle_buffer][15:8];
		out_byte_count <= out_byte_count + 1'b1;
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
		buf_in_data <= input_buffer[idle_buffer][7:0];
		buf_in_addr <= buf_in_addr + 1'b1;
		out_byte_count <= out_byte_count + 1'b1;
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
		
		if(out_byte_count == 512) begin
			state <= ST_IDLE;
			buf_in_commit <= 1;
			buf_in_commit_len <= 9'd7;
			idle_full <= 0;
			out_byte_count <= 0;
		end
	end
	endcase

	if(~reset_2) begin
		// reset
		state <= 0;
	end

	clock_divider <= clock_divider + 16'b1;
	// Copy RS-232 lines in to buffer
	{ line_state_ab_1, line_state_ab } <= {line_state_ab, {
		DAISHO_RS232_B_TXD, DAISHO_RS232_B_RTS, DAISHO_RS232_B_DTR,
		DAISHO_RS232_A_RXD, DAISHO_RS232_A_CTS, DAISHO_RS232_A_DSR,
		DAISHO_RS232_A_CD, DAISHO_RS232_A_RI}};

	{ line_state_cd_1, line_state_cd } <= {line_state_cd, {
		DAISHO_RS232_D_TXD, DAISHO_RS232_D_RTS, DAISHO_RS232_D_DTR,
		DAISHO_RS232_C_RXD, DAISHO_RS232_C_CTS, DAISHO_RS232_C_DSR,
		DAISHO_RS232_C_CD, DAISHO_RS232_C_RI}};

	if (line_state_ab_1 != line_state_ab) begin
		in_bit_count <= in_bit_count + 11'd24;
		input_buffer[~idle_buffer][in_bit_count -:8] <= line_state_ab;
		input_buffer[~idle_buffer][in_bit_count-16 -:24] <= clock_divider;
	end
	
end

assign {DAISHO_RS232_A_TXD, DAISHO_RS232_A_RTS, DAISHO_RS232_A_DTR,
		DAISHO_RS232_B_RXD, DAISHO_RS232_B_CTS, DAISHO_RS232_B_DSR,
		DAISHO_RS232_B_CD, DAISHO_RS232_B_RI} = line_state_ab;

assign {DAISHO_RS232_C_TXD, DAISHO_RS232_C_RTS, DAISHO_RS232_C_DTR,
		DAISHO_RS232_D_RXD, DAISHO_RS232_D_CTS, DAISHO_RS232_D_DSR,
		DAISHO_RS232_D_CD, DAISHO_RS232_D_RI} = line_state_cd;

endmodule

