//
// 1000BASE-T tap,
// for Daisho main board and GigE front-end
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

module gige_top (
	// Clocking ////////////////////////////////////////////////////////

	input		wire				clk_50,

	// DDR2 ////////////////////////////////////////////////////////////

	output	wire	[15:0]	mem_addr,
	output	wire	[ 2:0]	mem_ba,
	output	wire				mem_cas_n,
	output	wire	[ 1:0]	mem_cke,
	inout		wire	[ 1:0]	mem_clk,
	inout		wire	[ 1:0]	mem_clk_n,
	output	wire	[ 1:0]	mem_cs_n,
	output	wire	[ 7:0]	mem_dm,
	inout		wire	[63:0]	mem_dq,
	inout		wire	[ 7:0]	mem_dqs,
	output	wire	[ 1:0]	mem_odt,
	output	wire				mem_ras_n,
	output	wire				mem_we_n,

	// USB /////////////////////////////////////////////////////////////

	// USB: PIPE
	output	wire				usb_pipe_tx_clk,
	output	wire	[15:0]	usb_pipe_tx_data,
	output	wire	[ 1:0]	usb_pipe_tx_datak,
	input		wire				usb_pipe_pclk,
	input		wire	[15:0]	usb_pipe_rx_data,
	input		wire	[ 1:0]	usb_pipe_rx_datak,
	input		wire				usb_pipe_rx_valid,

	// USB: Control and Status
	output	wire				usb_phy_reset_n,
	output	wire				usb_tx_detrx_lpbk,
	output	wire				usb_tx_elecidle,
	inout		wire				usb_rx_elecidle,
	input		wire	[ 2:0]	usb_rx_status,
	output	wire	[ 1:0]	usb_power_down,
	inout		wire				usb_phy_status,
	input		wire				usb_pwrpresent,

	// USB: Configuration
	output	wire				usb_tx_oneszeros,
	output	wire	[ 1:0]	usb_tx_deemph,
	output	wire	[ 2:0]	usb_tx_margin,
	output	wire				usb_tx_swing,
	output	wire				usb_rx_polarity,
	output	wire				usb_rx_termination,
	output	wire				usb_rate,
	output	wire				usb_elas_buf_mode,

	// USB: ULPI
	input		wire				usb_ulpi_clk,
	inout		wire	[ 7:0]	usb_ulpi_d,
	input		wire				usb_ulpi_dir,
	output	wire				usb_ulpi_stp,
	input		wire				usb_ulpi_nxt,
	input		wire				usb_id,

	// USB: Reset and Output Control Interface
	output	wire				usb_reset_n,
	output	wire				usb_out_enable,

	// Ethernet PHY 0 //////////////////////////////////////////////////

	// GMII/MII: Receive
	inout		wire	[ 7:0]	phy0_gm_rxd,
	inout		wire				phy0_gm_rx_dv,
	input		wire				phy0_gm_rx_er,
	input		wire				phy0_gm_rx_clk,

	// GMII/MII: Transmit
	output	wire	[ 7:0]	phy0_gm_txd,
	output	wire				phy0_gm_tx_en,
	output	wire				phy0_gm_tx_er,
	output	wire				phy0_gm_gtx_clk,
	input		wire				phy0_tx_clk,

	// Have internal pull-up (not sure how that affects the FPGA)
	output	wire				phy0_mdc,
	inout		wire				phy0_mio,
	output	wire				phy0_reset_n,

	// Used for configuration mode (LED states in all other modes)
	inout		wire	[ 2:0]	phy0_addr,

	input		wire				phy0_int_n,
	inout		wire				phy0_clk125_ndo,
	input		wire				phy0_col,
	input		wire				phy0_crs,

	// Ethernet PHY 1 //////////////////////////////////////////////////

	// GMII/MII: Receive
	inout		wire	[ 7:0]	phy1_gm_rxd,
	inout		wire				phy1_gm_rx_dv,
	input		wire				phy1_gm_rx_er,
	input		wire				phy1_gm_rx_clk,

	// GMII/MII: Transmit
	output	wire	[ 7:0]	phy1_gm_txd,
	output	wire				phy1_gm_tx_en,
	output	wire				phy1_gm_tx_er,
	output	wire				phy1_gm_gtx_clk,
	input		wire				phy1_tx_clk,

	// Have internal pull-up (not sure how that affects the FPGA)
	output	wire				phy1_mdc,
	inout		wire				phy1_mio,
	output	wire				phy1_reset_n,

	// Used for configuration mode (LED states in all other modes)
	inout		wire	[ 2:0]	phy1_addr,

	input		wire				phy1_int_n,
	inout		wire				phy1_clk125_ndo,
	input		wire				phy1_col,
	input		wire				phy1_crs,

	// Power management ////////////////////////////////////////////////

	output	wire				v1p2_en,
	output	wire				v3p3_en
);

// DDR2: Idle

assign	mem_addr		= 16'h0000;
assign	mem_ba		= 3'b000;
assign	mem_cas_n	= 1'b1;
assign	mem_cke		= 2'b00;
assign	mem_clk		= 2'bZZ;
assign	mem_clk_n	= 2'bZZ;
assign	mem_cs_n		= 2'b11;
assign	mem_dm		= 8'h00;
assign	mem_dq		= 64'hZZZZZZZZZZZZZZZZ;
assign	mem_dqs		= 8'hZZ;
assign	mem_odt		= 2'b00;
assign	mem_ras_n	= 1'b1;
assign	mem_we_n		= 1'b1;

// USB
wire		usb_ext_clk				= clk_50;

assign	usb_pipe_tx_clk		= 1'b0;
assign	usb_pipe_tx_data		= 16'h0000;
assign	usb_pipe_tx_datak		= 2'b00;
assign	usb_phy_reset_n		= 1'b1;
assign	usb_tx_detrx_lpbk		= 1'b0;
assign	usb_tx_elecidle		= 1'b1;
assign	usb_rx_elecidle		= usb_strapping ? 1'bZ : 1'b0;
assign	usb_power_down			= 2'b00;
assign	usb_phy_status			= usb_strapping ? 1'bZ : 1'b0;
assign	usb_tx_oneszeros		= 1'b0;
assign	usb_tx_deemph			= 2'b10;
assign	usb_tx_margin[2:1]	= 2'b00;
assign	usb_tx_margin[0]		= usb_strapping ? 1'b0 : 1'b1;
assign	usb_tx_swing			= 1'b0;
assign	usb_rx_polarity		= 1'b0;
assign	usb_rx_termination	= 1'b0;
assign	usb_rate					= 1'b1;
assign	usb_elas_buf_mode		= 1'b0;
assign	usb_reset_n				= reset_n;
assign	usb_out_enable			= 1'b1;
wire		usb_strapping;
wire		usb_connected;
wire		usb_configured;

// MIIM

assign			phy0_mdc = 0;
assign			phy1_mdc = 0;

assign			phy0_mio = 1'bz;
assign			phy1_mio = 1'bz;

// Reset, power, strapping control

reg				reset;
wire				reset_n = ~reset;

reg	[ 7:0]	count_clk_in_us;
reg				pulse_1us;
reg	[31:0]	count_us;

reg	[10:0]	count_us_in_ms;
reg				pulse_1ms;
reg	[31:0]	count_ms;

reg				phy_vddl_en;
reg				phy_vddh_en;

assign			v1p2_en = phy_vddl_en;
assign			v3p3_en = phy_vddh_en;

parameter	[2:0]	PHY_IF_ST_OFF		= 3'b000,
						PHY_IF_ST_STRAP	= 3'b001,
						PHY_IF_ST_INIT		= 3'b010,
						PHY_IF_ST_READY	= 3'b011
						;

wire	[2:0]		phy0_phyad = 3'b000;		// MIIM address
wire	[3:0]		phy0_mode = 4'b0001;		// GMII/MII mode
wire				phy0_clk_125_en = 0;		// Enable 125MHz clock output
wire				phy0_led_mode = 1'b1;

reg	[2:0]		phy0_if_state;
wire				phy0_if_state_strap = (phy0_if_state == PHY_IF_ST_STRAP);
wire				phy0_if_state_ready = (phy0_if_state == PHY_IF_ST_READY);

assign			phy0_addr = phy0_if_state_strap ? phy0_phyad : 3'bzzz;
assign			phy0_gm_rxd = phy0_if_state_strap ? { 4'bzzzz, phy0_mode } : 8'bzzzzzzzz;
assign			phy0_gm_rx_dv = phy0_if_state_strap ? phy0_clk_125_en : 1'bz;
assign			phy0_clk125_ndo = phy0_if_state_strap ? phy0_led_mode : 1'bz;

wire	[2:0]		phy1_phyad = 3'b000;		// MIIM address
wire	[3:0]		phy1_mode = 4'b0001;		// GMII/MII mode
wire				phy1_clk_125_en = 0;		// Enable 125MHz clock output
wire				phy1_led_mode = 1'b1;

reg	[2:0]		phy1_if_state;
wire				phy1_if_state_strap = (phy1_if_state == PHY_IF_ST_STRAP);
wire				phy1_if_state_ready = (phy1_if_state == PHY_IF_ST_READY);

assign			phy1_addr = phy1_if_state_strap ? phy1_phyad : 3'bzzz;
assign			phy1_gm_rxd = phy1_if_state_strap ? { 4'bzzzz, phy1_mode } : 8'bzzzzzzzz;
assign			phy1_gm_rx_dv = phy1_if_state_strap ? phy1_clk_125_en : 1'bz;
assign			phy1_clk125_ndo = phy1_if_state_strap ? phy1_led_mode : 1'bz;

initial begin
	reset <= 1;
	
	count_clk_in_us <= 0;
	pulse_1us <= 0;
	count_us <= 0;
	
	count_us_in_ms <= 0;
	pulse_1ms <= 0;
	count_ms <= 0;
	
	phy_vddl_en <= 0;
	phy_vddh_en <= 0;
	
	phy0_if_state = PHY_IF_ST_OFF;
	phy1_if_state = PHY_IF_ST_OFF;
end

always @(posedge clk_50) begin
	if(count_clk_in_us == 49) begin
		count_clk_in_us <= 0;
		pulse_1us <= 1;
		count_us <= count_us + 1'b1;
	end
	else begin
		count_clk_in_us <= count_clk_in_us + 1'b1;
		pulse_1us <= 0;
	end
end

always @(posedge clk_50) begin
	if(pulse_1us) begin
		if(count_us_in_ms == 999) begin
			count_us_in_ms <= 0;
			pulse_1ms <= 1;
			count_ms <= count_ms + 1'b1;
		end
		else begin
			count_us_in_ms <= count_us_in_ms + 1'b1;
			pulse_1ms <= 0;
		end
	end
end

wire phy0_ready = phy0_if_state_ready;
wire phy1_ready = phy1_if_state_ready;

assign phy0_reset_n = reset_n;
assign phy1_reset_n = reset_n;

always @(posedge clk_50) begin
	// T+0: PHYs unpowered, reset asserted.
	
	// T+1000ms: apply power to PHYs DVDDH, AVDDH.
	if(count_ms >= 1000) begin
		phy_vddh_en <= 1;
	end
	
	// T+1100ms: apply power to PHYs AVDDL, AVDD_PLL, DVDDL.
	if(count_ms >= 1100) begin
		phy_vddl_en <= 1;
		phy0_if_state <= PHY_IF_ST_STRAP;
		phy1_if_state <= PHY_IF_ST_STRAP;
	end
	
	// Release PHYs from reset.
	if(count_ms >= 1200) begin
		reset <= 0;
		phy0_if_state <= PHY_IF_ST_INIT;
		phy1_if_state <= PHY_IF_ST_INIT;
	end
	
	if(count_ms >= 1300) begin
		phy0_if_state <= PHY_IF_ST_READY;
		phy1_if_state <= PHY_IF_ST_READY;
	end
end

wire phys_not_ready = (!phy0_ready) || (!phy1_ready);

reg	reset_n_q1, reset_n_q2, reset_n_q3;

always @(posedge clk_50) begin
	{ reset_n_q3, reset_n_q2, reset_n_q1 } <= { reset_n_q2, reset_n_q1, reset_n };
end

assign	usb_strapping = reset_n_q3;

// PLLs and clocking

wire phy0_gm_rx_clk_pll;
wire phy0_gm_rx_clk_pll_locked;

pll_gmii pll_gmii_phy0 (
	.areset(reset),
	.inclk0(phy0_gm_rx_clk),
	.c0(phy0_gm_rx_clk_pll),
	.locked(phy0_gm_rx_clk_pll_locked)
);

wire phy1_gm_rx_clk_pll;
wire phy1_gm_rx_clk_pll_locked;

pll_gmii pll_gmii_phy1 (
	.areset(reset),
	.inclk0(phy1_gm_rx_clk),
	.c0(phy1_gm_rx_clk_pll),
	.locked(phy1_gm_rx_clk_pll_locked)
);

// I/O registers and buffers

wire		phy0_gm_gtx_clk_src = phy1_gm_rx_clk_pll;

ddio_gtx_clk phy0_ddio_gtx_clk (
	.aclr(reset),
	.datain_h(1'b0),
	.datain_l(1'b1),
	.outclock(phy0_gm_gtx_clk_src),
	.dataout(phy0_gm_gtx_clk)
);

wire		phy1_gm_gtx_clk_src = phy0_gm_rx_clk_pll;

ddio_gtx_clk phy1_ddio_gtx_clk (
	.aclr(reset),
	.datain_h(1'b0),
	.datain_l(1'b1),
	.outclock(phy1_gm_gtx_clk_src),
	.dataout(phy1_gm_gtx_clk)
);

// GMII PHY0->PHY1

wire					phy01_bridge_log_wr_clk;
wire					phy01_bridge_log_wr_en;
wire		[ 7:0]	phy01_bridge_log_wr_d;
wire					phy01_bridge_log_wr_frame_end;

gmii_bridge phy01_bridge (
	.reset(phys_not_ready),
	.rx_clk(phy0_gm_rx_clk_pll),
	.rx_dv(phy0_gm_rx_dv),
	.rxd(phy0_gm_rxd),
	.rx_er(phy0_gm_rx_er),
	.gtx_clk(phy1_gm_gtx_clk_src),
	.tx_en(phy1_gm_tx_en),
	.txd(phy1_gm_txd),
	.tx_er(phy1_gm_tx_er),
	.log_clk(phy01_bridge_log_wr_clk),
	.log_en(phy01_bridge_log_wr_en),
	.log_d(phy01_bridge_log_wr_d),
	.log_frame_end(phy01_bridge_log_wr_frame_end)
);

wire					phy01_bridge_log_rd_clk = usb_ext_clk;
wire					phy01_bridge_log_rd_empty;
wire					phy01_bridge_log_rd_en;
wire					phy01_bridge_log_rd_frame_end;
wire		[ 7:0]	phy01_bridge_log_rd_d;

fifo_log_data phy01_fifo_log_data (
	.aclr(phys_not_ready),
	.wrclk(phy01_bridge_log_wr_clk),
	.wrfull(),
	.wrreq(phy01_bridge_log_wr_en),
	.data({ phy01_bridge_log_wr_frame_end, phy01_bridge_log_wr_d }),
	.rdclk(phy01_bridge_log_rd_clk),
	.rdempty(phy01_bridge_log_rd_empty),
	.rdreq(phy01_bridge_log_rd_en),
	.q({ phy01_bridge_log_rd_frame_end, phy01_bridge_log_rd_d })
);

wire					phy01_bridge_log_meta_rd_clk = usb_ext_clk;
wire					phy01_bridge_log_meta_rd_empty;
wire					phy01_bridge_log_meta_rd_en;
wire		[63:0]	phy01_bridge_log_meta_rd_d;

fifo_log_meta phy01_fifo_log_meta (
	.aclr(phys_not_ready),
	.wrclk(phy01_bridge_log_wr_clk),
	.wrfull(),
	.wrreq(phy01_bridge_log_wr_frame_end),
	.data({ count_us, 32'hdeadbeef }),
	.rdclk(phy01_bridge_log_meta_rd_clk),
	.rdempty(phy01_bridge_log_meta_rd_empty),
	.rdreq(phy01_bridge_log_meta_rd_en),
	.q(phy01_bridge_log_meta_rd_d)
);

wire					phy01_bridge_log_available = ~phy01_bridge_log_meta_rd_empty;

wire		[ 8:0]	usb_in_addr;
wire		[ 7:0]	usb_in_data;
wire					usb_in_wren;
wire					usb_in_ready;
wire					usb_in_commit;
wire		[ 9:0]	usb_in_commit_len;
wire					usb_in_commit_ack;

gmii_log_rx phy01_gmii_log_rx (
	.reset					(phys_not_ready),
	.clock					(phy01_bridge_log_rd_clk),
	.available				(phy01_bridge_log_available),
	.meta						(phy01_bridge_log_meta_rd_d),
	.meta_en					(phy01_bridge_log_meta_rd_en),
	.data						(phy01_bridge_log_rd_d),
	.data_stop				(phy01_bridge_log_rd_frame_end),
	.data_en					(phy01_bridge_log_rd_en),
	.usb_in_addr			(usb_in_addr),
	.usb_in_data			(usb_in_data),
	.usb_in_wren			(usb_in_wren),
	.usb_in_ready			(usb_configured & usb_in_ready),
	.usb_in_commit			(usb_in_commit),
	.usb_in_commit_len	(usb_in_commit_len),
	.usb_in_commit_ack	(usb_in_commit_ack)
);

// GMII PHY1->PHY0

gmii_bridge phy10_bridge (
	.reset(phys_not_ready),
	.rx_clk(phy1_gm_rx_clk_pll),
	.rx_dv(phy1_gm_rx_dv),
	.rxd(phy1_gm_rxd),
	.rx_er(phy1_gm_rx_er),
	.gtx_clk(phy0_gm_gtx_clk_src),
	.tx_en(phy0_gm_tx_en),
	.txd(phy0_gm_txd),
	.tx_er(phy0_gm_tx_er)
);

usb2_top	iu2 (
	.ext_clk					( usb_ext_clk ),
	.reset_n					( usb_reset_n ),
	.reset_n_out			(  ),
	
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

	.buf_in_addr			( usb_in_addr ),
	.buf_in_data			( usb_in_data ),
	.buf_in_wren			( usb_in_wren ),
	.buf_in_ready			( usb_in_ready ),
	.buf_in_commit			( usb_in_commit ),
	.buf_in_commit_len	( usb_in_commit_len ),
	.buf_in_commit_ack	( usb_in_commit_ack ),

	.dbg_linestate			(  ),
	.dbg_frame_num			(  )
);
/*
// MII passthrough support

wire mii_pt_0to1_reset = phys_not_ready;
wire phy0_rx_full_error;
wire [15:0] phy0_rx_frame_count;
wire [15:0] phy0_rx_total_nibble_count;

mii_passthrough mii_pt_0to1 (
	.reset(mii_pt_0to1_reset),
	.rx_clk(phy0_gm_rx_clk),
	.rx_dv(phy0_gm_rx_dv),
	.rxd(phy0_gm_rxd),
	.rx_er(phy0_gm_rx_er),
	.crs(phy0_crs),
	.col(phy0_col),
	.tx_clk(phy1_gm_tx_clk),
	.tx_en(phy1_gm_tx_en),
	.txd(phy1_gm_txd),
	.tx_er(phy1_gm_tx_er),
	.rx_full_error(phy0_rx_full_error),
	.rx_frame_count(phy0_rx_frame_count),
	.rx_total_nibble_count(phy0_rx_total_nibble_count)
);

wire mii_pt_1to0_reset = phys_not_ready;
wire phy1_rx_full_error;
wire [15:0] phy1_rx_frame_count;
wire [15:0] phy1_rx_total_nibble_count;

mii_passthrough mii_pt_1to0 (
	.reset(mii_pt_1to0_reset),
	.rx_clk(phy1_gm_rx_clk),
	.rx_dv(phy1_gm_rx_dv),
	.rxd(phy1_gm_rxd),
	.rx_er(phy1_gm_rx_er),
	.crs(phy1_crs),
	.col(phy1_col),
	.tx_clk(phy0_gm_tx_clk),
	.tx_en(phy0_gm_tx_en),
	.txd(phy0_gm_txd),
	.tx_er(phy0_gm_tx_er),
	.rx_full_error(phy1_rx_full_error),
	.rx_frame_count(phy1_rx_frame_count),
	.rx_total_nibble_count(phy1_rx_total_nibble_count)
);
*/
endmodule
