//
// RS-232 tap with usb 2.0 to host,
// for DE2-115 board, SMSC USB3300 PHY and RS-232 front-end
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

module rs232_top (
	
input	wire			clk_50,
	
input	wire			usb_ulpi_clk,
inout	wire	[7:0]	usb_ulpi_d,
input	wire			usb_ulpi_dir,
output	wire			usb_ulpi_stp,
input	wire			usb_ulpi_nxt,

output	wire	[20:0]	dbg_sevseg,
input	wire	[3:0]	dbg_button,
output	reg		[17:0]	dbg_led,
	
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

	reg			reset_n;

always @(posedge clk_50) begin
	reset_n <= dbg_button[0];
	dbg_led[0] <= reset_n;
	
	count_1 <= count_1 + 1'b1;
	dbg_led[1] <= count_1[26];
	
end

	reg	[26:0]	count_1;
	reg	[26:0]	count_2;
		
always @(posedge usb_ulpi_clk) begin
	count_2 <= count_2 + 1'b1;
	dbg_led[17] <= count_2[26];
	dbg_led[16] <= ~dbg_button[1];
	dbg_led[15] <= usb_connected;
	
	dbg_led[7:6] <= dbg_linestate;
end


////////////////////////////////////////////////////////////
//
// USB 2.0 controller
//
////////////////////////////////////////////////////////////

	wire			usb_reset_n;
	wire			usb_connected;
	wire	[1:0]	dbg_linestate;
	wire	[10:0]	dbg_frame_num;
	
usb2_top	iu2 (
	.ext_clk			( clk_50 ),
	.reset_n			( reset_n ),
	.reset_n_out		( usb_reset_n ),
	
	.opt_enable_hs		( 1'b1 ),
	.stat_connected		( usb_connected ),
	
	.phy_ulpi_clk		( usb_ulpi_clk ),
	.phy_ulpi_d			( usb_ulpi_d ),
	.phy_ulpi_dir		( usb_ulpi_dir ),
	.phy_ulpi_stp		( usb_ulpi_stp ),
	.phy_ulpi_nxt		( usb_ulpi_nxt ),
	
	.buf_in_addr		( usb_buf_in_addr ),
	.buf_in_data		( usb_buf_in_data ),
	.buf_in_wren		( usb_buf_in_wren ),
	.buf_in_ready		( usb_buf_in_ready ),
	.buf_in_commit		( usb_buf_in_commit ),
	.buf_in_commit_len	( usb_buf_in_commit_len ),
	.buf_in_commit_ack	( usb_buf_in_commit_ack ),
	
	.buf_out_addr		( usb_buf_out_addr ),
	.buf_out_q			( usb_buf_out_q ),
	.buf_out_len		( usb_buf_out_len ),
	.buf_out_hasdata	( usb_buf_out_hasdata ),
	.buf_out_arm		( usb_buf_out_arm ),
	.buf_out_arm_ack	( usb_buf_out_arm_ack ),
	
	.vend_req_act		( usb_vend_req_act ),
	.vend_req_request	( usb_vend_req_request ),
	.vend_req_val		( usb_vend_req_val ),
	
	.dbg_linestate		( dbg_linestate ),
	.dbg_frame_num		( dbg_frame_num )
);


/////////////////////////////////////////////
//
// RS232
//
/////////////////////////////////////////////
	
io_rs232 rs (
	.clk			( clk_50 ),
	.reset_n		( reset_n ),
	
	.buf_in_addr		( usb_buf_in_addr ),
	.buf_in_data		( usb_buf_in_data ),
	.buf_in_wren		( usb_buf_in_wren ),
	.buf_in_ready		( usb_buf_in_ready ),
	.buf_in_commit		( usb_buf_in_commit ),
	.buf_in_commit_len	( usb_buf_in_commit_len ),
	.buf_in_commit_ack	( usb_buf_in_commit_ack ),
	
	.vend_req_act		( usb_vend_req_act ),
	.vend_req_request	( usb_vend_req_request ),
	.vend_req_val		( usb_vend_req_val ),

	.DAISHO_RS232_A_RTS	(DAISHO_RS232_A_RTS),
	.DAISHO_RS232_A_TXD	(DAISHO_RS232_A_TXD),
	.DAISHO_RS232_A_DTR	(DAISHO_RS232_A_DTR),
	.DAISHO_RS232_A_RXD	(DAISHO_RS232_A_RXD),
	.DAISHO_RS232_A_CTS	(DAISHO_RS232_A_CTS),
	.DAISHO_RS232_A_CD	(DAISHO_RS232_A_CD),
	.DAISHO_RS232_A_RI	(DAISHO_RS232_A_RI),
	.DAISHO_RS232_A_DSR	(DAISHO_RS232_A_DSR),

	.DAISHO_RS232_B_RXD	(DAISHO_RS232_B_RXD),
	.DAISHO_RS232_B_CTS	(DAISHO_RS232_B_CTS),
	.DAISHO_RS232_B_CD	(DAISHO_RS232_B_CD),
	.DAISHO_RS232_B_RI	(DAISHO_RS232_B_RI),
	.DAISHO_RS232_B_DSR	(DAISHO_RS232_B_DSR),
	.DAISHO_RS232_B_RTS	(DAISHO_RS232_B_RTS),
	.DAISHO_RS232_B_TXD	(DAISHO_RS232_B_TXD),
	.DAISHO_RS232_B_DTR	(DAISHO_RS232_B_DTR)
);

io_seg7 is2 (
	.disp_in	( dbg_frame_num[10:8] ),
	.disp_out	( dbg_sevseg[20:14] )
);

io_seg7 is1 (
	.disp_in	( dbg_frame_num[7:4] ),
	.disp_out	( dbg_sevseg[13:7] )
);

io_seg7 is0 (
	.disp_in	( dbg_frame_num[3:0] ),
	.disp_out	( dbg_sevseg[6:0] )
);

endmodule

	