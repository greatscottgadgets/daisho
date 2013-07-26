//
// RS-232 tap with usb 2.0 to host,
// for DE2-115 board, SMSC USB3300 PHY and RS-232 front-end
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

module rs232_top (
	
input	wire			clk_50,
	
input	wire			usb_ulpi_clk,
inout	wire	[7:0]	usb_ulpi_d,
input	wire			usb_ulpi_dir,
output	wire			usb_ulpi_stp,
input	wire			usb_ulpi_nxt,

// Hex LEDs
output	wire	[6:0]	HEX0,
output	wire	[6:0]	HEX1,
output	wire	[6:0]	HEX2,
output	wire	[6:0]	HEX3,
output	wire	[6:0]	HEX4,
output	wire	[6:0]	HEX5,
output	wire	[6:0]	HEX6,
output	wire	[6:0]	HEX7,

input		wire	[3:0]	KEY,
input		wire 	[17:0] SW,
output	wire	[17:0] LEDR,
output   wire	[8:0] LEDG,

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

	wire	[17:0]	led_r;
	assign LEDR = led_r;
	
	assign led_r[17:16] = dbg_linestate;
	assign led_r[15] = usb_connected;
	assign led_r[14] = usb_configured;
	assign led_r[12] = rs232_status_full;
	assign led_r[11] = rs232_status_empty;
	assign led_r[10:0] = dbg_frame_num;
	
	wire 	[8:0]		led_g;
	assign LEDG = led_g;
	
	assign led_g[0] = vend_req_act;
	
	wire	[17:0]	sw = SW;
	wire 	[3:0]		key = ~KEY;
	
	reg			reset;

always @(posedge clk_50) begin
	reset <= key[0];
	count_1 <= count_1 + 1'b1;
end

	reg	[26:0]	count_1;
	reg	[26:0]	count_2;
		
always @(posedge usb_ulpi_clk) begin
	count_2 <= count_2 + 1'b1;
end


////////////////////////////////////////////////////////////
//
// USB 2.0 controller
//
////////////////////////////////////////////////////////////

	wire			usb_reset_n;
	wire			usb_connected;
	wire			usb_configured;
	wire	[1:0]	dbg_linestate;
	wire	[10:0]	dbg_frame_num;

	wire	[7:0]	usb_ulpi_d_in;
	wire	[7:0]	usb_ulpi_d_out;
	wire			usb_ulpi_d_oe;
	
	assign usb_ulpi_d_in = usb_ulpi_d;
	assign usb_ulpi_d = (usb_ulpi_d_oe ? usb_ulpi_d_out : 8'bZZZZZZZZ);

usb2_top	iu2 (
	.ext_clk					( clk_50 ),
	.reset_n					( ~reset ),
	.reset_n_out			( usb_reset_n ),
	
	.opt_enable_hs			( 1'b1 ),
	.stat_connected		( usb_connected ),
	.stat_configured		( usb_configured ),
	
	.phy_ulpi_clk			( usb_ulpi_clk ),
	.phy_ulpi_d_in			( usb_ulpi_d_in ),
	.phy_ulpi_d_out		( usb_ulpi_d_out ),
	.phy_ulpi_d_oe			( usb_ulpi_d_oe ),
	.phy_ulpi_dir			( usb_ulpi_dir ),
	.phy_ulpi_stp			( usb_ulpi_stp ),
	.phy_ulpi_nxt			( usb_ulpi_nxt ),
	
	.buf_in_addr			( buf_in_addr ),
	.buf_in_data			( buf_in_data ),
	.buf_in_wren			( buf_in_wren ),
	.buf_in_ready			( buf_in_ready ),
	.buf_in_commit			( buf_in_commit ),
	.buf_in_commit_len	( buf_in_commit_len ),
	.buf_in_commit_ack	( buf_in_commit_ack ),
	
	.buf_out_addr			( buf_out_addr ),
	.buf_out_q				( buf_out_q ),
	.buf_out_len			( buf_out_len ),
	.buf_out_hasdata		( buf_out_hasdata ),
	.buf_out_arm			( buf_out_arm ),
	.buf_out_arm_ack		( buf_out_arm_ack ),
	
	.vend_req_act			( vend_req_act ),
	.vend_req_request		( vend_req_request ),
	.vend_req_val			( vend_req_val ),
	
	.dbg_linestate			( dbg_linestate ),
	.dbg_frame_num			( dbg_frame_num )
);


/////////////////////////////////////////////
//
// RS232
//
/////////////////////////////////////////////

	reg	[8:0]		buf_in_addr;
	reg	[7:0]		buf_in_data;
	reg				buf_in_wren;
	wire				buf_in_ready;
	reg				buf_in_commit;
	reg	[9:0]		buf_in_commit_len;
	wire				buf_in_commit_ack;
	
	wire	[8:0]		buf_out_addr;
	wire	[7:0]		buf_out_q;
	wire	[9:0]		buf_out_len;
	wire				buf_out_hasdata;
	wire				buf_out_arm;
	wire				buf_out_arm_ack;
	
	wire				vend_req_act;
	wire	[7:0]		vend_req_request;
	wire	[15:0]	vend_req_val;

io_seg7 is7 (
	.disp_in	( rs232_status_used[7:4] ),
	.disp_out	( HEX7 )
);

io_seg7 is6 (
	.disp_in	( rs232_status_used[3:0] ),
	.disp_out	( HEX6 )
);

io_seg7 is5 (
	.disp_in	( vend_req_request[7:4] ),
	.disp_out	( HEX5 )
);

io_seg7 is4 (
	.disp_in	( vend_req_request[3:0] ),
	.disp_out	( HEX4 )
);

io_seg7 is3 (
	.disp_in	( vend_req_val[15:12] ),
	.disp_out	( HEX3 )
);

io_seg7 is2 (
	.disp_in	( vend_req_val[11:8] ),
	.disp_out	( HEX2 )
);

io_seg7 is1 (
	.disp_in	( vend_req_val[7:4] ),
	.disp_out	( HEX1 )
);

io_seg7 is0 (
	.disp_in	( vend_req_val[3:0] ),
	.disp_out	( HEX0 )
);

reg [31:0] rs232_timestamp;

wire rs232_status_clk = clk_50;
wire rs232_status_flush = reset;

reg rs232_status_wren;
wire [71:0] rs232_status_wrdata;

reg rs232_status_rden;
wire [71:0] rs232_status_rddata;

wire rs232_status_full;
wire rs232_status_empty;
wire [7:0] rs232_status_used;

mf_rs232_status rs232_status (
	.clock 		( rs232_status_clk ),
	.sclr		( rs232_status_flush ),
	
	.wrreq		( rs232_status_wren ),
	.data		( rs232_status_wrdata ),
	.rdreq		( rs232_status_rden ),
	.q			( rs232_status_rddata ),
	
	.full		( rs232_status_full ),
	.empty		( rs232_status_empty ),
	.usedw		( rs232_status_used )
);

wire	[31:0]	rs232_status_raw = {
	3'b000,
	DAISHO_RS232_A_RXD,
	DAISHO_RS232_A_CTS,
	DAISHO_RS232_A_CD,
	DAISHO_RS232_A_RI,
	DAISHO_RS232_A_DSR,
	5'b00000,
	DAISHO_RS232_B_RTS,
	DAISHO_RS232_B_TXD,
	DAISHO_RS232_B_DTR,
	3'b000,
	DAISHO_RS232_C_RXD,
	DAISHO_RS232_C_CTS,
	DAISHO_RS232_C_CD,
	DAISHO_RS232_C_RI,
	DAISHO_RS232_C_DSR,
	5'b00000,
	DAISHO_RS232_D_RTS,
	DAISHO_RS232_D_TXD,
	DAISHO_RS232_D_DTR
};

reg		[31:0]	rs232_status_q0;
reg		[31:0]	rs232_status_q1;

assign rs232_status_wrdata = {
	8'h00, rs232_timestamp, rs232_status_q1
};

always @(posedge rs232_status_clk) begin
	{ rs232_status_q1, rs232_status_q0 } <= { rs232_status_q0, rs232_status_raw };
	rs232_status_wren <= (rs232_status_q0 != rs232_status_q1) ? 1'b1 : 1'b0;
	rs232_timestamp <= rs232_timestamp + 1;
end

reg			[5:0]	state;
parameter	[5:0]	ST_RST		= 6'h00,
					ST_IDLE		= 6'h01,
					ST_ACTIVE	= 6'h03;

reg		buf_in_ready_1;
reg		buf_in_commit_ack_1;

always @(posedge rs232_status_clk) begin
	buf_in_ready_1 <= buf_in_ready;
	buf_in_commit_ack_1 <= buf_in_commit_ack;
	
	rs232_status_rden <= 0;
	buf_in_wren <= 0;
	buf_in_commit <= 0;
	
	case(state)
	ST_RST: begin
		state <= ST_IDLE;
	end
	
	ST_IDLE: begin
		//if( vend_req_act_1 & ~vend_req_act_2 & ~rs232_status_rdempty ) begin
		if( usb_configured & buf_in_ready_1 & ~rs232_status_empty ) begin
			rs232_status_rden <= 1;
			state <= 9;
		end
	end
	
	9: begin
		state <= 10;
	end
	
	10: begin
		buf_in_data <= rs232_status_rddata[63:56];
		buf_in_addr <= 0;
		buf_in_wren <= 1;
		state <= 11;
	end
	
	11: begin
		buf_in_data <= rs232_status_rddata[55:48];
		buf_in_addr <= 1;
		buf_in_wren <= 1;
		state <= 12;
	end
	
	12: begin
		buf_in_data <= rs232_status_rddata[47:40];
		buf_in_addr <= 2;
		buf_in_wren <= 1;
		state <= 13;
	end
	
	13: begin
		buf_in_data <= rs232_status_rddata[39:32];
		buf_in_addr <= 3;
		buf_in_wren <= 1;
		state <= 14;
	end
	
	14: begin
		buf_in_data <= rs232_status_rddata[31:24];
		buf_in_addr <= 4;
		buf_in_wren <= 1;
		state <= 15;
	end
	
	15: begin
		buf_in_data <= rs232_status_rddata[23:16];
		buf_in_addr <= 5;
		buf_in_wren <= 1;
		state <= 16;
	end
	
	16: begin
		buf_in_data <= rs232_status_rddata[15:8];
		buf_in_addr <= 6;
		buf_in_wren <= 1;
		state <= 17;
	end
	
	17: begin
		buf_in_data <= rs232_status_rddata[7:0];
		buf_in_addr <= 7;
		buf_in_wren <= 1;
		state <= 18;
	end
	
	18: begin
		buf_in_commit <= 1;
		buf_in_commit_len <= 8;
		if( buf_in_commit_ack_1 ) begin
			state <= 19;
		end
	end
	
	19: begin
		if( buf_in_commit_ack_1 == 0 ) begin
			state <= ST_IDLE;
		end
	end
	
	endcase
end

assign DAISHO_RS232_SD_ALL = 0;

assign DAISHO_RS232_A_RTS = DAISHO_RS232_B_RTS;
assign DAISHO_RS232_A_TXD = DAISHO_RS232_B_TXD;
assign DAISHO_RS232_A_DTR = DAISHO_RS232_B_DTR;
assign DAISHO_RS232_B_RXD = DAISHO_RS232_A_RXD;
assign DAISHO_RS232_B_CTS = DAISHO_RS232_A_CTS;
assign DAISHO_RS232_B_CD = DAISHO_RS232_A_CD;
assign DAISHO_RS232_B_RI = DAISHO_RS232_A_RI;
assign DAISHO_RS232_B_DSR = DAISHO_RS232_A_DSR;

assign DAISHO_RS232_C_RTS = DAISHO_RS232_D_RTS;
assign DAISHO_RS232_C_TXD = DAISHO_RS232_D_TXD;
assign DAISHO_RS232_C_DTR = DAISHO_RS232_D_DTR;
assign DAISHO_RS232_D_RXD = DAISHO_RS232_C_RXD;
assign DAISHO_RS232_D_CTS = DAISHO_RS232_C_CTS;
assign DAISHO_RS232_D_CD = DAISHO_RS232_C_CD;
assign DAISHO_RS232_D_RI = DAISHO_RS232_C_RI;
assign DAISHO_RS232_D_DSR = DAISHO_RS232_C_DSR;

endmodule
