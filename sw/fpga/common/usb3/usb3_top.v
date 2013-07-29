
//
// usb 3.0 top-level
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_top (

input	wire			ext_clk,
input	wire			reset_n,
output	wire			reset_n_out,

input	wire			phy_pipe_pclk,
input	wire	[15:0]	phy_pipe_rx_data,
input	wire	[1:0]	phy_pipe_rx_datak,
input	wire			phy_pipe_rx_valid,
output	wire			phy_pipe_tx_clk,
output	wire	[15:0]	phy_pipe_tx_data,
output	wire	[1:0]	phy_pipe_tx_datak,

output	wire			phy_reset_n,
output	wire			phy_out_enable,
output	wire			phy_phy_reset_n,
output	wire			phy_tx_detrx_lpbk,
output	wire			phy_tx_elecidle,
inout	wire			phy_rx_elecidle,
input	wire	[2:0]	phy_rx_status,
output	wire	[1:0]	phy_power_down,
inout	wire			phy_phy_status,
input	wire			phy_pwrpresent,

output	wire			phy_tx_oneszeros,
output	wire	[1:0]	phy_tx_deemph,
output	wire	[2:0]	phy_tx_margin,
output	wire			phy_tx_swing,
output	wire			phy_rx_polarity,
output	wire			phy_rx_termination,
output	wire			phy_rate,
output	wire			phy_elas_buf_mode

);
	
	assign			reset_n_out 	= 1'b1;
	reg 			reset_1, reset_2;				// local reset
	wire			local_reset		= reset_n & pll_locked & phy_pwrpresent;
	wire			local_pclk_quarter;				// local 1/4 PCLK output via PLL
	wire			local_pclk_half;				// local 1/2 PCLK output via PLL
	wire			local_pclk_half_phase;			// local 1/2 PCLK output via PLL, phase shift 90
	wire			local_tx_clk;					// local regenerated PCLK used for transmit
	wire			local_tx_clk_phase;				// local regenerated PCLK used for transmit, phase shift 90
	wire			pll_locked;						// indicates PCLK present and valid clock output
	
always @(posedge local_pclk_half ) begin

	// synchronize external reset to local domain
	{reset_2, reset_1} <= {reset_1, local_reset};
	
end

	assign			phy_reset_n = reset_n;			// TUSB1310A has minimum 1uS pulse width for RESET
	assign			phy_phy_reset_n = reset_n;		// responsibility of the toplevel module to supply this reset
	assign			phy_out_enable = 1'b1;
	
	wire	[1:0]	mux_tx_margin; 

	parameter		XTAL_DIS			= 1'b0; 	// crystal input
	parameter [2:0]	SSC_DIS				= 2'b11;	// spread spectrum clock disable
	parameter		PIPE_16BIT			= 1'b0;		// sdr 16bit pipe interface
	// strap pins
	assign			phy_rx_elecidle 	= reset_2 ? 1'bZ : XTAL_DIS;
	assign			phy_tx_margin	  	= reset_2 ? mux_tx_margin  : SSC_DIS;	
	assign			phy_phy_status 		= reset_2 ? 1'bZ : PIPE_16BIT;
		
	
////////////////////////////////////////////////////////////
//
// USB 3.0 PIPE3 interface
//
////////////////////////////////////////////////////////////

	wire		ltssm_reset_n;
	
usb3_pipe	iu3p (

	.ext_clk				( ext_clk ),
	.slow_clk				( local_pclk_quarter ),
	.local_clk				( local_pclk_half ),
	.local_clk_capture		( local_pclk_half_phase ),
	.local_tx_clk			( local_tx_clk ),
	.local_tx_clk_phase		( local_tx_clk_phase ),
	.reset_n				( reset_2 ),
	.ltssm_reset_n			( ltssm_reset_n ),

	.phy_pipe_pclk			( phy_pipe_pclk ),
	.phy_pipe_rx_data		( phy_pipe_rx_data ),
	.phy_pipe_rx_datak		( phy_pipe_rx_datak	 ),
	.phy_pipe_rx_valid		( phy_pipe_rx_valid ),
	.phy_pipe_tx_clk		( phy_pipe_tx_clk ),
	.phy_pipe_tx_data		( phy_pipe_tx_data ),
	.phy_pipe_tx_datak		( phy_pipe_tx_datak ),

	.phy_tx_detrx_lpbk		( phy_tx_detrx_lpbk ),
	.phy_tx_elecidle		( phy_tx_elecidle ),
	.phy_rx_elecidle		( phy_rx_elecidle ),
	.phy_rx_status			( phy_rx_status ),
	.phy_power_down			( phy_power_down ),
	.phy_phy_status			( phy_phy_status ),
	.phy_pwrpresent			( phy_pwrpresent ),

	.phy_tx_oneszeros		( phy_tx_oneszeros ),
	.phy_tx_deemph			( phy_tx_deemph ),
	.phy_tx_margin			( mux_tx_margin ),
	.phy_tx_swing			( phy_tx_swing ),
	.phy_rx_polarity		( phy_rx_polarity ),
	.phy_rx_termination		( phy_rx_termination ),
	.phy_rate				( phy_rate ),
	.phy_elas_buf_mode		( phy_elas_buf_mode ),
	
	.partner_detect			( partner_detect ),
	.partner_looking		( partner_looking ),	
	.partner_detected		( partner_detected ),
	
	.ltssm_tx_detrx_lpbk	( port_tx_detrx_lpbk ),
	.ltssm_tx_elecidle		( port_tx_elecidle ),
	.ltssm_power_down		( port_power_down ),
	.ltssm_power_go			( port_power_go ),
	.ltssm_power_ack		( port_power_ack ),
	
	.ltssm_training				( ltssm_training ),
	.ltssm_train_rxeq			( ltssm_train_rxeq ),
	.ltssm_train_rxeq_pass		( ltssm_train_rxeq_pass ),
	.ltssm_train_active			( ltssm_train_active ),
	.ltssm_train_ts1			( ltssm_train_ts1 ),
	.ltssm_train_ts2			( ltssm_train_ts2 ),
	.ltssm_train_config			( ltssm_train_config ),
	.ltssm_train_idle			( ltssm_train_idle ),
	
	.lfps_recv_active		( lfps_recv_active ),
	.lfps_recv_poll_u1		( lfps_recv_poll_u1 ),
	.lfps_recv_ping			( lfps_recv_ping ),
	.lfps_recv_reset		( lfps_recv_reset ),
	.lfps_recv_u2lb			( lfps_recv_u2lb ),
	.lfps_recv_u3			( lfps_recv_u3 ),	

);

////////////////////////////////////////////////////////////
//
// USB 3.0 LTSSM, LFPS
//
////////////////////////////////////////////////////////////

	wire	[4:0]	ltssm_state;
	wire			port_rx_term;
	wire			port_tx_detrx_lpbk;
	wire			port_tx_elecidle;
	
	wire	[1:0]	port_power_down;
	wire			port_power_go;
	wire			port_power_ack;
	wire			port_power_err;
	
	wire			ltssm_training;
	wire			ltssm_train_rxeq;
	wire			ltssm_train_rxeq_pass;
	wire			ltssm_train_active;
	wire			ltssm_train_ts1;
	wire			ltssm_train_ts2;
	wire			ltssm_train_config;
	wire			ltssm_train_idle;

	wire			partner_detect;
	wire			partner_looking;
	wire			partner_detected;
	
	wire			lfps_recv_active;
	wire			lfps_recv_poll_u1;
	wire			lfps_recv_ping;
	wire			lfps_recv_reset;
	wire			lfps_recv_u2lb;
	wire			lfps_recv_u3;
	
	wire			ltssm_warm_reset;

usb3_ltssm	iu3lt (

	.ext_clk				( ext_clk ),
	.slow_clk				( local_pclk_quarter ),
	.local_clk				( local_pclk_half ),
	.reset_n				( ltssm_reset_n ),

	// inputs
	.vbus_present			( phy_pwrpresent ),
	.port_rx_valid			( phy_pipe_rx_valid ),	// these signals are in the 250mhz source
	.port_rx_elecidle		( phy_rx_elecidle ),	// domain, but no problem for lfps in 62.5mhz
	.partner_looking		( partner_looking ),	
	.partner_detected		( partner_detected ),
	.port_power_state		( phy_power_down ),		// reflect actual value driven by PIPE pd_fsm
	.port_power_ack			( port_power_ack ),
	.port_power_err			( port_power_err ),
	
	.train_rxeq_pass		( ltssm_train_rxeq_pass ),
	.train_ts1				( ltssm_train_ts1 ),
	.train_ts2				( ltssm_train_ts2 ),
	
	// outputs
	.ltssm_state			( ltssm_state ),
	.port_rx_term			( port_rx_term ),
	.port_tx_detrx_lpbk		( port_tx_detrx_lpbk ),
	.port_tx_elecidle		( port_tx_elecidle ),
	.port_power_down		( port_power_down ),
	.port_power_go			( port_power_go ),
	.partner_detect			( partner_detect ),
	
	.training				( ltssm_training ),
	.train_rxeq				( ltssm_train_rxeq ),
	.train_active			( ltssm_train_active ),
	.train_config			( ltssm_train_config ),
	.train_idle				( ltssm_train_idle ),
	
	.lfps_recv_active		( lfps_recv_active ),
	.lfps_recv_poll_u1		( lfps_recv_poll_u1 ),
	.lfps_recv_ping			( lfps_recv_ping ),
	.lfps_recv_reset		( lfps_recv_reset ),
	.lfps_recv_u2lb			( lfps_recv_u2lb ),
	.lfps_recv_u3			( lfps_recv_u3 ),	
	
	.warm_reset				( ltssm_warm_reset ),
);



mf_usb3_pll	 iu3pll (
	.inclk0 	( phy_pipe_pclk ),			// 250mhz
	
	.c0 		( local_pclk_quarter ),		// 62.5mhz
	.c1 		( local_pclk_half ),		// 125mhz
	.c2 		( local_pclk_half_phase ),	// 125mhz 90 phase shift
	.c3			( local_tx_clk ),			// 250mhz 0 phase shift
	.c4			( local_tx_clk_phase ),		// 250mhz 90 phase shift
	
	.locked 	( pll_locked )				// valid high
);


endmodule
