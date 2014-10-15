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

input	wire			usb_pipe_pclk,
input	wire	[15:0]	usb_pipe_rx_data,
input	wire	[1:0]	usb_pipe_rx_datak,
input	wire			usb_pipe_rx_valid,
output	wire			usb_pipe_tx_clk,
output	wire	[15:0]	usb_pipe_tx_data,
output	wire	[1:0]	usb_pipe_tx_datak,

output	wire			usb_reset_n,
output	wire			usb_out_enable,
output	wire			usb_phy_reset_n,
output	wire			usb_tx_detrx_lpbk,
output	wire			usb_tx_elecidle,
inout	wire			usb_rx_elecidle,
input	wire	[2:0]	usb_rx_status,
output	wire	[1:0]	usb_power_down,
inout	wire			usb_phy_status,
input	wire			usb_pwrpresent,

output	wire			usb_tx_oneszeros,
output	wire	[1:0]	usb_tx_deemph,
output	wire	[2:0]	usb_tx_margin,
output	wire			usb_tx_swing,
output	wire			usb_rx_polarity,
output	wire			usb_rx_termination,
output	wire			usb_rate,
output	wire			usb_elas_buf_mode,

	// DTE: TRSF3243
	input wire A_INVALID_N,
	output wire A_FORCEOFF_N,
	output wire A_FORCEON,
	input	wire	A_CD,
	input	wire	A_DSR,
	input	wire	A_RXD,
	input	wire	A_CTS,
	input	wire	A_RI,
	output	wire	A_RTS,
	output	wire	A_TXD,
	output	wire	A_DTR,
	
	// DCE: TRS3237E
	output wire B_SHDN_N,
	output wire B_EN_N,
	output wire B_MBAUD,
	input	wire	B_RTS,
	input	wire	B_TXD,
	input	wire	B_DTR,
	output	wire	B_CD,
	output	wire	B_DSR,
	output	wire	B_RXD,
	output	wire	B_CTS,
	output	wire	B_RI,
	
	// DTE: TRSF3243
	input wire C_INVALID_N,
	output wire C_FORCEOFF_N,
	output wire C_FORCEON,
	input	wire	C_CD,
	input	wire	C_DSR,
	input	wire	C_RXD,
	input	wire	C_CTS,
	input	wire	C_RI,
	output	wire	C_RTS,
	output	wire	C_TXD,
	output	wire	C_DTR,
	
	// DCE: TRS3237E
	output wire D_SHDN_N,
	output wire D_EN_N,
	output wire D_MBAUD,
	input	wire	D_RTS,
	input	wire	D_TXD,
	input	wire	D_DTR,
	output	wire	D_CD,
	output	wire	D_DSR,
	output	wire	D_RXD,
	output	wire	D_CTS,
	output	wire	D_RI,
	
	output wire LEDS_PWR
);

	assign A_FORCEOFF_N = 1;
	assign A_FORCEON = 1;
	assign B_SHDN_N = 1;
	assign B_EN_N = 0;
	assign B_MBAUD = 0;
	assign C_FORCEOFF_N = 1;
	assign C_FORCEON = 1;
	assign D_SHDN_N = 1;
	assign D_EN_N = 0;
	assign D_MBAUD = 0;
	assign LEDS_PWR = 1;
	
	reg	[26:0]	count_1;
	reg	[26:0]	count_2;

	reg			reset = 1;
	wire			reset_n;

	assign reset_n = ~reset;
	
initial begin
	reset <= 1;
	count_1 <= 0;
	count_2 <= 0;
end

always @(posedge clk_50) begin
	count_1 <= count_1 + 1'b1;
	
	if( count_1 >= 4096 ) begin
		reset <= 0;
	end
end
		
always @(posedge usb_ulpi_clk) begin
	count_2 <= count_2 + 1'b1;
end


////////////////////////////////////////////////////////////
//
// USB 2.0 controller
//
////////////////////////////////////////////////////////////

	wire			usb_connected;
	wire			usb_configured;
	wire	[1:0]	dbg_linestate;
	wire	[10:0]	dbg_frame_num;

usb2_top	iu2 (
	.ext_clk					( clk_50 ),
	.reset_n					( reset_n ),
	
	.opt_disable_all		( 1'b0 ),
	.opt_enable_hs			( 1'b1 ),
	.opt_ignore_vbus		( 1'b1 ),
	.stat_connected		( usb_connected ),
	.stat_configured		( usb_configured ),
	
	.phy_ulpi_clk			( usb_ulpi_clk ),
	.phy_ulpi_d				( usb_ulpi_d ),
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

////////////////////////////////////////////////////////////
//
// USB 3.0 controller
//
////////////////////////////////////////////////////////////

	wire			usb_clk_125;
	
usb3_top	iu3t (

	.ext_clk				( usb_clk_125 ),
	.clk_125_out			( usb_clk_125 ),
	.reset_n				( reset_n ),

	.phy_pipe_pclk			( usb_pipe_pclk ),
	.phy_pipe_rx_data		( usb_pipe_rx_data ),
	.phy_pipe_rx_datak		( usb_pipe_rx_datak	 ),
	.phy_pipe_rx_valid		( usb_pipe_rx_valid ),
	.phy_pipe_tx_clk		( usb_pipe_tx_clk ),
	.phy_pipe_tx_data		( usb_pipe_tx_data ),
	.phy_pipe_tx_datak		( usb_pipe_tx_datak ),

	.phy_reset_n			( usb_reset_n ),
	.phy_out_enable			( usb_out_enable ),
	.phy_phy_reset_n		( usb_phy_reset_n ),
	.phy_tx_detrx_lpbk		( usb_tx_detrx_lpbk ),
	.phy_tx_elecidle		( usb_tx_elecidle ),
	.phy_rx_elecidle		( usb_rx_elecidle ),
	.phy_rx_status			( usb_rx_status ),
	.phy_power_down			( usb_power_down ),
	.phy_phy_status			( usb_phy_status ),
	.phy_pwrpresent			( usb_pwrpresent ),

	.phy_tx_oneszeros		( usb_tx_oneszeros ),
	.phy_tx_deemph			( usb_tx_deemph ),
	.phy_tx_margin			( usb_tx_margin ),
	.phy_tx_swing			( usb_tx_swing ),
	.phy_rx_polarity		( usb_rx_polarity ),
	.phy_rx_termination		( usb_rx_termination ),
	.phy_rate				( usb_rate ),
	.phy_elas_buf_mode		( usb_elas_buf_mode )
/*	
	.buf_in_addr			( lfsr_buf_in_addr ),
	.buf_in_data			( lfsr_buf_in_data ),
	.buf_in_wren			( lfsr_buf_in_wren ),
	.buf_in_request			( lfsr_buf_in_request ),
	.buf_in_ready			( lfsr_buf_in_ready ),
	.buf_in_commit			( lfsr_buf_in_commit ),
	.buf_in_commit_len		( lfsr_buf_in_commit_len ),
	.buf_in_commit_ack		( lfsr_buf_in_commit_ack ),
	
	.buf_out_addr			( lfsr_buf_out_addr ),
	.buf_out_q				( lfsr_buf_out_q ),
	.buf_out_len			( lfsr_buf_out_len ),
	.buf_out_hasdata		( lfsr_buf_out_hasdata ),
	.buf_out_arm			( lfsr_buf_out_arm ),
	.buf_out_arm_ack		( lfsr_buf_out_arm_ack ),
	
	.vend_req_act			(  ),
	.vend_req_request		(  ),
	.vend_req_val			(  )
*/
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
	A_RXD,
	A_CTS,
	A_CD,
	A_RI,
	A_DSR,
	5'b00000,
	B_RTS,
	B_TXD,
	B_DTR,
	3'b000,
	C_RXD,
	C_CTS,
	C_CD,
	C_RI,
	C_DSR,
	5'b00000,
	D_RTS,
	D_TXD,
	D_DTR
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

assign A_RTS = B_RTS;
assign A_TXD = B_TXD;
assign A_DTR = B_DTR;
assign B_RXD = A_RXD;
assign B_CTS = A_CTS;
assign B_CD = A_CD;
assign B_RI = A_RI;
assign B_DSR = A_DSR;

assign C_RTS = D_RTS;
assign C_TXD = D_TXD;
assign C_DTR = D_DTR;
assign D_RXD = C_RXD;
assign D_CTS = C_CTS;
assign D_CD = C_CD;
assign D_RI = C_RI;
assign D_DSR = C_DSR;

endmodule
