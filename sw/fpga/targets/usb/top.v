//
// USB 2.0 tap with USB 2.0 to host,
// for Daisho main board, USB 3.0 front-end
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

module top
(
input		wire				clk_50,

inout		wire				io_scl,
inout		wire				io_sda,
output	wire				io_reset_n,
input		wire				io_int_n,

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

// USB0 ////////////////////////////////////////////////////////////
	
// USB0: PIPE
output	wire				usb0_tx_clk,
output	wire	[15:0]	usb0_tx_data,
output	wire	[ 1:0]	usb0_tx_datak,
input		wire				usb0_pclk,
input		wire	[15:0]	usb0_rx_data,
input		wire	[ 1:0]	usb0_rx_datak,
input		wire				usb0_rx_valid,

// USB0: Control and Status
output	wire				usb0_tx_detrx_lpbk,
output	wire				usb0_tx_elecidle,
inout		wire				usb0_rx_elecidle,
input		wire	[ 2:0]	usb0_rx_status,
output	wire	[ 1:0]	usb0_power_down,
inout		wire				usb0_phy_status,
input		wire				usb0_pwrpresent,

// USB0: Configuration
output	wire	[ 1:0]	usb0_tx_deemph,
output	wire	[ 2:0]	usb0_tx_margin,
output	wire				usb0_tx_swing,
output	wire				usb0_rx_polarity,
output	wire				usb0_rx_termination,
output	wire				usb0_elas_buf_mode,

// USB0: ULPI
input		wire				usb0_ulpi_clk,
inout		wire	[ 7:0]	usb0_ulpi_d,
input		wire				usb0_ulpi_dir,
output	wire				usb0_ulpi_stp,
input		wire				usb0_ulpi_nxt,

// USB1 ////////////////////////////////////////////////////////////
	
// USB1: PIPE
output	wire				usb1_tx_clk,
output	wire	[15:0]	usb1_tx_data,
output	wire	[ 1:0]	usb1_tx_datak,

input		wire				usb1_pclk,
input		wire	[15:0]	usb1_rx_data,
input		wire	[ 1:0]	usb1_rx_datak,
input		wire				usb1_rx_valid,

// USB1: Control and Status
output	wire				usb1_tx_detrx_lpbk,
output	wire				usb1_tx_elecidle,
inout		wire				usb1_rx_elecidle,
input		wire	[ 2:0]	usb1_rx_status,
output	wire	[ 1:0]	usb1_power_down,
inout		wire				usb1_phy_status,
input		wire				usb1_pwrpresent,

// USB1: Configuration
output	wire	[ 1:0]	usb1_tx_deemph,
output	wire	[ 2:0]	usb1_tx_margin,
output	wire				usb1_tx_swing,
output	wire				usb1_rx_polarity,
output	wire				usb1_rx_termination,
output	wire				usb1_elas_buf_mode,

// USB1: ULPI
input		wire				usb1_ulpi_clk,
inout		wire	[ 7:0]	usb1_ulpi_d,
input		wire				usb1_ulpi_dir,
output	wire				usb1_ulpi_stp,
input		wire				usb1_ulpi_nxt
);

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

assign	usb0_tx_clk				= 1'b0;
assign	usb0_tx_data			= 16'h0000;
assign	usb0_tx_datak			= 2'b00;
wire		usb0_phy_reset_n		= 1'b1;
assign	usb0_tx_detrx_lpbk	= 1'b0;
assign	usb0_tx_elecidle		= 1'b1;
assign	usb0_rx_elecidle		= usb0_strapping ? 1'bZ : 1'b0;
assign	usb0_power_down		= 2'b00;
assign	usb0_phy_status		= usb0_strapping ? 1'bZ : 1'b0;
wire		usb0_tx_oneszeros		= 0;
assign	usb0_tx_deemph			= 2'b10;
assign	usb0_tx_margin[2:1]	= 2'b00;
assign	usb0_tx_margin[0]		= usb0_strapping ? 1'b0 : 1'b1;
assign	usb0_tx_swing			= 1'b0;
assign	usb0_rx_polarity		= 1'b0;
assign	usb0_rx_termination	= 1'b0;
assign	usb0_elas_buf_mode	= 1'b0;
reg		usb0_reset_n			= 1'b0;
reg		usb0_power_en = 0;
wire		usb0_strapping;
reg		usb0_phy_ready = 0;
wire		usb0_connected;
wire		usb0_configured;

assign	usb1_tx_clk				= 1'b0;
assign	usb1_tx_data			= 16'h0000;
assign	usb1_tx_datak			= 2'b00;
wire		usb1_phy_reset_n		= 1'b1;
assign	usb1_tx_detrx_lpbk	= 1'b0;
assign	usb1_tx_elecidle		= 1'b1;
assign	usb1_rx_elecidle		= usb1_strapping ? 1'bZ : 1'b0;
assign	usb1_power_down		= 2'b00;
assign	usb1_phy_status		= usb1_strapping ? 1'bZ : 1'b0;
wire		usb1_tx_oneszeros		= 1'b0;
assign	usb1_tx_deemph			= 2'b10;
assign	usb1_tx_margin[2:1]	= 2'b00;
assign	usb1_tx_margin[0]		= usb1_strapping ? 1'b0 : 1'b1;
assign	usb1_tx_swing			= 1'b0;
assign	usb1_rx_polarity		= 1'b0;
assign	usb1_rx_termination	= 1'b0;
assign	usb1_elas_buf_mode	= 1'b0;
reg		usb1_reset_n			= 1'b0;
reg		usb1_power_en = 0;
wire		usb1_strapping;
reg		usb1_phy_ready = 0;
wire		usb1_connected;
wire		usb1_configured;

/* USB PHY strapping control (ordinarily handled by USB 3.0 block) */
/* TODO: This is probably not necessary for USB0 and USB1, as the
 * reset lines are controlled by an I/O expander, which has a lot of
 * latency between changing the output voltages and the I2C transaction
 * stopping.
 */

reg	reset_n_q1, reset_n_q2, reset_n_q3;
reg	usb0_phy_ready_q3, usb0_phy_ready_q2, usb0_phy_ready_q1;
reg	usb1_phy_ready_q3, usb1_phy_ready_q2, usb1_phy_ready_q1;

always @(posedge clk_50) begin
	{ reset_n_q3, reset_n_q2, reset_n_q1 } <= { reset_n_q2, reset_n_q1, reset_n };
	{ usb0_phy_ready_q3, usb0_phy_ready_q2, usb0_phy_ready_q1 } <= { usb0_phy_ready_q2, usb0_phy_ready_q1, usb0_phy_ready };
	{ usb1_phy_ready_q3, usb1_phy_ready_q2, usb1_phy_ready_q1 } <= { usb1_phy_ready_q2, usb1_phy_ready_q1, usb1_phy_ready };
end

assign	usb_strapping = reset_n_q3;
assign	usb0_strapping = usb0_phy_ready_q3;
assign	usb1_strapping = usb1_phy_ready_q3;

/* System reset */

reg		reset;
wire		reset_n;
assign	reset_n = ~reset;

reg	[ 7:0]	count_clk_in_us;
reg				pulse_1us;
reg	[31:0]	count_us;

parameter count_board_reset = 50000000;	// 1sec

reg	[31:0]	count_1;
	
initial begin
	reset <= 1;
	count_1 <= 0;
	
	count_clk_in_us <= 0;
	pulse_1us <= 0;
	count_us <= 0;
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
	count_1 <= count_1 + 1'b1;
	if(count_1 >= count_board_reset) reset <= 0;
end

wire	[13:0]		led;

/* TCA6416A constants */

parameter 	[7:0]		I2C_IO_CMD_INPUT_0		= 8'b00000000,
							I2C_IO_CMD_OUTPUT_0		= 8'b00000010,
							I2C_IO_CMD_POLARITY_0	= 8'b00000100,
							I2C_IO_CMD_CONFIG_0		= 8'b00000110;

/* I2C drivers */

wire io_sda_o;
wire io_scl_o;

assign io_sda = io_sda_o ? 1'bZ : 1'b0;
assign io_scl = io_scl_o ? 1'bZ : 1'b0;

/* I2C bus and I/O expander support */

wire				i2c_clock = clk_50;

reg	i2c_reset_request = 0;
wire	i2c_reset;
wire	i2c_ready;
wire	i2c_not_ready = ~i2c_ready;

i2c_reset i2c_reset_inst (
	.clock_i(i2c_clock),
	.reset_i(reset),
	.request_i(i2c_reset_request),
	.reset_o(i2c_reset),
	.ready_o(i2c_ready)
);

assign	io_reset_n = ~i2c_reset;

wire	[1:0]		i2c_bit_phase;
wire				i2c_bit_phase_inc;

i2c_bit_clock i2c_bit_clock_inst (
	.clock_i(i2c_clock),
	.reset_i(i2c_not_ready),
	.phase_o(i2c_bit_phase),
	.phase_inc_o(i2c_bit_phase_inc)
);

reg				io_unit_q;
reg	[7:0]		io_command_q;
reg	[7:0]		io_data_0_q;
reg	[7:0]		io_data_1_q;

reg				io_start;
wire				io_stop;

i2c_tca6416a_writer i2c_tca6416a_writer_inst (
	.clock_i(i2c_clock),
	.reset_i(i2c_not_ready),
	
	.unit_i(io_unit_q),
	.command_i(io_command_q),
	.data_0_i(io_data_0_q),
	.data_1_i(io_data_1_q),
	
	.start_i(io_start),
	.stop_o(io_stop),
	
	.bit_phase_i(i2c_bit_phase),
	.bit_phase_inc_i(i2c_bit_phase_inc),
	
	.scl_o(io_scl_o),
	.sda_o(io_sda_o)
);

/* I2C board state */

parameter	[2:0]		I2C_BRD_ST_RESET			= 'd0,
							I2C_BRD_ST_IO0_OUTPUT	= 'd1,
							I2C_BRD_ST_IO1_OUTPUT	= 'd2,
							I2C_BRD_ST_IO0_CONFIG	= 'd3,
							I2C_BRD_ST_IO1_CONFIG	= 'd4;

reg			[2:0]		i2c_brd_state = I2C_BRD_ST_RESET;
reg						i2c_brd_init = 0;

always @(posedge i2c_clock) begin
	i2c_reset_request <= 0;

	if( reset ) begin
		i2c_brd_state <= I2C_BRD_ST_RESET;
		i2c_brd_init <= 0;
		usb0_reset_n <= 0;
		usb1_reset_n <= 0;
		usb0_phy_ready <= 0;
		usb1_phy_ready <= 0;
	end
	else begin
		case( i2c_brd_state )
		I2C_BRD_ST_RESET: begin
			i2c_reset_request <= 1;
			if( i2c_ready ) begin
				i2c_brd_init <= 1;
				i2c_brd_state <= I2C_BRD_ST_IO0_OUTPUT;
				usb0_reset_n <= 0;
				usb1_reset_n <= 0;
				usb0_phy_ready <= 0;
				usb1_phy_ready <= 0;
			end
		end
		
		I2C_BRD_ST_IO0_OUTPUT: begin
			io_unit_q <= 0;
			io_command_q <= I2C_IO_CMD_OUTPUT_0;
			io_data_0_q <= { usb1_tx_oneszeros, usb1_phy_reset_n, usb1_reset_n, 5'b00000 };
			io_data_1_q <= { 5'b10011, usb0_reset_n, usb0_tx_oneszeros, usb0_phy_reset_n };
			io_start <= 1;
			
			if( io_stop ) begin
				if( i2c_brd_init ) begin
					i2c_brd_state <= I2C_BRD_ST_IO1_OUTPUT;
					usb0_reset_n <= 1;
					usb1_reset_n <= 1;
				end 
				else begin
					i2c_brd_state <= I2C_BRD_ST_IO1_OUTPUT;
					usb0_phy_ready <= 1;
					usb1_phy_ready <= 1;
				end
			end
		end
		
		I2C_BRD_ST_IO1_OUTPUT: begin
			io_unit_q <= 1;
			io_command_q = I2C_IO_CMD_OUTPUT_0;
			io_data_0_q = { ~led[5:0], usb0_power_en, usb1_power_en };
			io_data_1_q = ~led[13:6];
			io_start <= 1;
			
			if( io_stop ) begin
				i2c_brd_state <= i2c_brd_init ? I2C_BRD_ST_IO0_CONFIG : I2C_BRD_ST_IO0_OUTPUT;
			end
		end
		
		I2C_BRD_ST_IO0_CONFIG: begin
			io_unit_q <= 0;
			io_command_q = I2C_IO_CMD_CONFIG_0;
			io_data_0_q = 8'b00000100;
			io_data_1_q = 8'b11111000;
			io_start <= 1;
			
			if( io_stop )
				i2c_brd_state <= I2C_BRD_ST_IO1_CONFIG;
		end

		I2C_BRD_ST_IO1_CONFIG: begin
			io_unit_q <= 1;
			io_command_q <= I2C_IO_CMD_CONFIG_0;
			io_data_0_q <= 8'b00000000;
			io_data_1_q <= 8'b00000000;
			io_start <= 1;
			
			if( io_stop ) begin
				i2c_brd_state <= I2C_BRD_ST_IO0_OUTPUT;
				i2c_brd_init <= 0;
			end
		end
		
		default: begin
			i2c_brd_state <= I2C_BRD_ST_RESET;
		end
		
		endcase
	end
end

////////////////////////////////////////////////////////////
//
// USB 2.0 controller
//
////////////////////////////////////////////////////////////

usb2_top	iu2 (
	.ext_clk				( clk_50 ),
	.reset_n				( usb_reset_n ),
	.reset_n_out		(  ),
	
	.opt_disable_all	( 1'b0 ),
	.opt_enable_hs		( 1'b1 ),
	.opt_ignore_vbus	( 1'b1 ),
	.stat_connected	( usb_connected ),
	.stat_configured	( usb_configured ),
	
	.phy_ulpi_clk		( usb_ulpi_clk ),
	.phy_ulpi_d			( usb_ulpi_d ),
	.phy_ulpi_dir		( usb_ulpi_dir ),
	.phy_ulpi_stp		( usb_ulpi_stp ),
	.phy_ulpi_nxt		( usb_ulpi_nxt ),

	.buf_in_addr			( usb_in_addr ),
	.buf_in_data			( usb_in_data ),
	.buf_in_wren			( usb_in_wren ),
	.buf_in_ready			( usb_in_ready ),
	.buf_in_commit			( usb_in_commit ),
	.buf_in_commit_len	( usb_in_commit_len ),
	.buf_in_commit_ack	( usb_in_commit_ack ),

	.dbg_linestate		(  ),
	.dbg_frame_num		(  )
);
/*
usb2_top	iu2_0 (
	.ext_clk				( clk_50 ),
	.reset_n				( usb0_phy_ready ),
	.reset_n_out		(  ),
	
	.opt_disable_all	( 1'b0 ),
	.opt_enable_hs		( 1'b1 ),
	.opt_ignore_vbus	( 1'b1 ),
	.stat_connected	( usb0_connected ),
	.stat_configured	( usb0_configured ),
	
	.phy_ulpi_clk		( usb0_ulpi_clk ),
	.phy_ulpi_d			( usb0_ulpi_d ),
	.phy_ulpi_dir		( usb0_ulpi_dir ),
	.phy_ulpi_stp		( usb0_ulpi_stp ),
	.phy_ulpi_nxt		( usb0_ulpi_nxt ),
	
	.dbg_linestate		(  ),
	.dbg_frame_num		(  )
);
	
usb2_top	iu2_1 (
	.ext_clk				( clk_50 ),
	.reset_n				( usb1_phy_ready ),
	.reset_n_out		(  ),
	
	.opt_disable_all	( 1'b0 ),
	.opt_enable_hs		( 1'b1 ),
	.opt_ignore_vbus	( 1'b1 ),
	.stat_connected	( usb1_connected ),
	.stat_configured	( usb1_configured ),
	
	.phy_ulpi_clk		( usb1_ulpi_clk ),
	.phy_ulpi_d			( usb1_ulpi_d ),
	.phy_ulpi_dir		( usb1_ulpi_dir ),
	.phy_ulpi_stp		( usb1_ulpi_stp ),
	.phy_ulpi_nxt		( usb1_ulpi_nxt ),
	
	.dbg_linestate		(  ),
	.dbg_frame_num		(  )
);

assign led[ 6:0] = { 3'b000, usb0_ulpi_dir, usb0_ulpi_stp, usb0_ulpi_nxt, usb0_ulpi_clk };
assign led[13:7] = { 3'b000, usb1_ulpi_dir, usb1_ulpi_stp, usb1_ulpi_nxt, usb1_ulpi_clk };
*/

// ULPI interfaces to access raw USB packet data

wire					usb0_ulpi_out_act;
wire		[ 7:0]	usb0_ulpi_out_byte;
wire 					usb0_ulpi_out_latch;

wire					usb0_ulpi_in_cts;
wire					usb0_ulpi_in_nxt;
wire		[ 7:0]	usb0_ulpi_in_byte;
wire 					usb0_ulpi_in_latch;
wire					usb0_ulpi_in_stp;

wire		[ 1:0]	usb0_dbg_linestate;

usb_ulpi_tap usb0_ulpi_tap (
	.ext_clk				( clk_50 ),
	.reset_n				( usb0_phy_ready ),
	.reset_n_out		(  ),
	
	.phy_ulpi_clk		( usb0_ulpi_clk ),
	.phy_ulpi_d			( usb0_ulpi_d ),
	.phy_ulpi_dir		( usb0_ulpi_dir ),
	.phy_ulpi_stp		( usb0_ulpi_stp ),
	.phy_ulpi_nxt		( usb0_ulpi_nxt ),
	
	.ulpi_out_act		( usb0_ulpi_out_act ),
	.ulpi_out_byte		( usb0_ulpi_out_byte ),
	.ulpi_out_latch	( usb0_ulpi_out_latch ),

	.ulpi_in_cts		( usb0_ulpi_in_cts ),
	.ulpi_in_nxt		( usb0_ulpi_in_nxt ),
	.ulpi_in_byte		( usb0_ulpi_in_byte ),
	.ulpi_in_latch		( usb0_ulpi_in_latch ),
	.ulpi_in_stp		( usb0_ulpi_in_stp ),

	.opt_disable_all	( 1'b0 ),
	.opt_enable_hs		( 1'b1 ),
	.opt_ignore_vbus	( 1'b1 ),
	
	.stat_connected	( usb0_connected ),
	.stat_fs				(  ),
	.stat_hs				(  ),
	
	.dbg_linestate		( usb0_dbg_linestate )
);

wire					usb1_ulpi_out_act;
wire		[ 7:0]	usb1_ulpi_out_byte;
wire 					usb1_ulpi_out_latch;

wire					usb1_ulpi_in_cts;
wire					usb1_ulpi_in_nxt;
wire		[ 7:0]	usb1_ulpi_in_byte;
wire 					usb1_ulpi_in_latch;
wire					usb1_ulpi_in_stp;

wire		[ 8:0]	usb_in_addr;
wire		[ 7:0]	usb_in_data;
wire					usb_in_wren;
wire					usb_in_ready;
wire					usb_in_commit;
wire		[ 9:0]	usb_in_commit_len;
wire					usb_in_commit_ack;

wire		[ 1:0]	usb1_dbg_linestate;

usb_ulpi_tap usb1_ulpi_tap (
	.ext_clk				( clk_50 ),
	.reset_n				( usb1_phy_ready ),
	.reset_n_out		(  ),
	
	.phy_ulpi_clk		( usb1_ulpi_clk ),
	.phy_ulpi_d			( usb1_ulpi_d ),
	.phy_ulpi_dir		( usb1_ulpi_dir ),
	.phy_ulpi_stp		( usb1_ulpi_stp ),
	.phy_ulpi_nxt		( usb1_ulpi_nxt ),
	
	.ulpi_out_act		( usb1_ulpi_out_act ),
	.ulpi_out_byte		( usb1_ulpi_out_byte ),
	.ulpi_out_latch	( usb1_ulpi_out_latch ),

	.ulpi_in_cts		( usb1_ulpi_in_cts ),
	.ulpi_in_nxt		( usb1_ulpi_in_nxt ),
	.ulpi_in_byte		( usb1_ulpi_in_byte ),
	.ulpi_in_latch		( usb1_ulpi_in_latch ),
	.ulpi_in_stp		( usb1_ulpi_in_stp ),

	.opt_disable_all	( 1'b0 ),
	.opt_enable_hs		( 1'b1 ),
	.opt_ignore_vbus	( 1'b1 ),
	
	.stat_connected	( usb1_connected ),
	.stat_fs				(  ),
	.stat_hs				(  ),
	
	.dbg_linestate		( usb1_dbg_linestate )
);

assign led[ 6:0] = { 5'b10100, usb0_dbg_linestate };
assign led[13:7] = { 5'b10100, usb1_dbg_linestate };

// FIFOs between ULPI interfaces.

reg usb0_ulpi_out_latch_q;
always @(posedge usb0_ulpi_clk) begin
	usb0_ulpi_out_latch_q <= usb0_ulpi_out_latch;
end

wire					fifo_ulpi_0to1_wr_clk = usb0_ulpi_clk;
wire					fifo_ulpi_0to1_full;
wire					fifo_ulpi_0to1_wr_en = usb0_ulpi_out_act && usb0_ulpi_out_latch;
wire		[ 8:0]	fifo_ulpi_0to1_wr_d = { fifo_ulpi_0to1_wr_packet_end, usb0_ulpi_out_byte };
wire					fifo_ulpi_0to1_empty;
wire					fifo_ulpi_0to1_wr_packet_end = usb0_ulpi_out_latch_q && !usb0_ulpi_out_latch;
wire					fifo_ulpi_0to1_rd_packet_end;
wire					fifo_ulpi_0to1_rd_en = usb1_ulpi_in_cts && !fifo_ulpi_0to1_empty && !fifo_ulpi_0to1_rd_packet_end;

assign				usb1_ulpi_in_latch = fifo_ulpi_0to1_rd_en;
assign				usb1_ulpi_in_stp = fifo_ulpi_0to1_rd_packet_end;

fifo_ulpi fifo_ulpi_0to1 (
	.wrclk	( fifo_ulpi_0to1_wr_clk ),
	.wrfull	( fifo_ulpi_0to1_full ),
	.wrreq	( fifo_ulpi_0to1_wr_en ),
	.data		( fifo_ulpi_0to1_wr_d ),
	.rdclk	( usb1_ulpi_clk ),
	.rdempty	( fifo_ulpi_0to1_empty ),
	.rdreq	( fifo_ulpi_0to1_rd_en ),
	.q			( { fifo_ulpi_0to1_rd_packet_end, usb1_ulpi_in_byte } )
);

reg usb1_ulpi_out_latch_q;
always @(posedge usb1_ulpi_clk) begin
	usb1_ulpi_out_latch_q <= usb1_ulpi_out_latch;
end

wire					fifo_ulpi_1to0_wr_clk = usb1_ulpi_clk;
wire					fifo_ulpi_1to0_full;
wire					fifo_ulpi_1to0_wr_en = usb1_ulpi_out_act && usb1_ulpi_out_latch;
wire	[ 8:0]		fifo_ulpi_1to0_wr_d = { fifo_ulpi_1to0_wr_packet_end, usb1_ulpi_out_byte };
wire					fifo_ulpi_1to0_empty;
wire					fifo_ulpi_1to0_wr_packet_end = usb1_ulpi_out_latch_q && !usb1_ulpi_out_latch;
wire					fifo_ulpi_1to0_rd_packet_end;

fifo_ulpi fifo_ulpi_1to0 (
	.wrclk	( fifo_ulpi_1to0_wr_clk ),
	.wrfull	( fifo_ulpi_1to0_full ),
	.wrreq	( fifo_ulpi_1to0_wr_en ),
	.data		( fifo_ulpi_1to0_wr_d ),
	.rdclk	( usb0_ulpi_clk ),
	.rdempty	( fifo_ulpi_1to0_empty ),
	.rdreq	( usb0_ulpi_in_cts && !fifo_ulpi_1to0_empty && !fifo_ulpi_1to0_rd_packet_end ),
	.q			( { fifo_ulpi_1to0_rd_packet_end, usb0_ulpi_in_byte } )
);

// Logging FIFOs

wire					phy01_log_rd_clk = usb_ulpi_clk;
wire					phy01_log_rd_empty;
wire					phy01_log_rd_en;
wire					phy01_log_rd_frame_end;
wire		[ 7:0]	phy01_log_rd_d;

fifo_log_data phy01_fifo_log_data (
	.aclr		( reset ),
	.wrclk	( fifo_ulpi_1to0_wr_clk ),
	.wrfull	(  ),
	.wrreq	( fifo_ulpi_1to0_wr_en ),
	.data		( fifo_ulpi_1to0_wr_d ),
	.rdclk	( phy01_log_rd_clk ),
	.rdempty	( phy01_log_rd_empty ),
	.rdreq	( phy01_log_rd_en ),
	.q			( { phy01_log_rd_frame_end, phy01_log_rd_d } )
);

wire					phy01_log_meta_rd_clk = usb_ulpi_clk;
wire					phy01_log_meta_rd_empty;
wire					phy01_log_meta_rd_en;
wire		[63:0]	phy01_log_meta_rd_d;

fifo_log_meta phy01_fifo_log_meta (
	.aclr		( reset ),
	.wrclk	( fifo_ulpi_0to1_wr_clk ),
	.wrfull	(  ),
	.wrreq	( fifo_ulpi_0to1_wr_packet_end ),
	.data		( { count_us, 32'hdeadbeef } ),
	.rdclk	( phy01_log_meta_rd_clk ),
	.rdempty	( phy01_log_meta_rd_empty ),
	.rdreq	( phy01_log_meta_rd_en ),
	.q			( phy01_log_meta_rd_d )
);

wire					phy01_log_available = ~phy01_log_meta_rd_empty;

usb_log_rx phy01_usb_log_rx (
	.reset					( reset ),
	.clock					( phy01_log_rd_clk ),
	.available				( phy01_log_available ),
	.meta						( phy01_log_meta_rd_d ),
	.meta_en					( phy01_log_meta_rd_en ),
	.data						( phy01_log_rd_d ),
	.data_stop				( phy01_log_rd_frame_end ),
	.data_en					( phy01_log_rd_en ),
	.usb_in_addr			( usb_in_addr ),
	.usb_in_data			( usb_in_data ),
	.usb_in_wren			( usb_in_wren ),
	.usb_in_ready			( usb_configured & usb_in_ready ),
	.usb_in_commit			( usb_in_commit ),
	.usb_in_commit_len	( usb_in_commit_len ),
	.usb_in_commit_ack	( usb_in_commit_ack )
);

endmodule
