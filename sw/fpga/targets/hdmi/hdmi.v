//
// HDMI tap
// for Daisho main board and HDMI front-end
// top-level
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

module hdmi (
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

	// SERDES input ////////////////////////////////////////////////////
	input		wire	[ 9:0]	sd_ch0_rx,
	input		wire	[ 9:0]	sd_ch1_rx,
	input		wire	[ 9:0]	sd_ch2_rx,
	input		wire				sd_ch0_rxclk,
	input		wire				sd_ch1_rxclk,
	input		wire				sd_ch2_rxclk,

	// SERDES output ///////////////////////////////////////////////////
	output	wire	[ 9:0]	sd_ch0_tx,
	output	wire	[ 9:0]	sd_ch1_tx,
	output	wire	[ 9:0]	sd_ch2_tx,
	output	wire				sd_ch0_txclk,
	output	wire				sd_ch1_txclk,
	output	wire				sd_ch2_txclk,
	
	// SERDES configuration ////////////////////////////////////////////
	output	wire				sd_rst_n,
	output	wire				sd_enable,
	output	wire				sd_ploop,
	output	wire				sd_sloop,
	output	wire				sd_mdc,
	inout		wire				sd_mdio,
	output	wire				sd_mdio_st,
	output	wire	[ 4:0]	sd_prtad,

	// Clock generator /////////////////////////////////////////////////
	inout		wire				si5338_scl,
	inout		wire				si5338_sda,
	input		wire				si5338_intr,
	
	// Power management ////////////////////////////////////////////////
	output	reg				v5p0_en,
	output	reg				v1p2_en
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

// SERDES

assign	sd_rst_n					= ~reset_n;
assign	sd_enable				= 1'b1;
assign	sd_ploop					= 1'b0;
assign	sd_sloop					= 1'b0;
assign	sd_mdc					= 1'b0;
assign	sd_mdio					= 1'bZ;
assign	sd_mdio_st				= 1'bZ;
assign	sd_prtad					= 5'b00000;

// Si5338B clock generator

wire		si5338_scl_o			= 1;
wire		si5338_sda_o			= 1;

assign	si5338_scl				= si5338_scl_o ? 1'bZ : 1'b0;
assign	si5338_sda				= si5338_sda_o ? 1'bZ : 1'b0;

// Reset, power, strapping control

reg				reset;
wire				reset_n = ~reset;

reg	[ 7:0]	count_clk_in_us;
reg				pulse_1us;
reg	[31:0]	count_us;

reg	[10:0]	count_us_in_ms;
reg				pulse_1ms;
reg	[31:0]	count_ms;

parameter	[2:0]	SD_ST_OFF		= 3'b000,
						SD_ST_INIT		= 3'b001,
						SD_ST_READY		= 3'b010
						;

reg	[ 2:0]		sd_state = SD_ST_OFF;

initial begin
	reset <= 1;
	
	count_clk_in_us <= 0;
	pulse_1us <= 0;
	count_us <= 0;
	
	count_us_in_ms <= 0;
	pulse_1ms <= 0;
	count_ms <= 0;
	
	v1p2_en <= 0;
	v5p0_en <= 0;
	
	sd_state <= SD_ST_OFF;
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

always @(posedge clk_50) begin
	// T+0: SERDES core unpowered, reset asserted.
	
	// T+1000ms: apply power to SERDES.
	if(count_ms >= 1000) begin
		v1p2_en <= 1;
		v5p0_en <= 1;
	end
	
	// Release SERDES from reset.
	if(count_ms >= 1200) begin
		reset <= 0;
		sd_state <= SD_ST_INIT;
	end
	
	if(count_ms >= 1300) begin
		sd_state <= SD_ST_READY;
	end
end

wire sd_ready = (sd_state == SD_ST_READY);

reg	reset_n_q1, reset_n_q2, reset_n_q3;

always @(posedge clk_50) begin
	{ reset_n_q3, reset_n_q2, reset_n_q1 } <= { reset_n_q2, reset_n_q1, reset_n };
end

assign	usb_strapping = reset_n_q3;

wire	[ 8:0]	usb_in_addr;
reg	[ 7:0]	usb_in_data;
reg				usb_in_wren;
wire				usb_in_ready;
reg				usb_in_commit;
reg	[ 9:0]	usb_in_commit_len;
wire				usb_in_commit_ack;

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

// HDMI passthrough

wire						sd_ch0_log_clk = usb_ext_clk;
wire						sd_ch0_log_empty;
reg						sd_ch0_log_read;
wire		[39:0]		sd_ch0_log_data;

hdmi_channel hdmi_ch0 (
	.reset			( reset ),
	.rxclk_raw		( sd_ch0_rxclk ),
	.rx				( sd_ch0_rx ),
	.txclk			( sd_ch0_txclk ),
	.tx				( sd_ch0_tx ),
	.log_clk			( sd_ch0_log_clk ),
	.log_empty		( sd_ch0_log_empty ),
	.log_read		( sd_ch0_log_read ),
	.log_data		( sd_ch0_log_data )
);

wire						sd_ch1_log_clk = usb_ext_clk;
wire						sd_ch1_log_empty;
reg						sd_ch1_log_read;
wire		[39:0]		sd_ch1_log_data;

hdmi_channel hdmi_ch1 (
	.reset			( reset ),
	.rxclk_raw		( sd_ch1_rxclk ),
	.rx				( sd_ch1_rx ),
	.txclk			( sd_ch1_txclk ),
	.tx				( sd_ch1_tx ),
	.log_clk			( sd_ch1_log_clk ),
	.log_empty		( sd_ch1_log_empty ),
	.log_read		( sd_ch1_log_read ),
	.log_data		( sd_ch1_log_data )
);

wire						sd_ch2_log_clk = usb_ext_clk;
wire						sd_ch2_log_empty;
reg						sd_ch2_log_read;
wire		[39:0]		sd_ch2_log_data;

hdmi_channel hdmi_ch2 (
	.reset			( reset ),
	.rxclk_raw		( sd_ch2_rxclk ),
	.rx				( sd_ch2_rx ),
	.txclk			( sd_ch2_txclk ),
	.tx				( sd_ch2_tx ),
	.log_clk			( sd_ch2_log_clk ),
	.log_empty		( sd_ch2_log_empty ),
	.log_read		( sd_ch2_log_read ),
	.log_data		( sd_ch2_log_data )
);

parameter	[2:0]		ST_IDLE		= 'b000,
							ST_READ		= 'b001,
							ST_CH0		= 'b010,
							ST_CH1		= 'b011,
							ST_CH2		= 'b100,
							ST_COMMIT	= 'b101,
							ST_WAIT		= 'b111
							;
reg		[ 2:0]		state;

wire						log_data_available = !(sd_ch0_log_empty || sd_ch1_log_empty || sd_ch2_log_empty);

reg		[ 8:0]		address;
reg		[ 8:0]		address_q;
reg		[ 2:0]		word;

assign					usb_in_addr = address_q;

always @(posedge usb_ext_clk) begin
	sd_ch0_log_read <= 0;
	sd_ch1_log_read <= 0;
	sd_ch2_log_read <= 0;
	
	address <= 0;
	address_q <= address;
	
	usb_in_wren <= 0;
	usb_in_commit <= 0;
	usb_in_commit_len <= 0;
	
	if( reset ) begin
		state <= ST_IDLE;
	end
	else begin
		case(state)
		ST_IDLE: begin
			if( log_data_available & usb_in_ready ) begin
				sd_ch0_log_read <= 1;
				sd_ch1_log_read <= 1;
				sd_ch2_log_read <= 1;
				word <= 0;
				state <= ST_READ;
			end
		end
		
		ST_READ: begin
			state <= ST_CH0;
		end
		
		ST_CH0: begin
			case(word)
			0: usb_in_data <= sd_ch0_log_data[39:32];
			1: usb_in_data <= sd_ch0_log_data[31:24];
			2: usb_in_data <= sd_ch0_log_data[23:16];
			3: usb_in_data <= sd_ch0_log_data[15: 8];
			4: usb_in_data <= sd_ch0_log_data[ 7: 0];
			endcase
			
			usb_in_wren <= 1;
			address <= address + 1'b1;
			
			state <= ST_CH1;
		end
		
		ST_CH1: begin
			case(word)
			0: usb_in_data <= sd_ch1_log_data[39:32];
			1: usb_in_data <= sd_ch1_log_data[31:24];
			2: usb_in_data <= sd_ch1_log_data[23:16];
			3: usb_in_data <= sd_ch1_log_data[15: 8];
			4: usb_in_data <= sd_ch1_log_data[ 7: 0];
			endcase
			
			usb_in_wren <= 1;
			address <= address + 1'b1;
			
			if( word == 4 ) begin
				sd_ch0_log_read <= 1;
				sd_ch1_log_read <= 1;
				sd_ch2_log_read <= 1;
			end
			
			state <= ST_CH2;
		end
		
		ST_CH2: begin
			case(word)
			0: usb_in_data <= sd_ch2_log_data[39:32];
			1: usb_in_data <= sd_ch2_log_data[31:24];
			2: usb_in_data <= sd_ch2_log_data[23:16];
			3: usb_in_data <= sd_ch2_log_data[15: 8];
			4: usb_in_data <= sd_ch2_log_data[ 7: 0];
			endcase
			
			usb_in_wren <= 1;
			address <= address + 1'b1;
			
			state <= ST_CH0;
			word <= word + 1'b1;
			
			if( word == 4 ) begin
				word <= 0;
				if( !log_data_available ) begin
					state <= ST_COMMIT;
				end
			end
		end
		
		ST_COMMIT: begin
			usb_in_commit <= 1;
			usb_in_commit_len <= address;
			address <= address;
			if( usb_in_commit_ack ) begin
				state <= ST_WAIT;
			end
		end
		
		ST_WAIT: begin
			if( usb_in_commit_ack == 0 ) begin
				state <= ST_IDLE;
			end
		end
		endcase
	end
end

endmodule
