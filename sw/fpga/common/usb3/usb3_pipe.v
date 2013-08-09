
//
// usb 3.0 pipe3
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_pipe (

input	wire			ext_clk,
input	wire			slow_clk,
input	wire			local_clk,
input	wire			local_clk_capture,
input	wire			local_tx_clk,
input	wire			local_tx_clk_phase,
input	wire			reset_n,
output	reg				ltssm_reset_n,

input	wire			phy_pipe_pclk,
input	wire	[15:0]	phy_pipe_rx_data,
input	wire	[1:0]	phy_pipe_rx_datak,
input	wire			phy_pipe_rx_valid,
output	wire			phy_pipe_tx_clk,
output	wire	[15:0]	phy_pipe_tx_data,
output	wire	[1:0]	phy_pipe_tx_datak,

output	wire			phy_tx_detrx_lpbk,
output	wire			phy_tx_elecidle,
input	wire			phy_rx_elecidle,
input	wire	[2:0]	phy_rx_status,
output	reg		[1:0]	phy_power_down,
input	wire			phy_phy_status,
input	wire			phy_pwrpresent,

output	reg				phy_tx_oneszeros,
output	reg		[1:0]	phy_tx_deemph,
output	reg		[2:0]	phy_tx_margin,
output	reg				phy_tx_swing,
output	reg				phy_rx_polarity,
output	reg				phy_rx_termination,
output	reg				phy_rate,
output	reg				phy_elas_buf_mode,

input	wire			ltssm_tx_detrx_lpbk,
input	wire			ltssm_tx_elecidle,
input	wire	[1:0]	ltssm_power_down,
input	wire			ltssm_power_go,
output	reg				ltssm_power_ack,
output	reg				ltssm_power_err,
input	wire			ltssm_training,
input	wire			ltssm_train_rxeq,
output	reg				ltssm_train_rxeq_pass,
input	wire			ltssm_train_active,
input	wire			ltssm_train_config,
input	wire			ltssm_train_idle,
output	reg				ltssm_train_ts1,
output	reg				ltssm_train_ts2,

input	wire			lfps_recv_active,
input	wire			lfps_recv_poll_u1,
input	wire			lfps_recv_ping,
input	wire			lfps_recv_reset,
input	wire			lfps_recv_u2lb,
input	wire			lfps_recv_u3,

input	wire			partner_detect,
output	reg				partner_looking,
output	reg				partner_detected,

output	reg				last

);

	assign phy_pipe_tx_clk = local_tx_clk;
	
	// mux these phy signals with both local PIPE and external LTSSM control
	//
	assign phy_tx_elecidle = phy_tx_elecidle_local & ltssm_tx_elecidle;
	assign phy_tx_detrx_lpbk = phy_tx_detrx_lpbk_local | ltssm_tx_detrx_lpbk;
	
	reg				lfps_recv_active_1;
	reg				partner_detect_1;
	reg				ltssm_power_go_1;
	
	reg		[23:0]	dc;								// delay count
	reg		[7:0]	swc;							// small word count
	reg		[4:0]	rdc;							// rxdet delay count
	reg		[7:0]	sc;								// 
	reg		[4:0]	ac;
	
	reg		[5:0]	state;
parameter	[5:0]	ST_RST_0			= 6'd0,
					ST_RST_1			= 6'd1,
					ST_RST_2			= 6'd2,
					ST_RST_3			= 6'd3,
					ST_RST_4			= 6'd4,
					ST_IDLE				= 6'd10,
					ST_TRAIN_RXEQ_0		= 6'd40,
					ST_TRAIN_RXEQ_1		= 6'd41,
					ST_TRAIN_ACTIVECONFIG_0	= 6'd42,
					ST_TRAIN_ACTIVECONFIG_1	= 6'd43,
					ST_TRAIN_IDLE_0		= 6'd44,
					ST_TRAIN_IDLE_1		= 6'd45,
					ST_TRAIN_IDLE_2		= 6'd46,
					ST_TRAIN_IDLE_3		= 6'd47;
					
	reg		[5:0]	align_state;
parameter	[5:0]	ALIGN_RESET			= 6'd0,
					ALIGN_IDLE			= 6'd1,
					ALIGN_0				= 6'd2,
					ALIGN_1				= 6'd3,
					ALIGN_2				= 6'd4,
					ALIGN_3				= 6'd5,
					ALIGN_4				= 6'd6;
					
	reg		[5:0]	rxdet_state;	
parameter	[5:0]	RXDET_RESET			= 6'd0,
					RXDET_IDLE			= 6'd1,
					RXDET_0		 		= 6'd2,
					RXDET_1				= 6'd3,
					RXDET_2				= 6'd4,
					RXDET_3				= 6'd5;
					
	reg		[5:0]	pd_state;	
parameter	[5:0]	PD_RESET			= 6'd0,
					PD_IDLE				= 6'd1,
					PD_0		 		= 6'd2,
					PD_1				= 6'd3,
					PD_2				= 6'd4,
					PD_3				= 6'd5;

parameter			SWING_FULL			= 1'b0,		// transmitter voltage swing
					SWING_HALF			= 1'b1;
parameter			ELASBUF_HALF		= 1'b0,		// elastic buffer mode
					ELASBUF_EMPTY		= 1'b1;
					
parameter	[2:0]	MARGIN_A			= 3'b000,	// Normal range
					MARGIN_B			= 3'b001,	// Decreasing voltage levels
					MARGIN_C			= 3'b010,	// See PHY datasheet
					MARGIN_D			= 3'b011,
					MARGIN_E			= 3'b100;
					
parameter	[1:0]	DEEMPH_6_0_DB		= 2'b00,	// -6.0dB TX de-emphasis
					DEEMPH_3_5_DB		= 2'b01,	// -3.5dB TX de-emphasis
					DEEMPH_NONE			= 2'b10,	// no TX de-emphasis
					DEEMPH_RESVD		= 2'b11;	
					
parameter	[1:0]	POWERDOWN_0			= 2'd0,		// active transmitting
					POWERDOWN_1			= 2'd1,		// slight powerdown	
					POWERDOWN_2			= 2'd2,		// slowest
					POWERDOWN_3			= 2'd3;		// deep sleep, clock stopped
					
	reg				phy_tx_elecidle_local;
	reg				phy_tx_detrx_lpbk_local;
	
	reg		[20:0]	rxdet_timeout;
	reg		[15:0]	train_count;
	
	reg		[15:0]	symbols_since_skp;
	reg		[12:0]	train_sym_skp;
	
	reg		[1:0]	word_rx_align;
	reg				set_ts;
	reg				set_reading;
	reg		[95:0]	set_sr_data;
	reg		[11:0]	set_sr_datak;
	
	reg				set_ts1_found, set_ts1_found_1;
	reg				set_ts2_found, set_ts2_found_1;
	
	reg		[31:0]	sync_a /* synthesis noprune */;
	reg		[3:0]	sync_ak /* synthesis noprune */;
	reg		[31:0]	sync_b /* synthesis noprune */;
	reg		[3:0]	sync_bk /* synthesis noprune */;
	reg		[31:0]	sync_out /* synthesis noprune */;
	reg		[3:0]	sync_outk /* synthesis noprune */;
	reg				sync_out_valid /* synthesis noprune */;
	
	// combinational detection of valid packet framing
	// k-symbols within a received word.
	wire			sync_byte_3 = pipe_rx_datak[3] && (	pipe_rx_data[31:24] == 8'h5C || pipe_rx_data[31:24] == 8'hBC ||
														pipe_rx_data[31:24] == 8'hFB || pipe_rx_data[31:24] == 8'hFE ||
														pipe_rx_data[31:24] == 8'hF7 );
	wire			sync_byte_2 = pipe_rx_datak[2] && (	pipe_rx_data[23:16] == 8'h5C || pipe_rx_data[23:16] == 8'hBC ||
														pipe_rx_data[23:16] == 8'hFB || pipe_rx_data[23:16] == 8'hFE ||
														pipe_rx_data[23:16] == 8'hF7 );
	wire			sync_byte_1 = pipe_rx_datak[1] && (	pipe_rx_data[15:8] == 8'h5C || pipe_rx_data[15:8] == 8'hBC ||
														pipe_rx_data[15:8] == 8'hFB || pipe_rx_data[15:8] == 8'hFE ||
														pipe_rx_data[15:8] == 8'hF7 );
	wire			sync_byte_0 = pipe_rx_datak[0] && (	pipe_rx_data[7:0] == 8'h5C || pipe_rx_data[7:0] == 8'hBC ||
														pipe_rx_data[7:0] == 8'hFB || pipe_rx_data[7:0] == 8'hFE ||
														pipe_rx_data[7:0] == 8'hF7 );
	wire	[3:0]	sync_start 	= {sync_byte_3, sync_byte_2, sync_byte_1, sync_byte_0};
	
	wire			sync_byte_3_end = pipe_rx_datak[3] && (	pipe_rx_data[31:24] == 8'h7C || pipe_rx_data[31:24] == 8'hFD );
	wire			sync_byte_2_end = pipe_rx_datak[2] && (	pipe_rx_data[23:16] == 8'h7C || pipe_rx_data[23:16] == 8'hFD );
	wire			sync_byte_1_end = pipe_rx_datak[1] && (	pipe_rx_data[15:8] == 8'h7C || pipe_rx_data[15:8] == 8'hFD );
	wire			sync_byte_0_end = pipe_rx_datak[0] && (	pipe_rx_data[7:0] == 8'h7C || pipe_rx_data[7:0] == 8'hFD );
	wire	[3:0]	sync_end	= {sync_byte_3_end, sync_byte_2_end, sync_byte_1_end, sync_byte_0_end};
														
always @(posedge local_clk) begin

	// synchronizers
	lfps_recv_active_1 <= lfps_recv_active; // (just rising edge detection)
	partner_detect_1 <= partner_detect;
	ltssm_power_go_1 <= ltssm_power_go;
	
	// counters
	dc <= dc + 1'b1;
	rdc <= rdc + 1'b1;
	swc <= swc + 1'b1;
	ac <= ac + 1'b1;
	rxdet_timeout <= rxdet_timeout + 1'b1;
	
	phy_tx_elecidle_local <= 1'b1;
	phy_tx_detrx_lpbk_local <= 1'b0;
	
	ltssm_train_rxeq_pass <= 0;
	
	pipe_tx_data <= 32'h0;
	pipe_tx_datak <= 4'b0000;
	
	set_reading <= 0;
	set_ts1_found <= 0;
	set_ts2_found <= 0;
	
	ltssm_train_ts1 <= set_ts1_found_1 | set_ts1_found;
	ltssm_train_ts2 <= set_ts2_found_1 | set_ts2_found;
	
	set_ts1_found_1 <= set_ts1_found;
	set_ts2_found_1 <= set_ts2_found;
	
	sync_out_valid <= 0;
	
	///////////////////////////////////////
	// PIPE FSM
	///////////////////////////////////////

	case(state)
	ST_RST_0: begin
		// reset state
		
		// start-up parameters
		ltssm_reset_n <= 0;
		phy_tx_oneszeros = 		1'b0;
		phy_rx_polarity <= 		1'b0;			// no lane polarity inversion
		phy_power_down <= 		POWERDOWN_2;	// P2 state
		phy_tx_margin <= 		MARGIN_A;		// normal operating margin
		phy_tx_deemph <= 		DEEMPH_3_5_DB;	// -3.5dB
		phy_rate <= 			1'b1;			// 5.0 Gb/s fixed
		phy_tx_swing <= 		SWING_HALF;		// full swing
		phy_rx_termination <= 	1'b1;			// enable rx termination
		phy_elas_buf_mode <= 	ELASBUF_HALF;	// elastic buffer nominally half full
				
		state <= ST_RST_1;
		dc <= 0;
	end
	ST_RST_1: begin
		// wait for PHY's initial poweron reset notification
		if(pipe_phy_status[1] | pipe_phy_status[0]) state <= ST_RST_2;
	end
	ST_RST_2: begin
		// once PHY deasserts status, it's ready
		if(~pipe_phy_status[1] | ~pipe_phy_status[0]) state <= ST_RST_3;
	end
	ST_RST_3: begin
		// phy is ready, bring LTSSM out of reset
		ltssm_reset_n <= 1;
		state <= ST_IDLE;
	end

	ST_IDLE: begin
		// LTSSM wants to initiate link training!
		if(ltssm_training) begin
		
			// Polling.RxEq
			if(ltssm_train_rxeq) begin
				swc <= 0;
				train_count <= 0;
				state <= ST_TRAIN_RXEQ_0;
			end
			// Polling.Active, Polling.Config
			if(ltssm_train_active | ltssm_train_config) begin
				swc <= 0;
				set_ts <= 0;
				train_count <= 0;
				// reset SKP elastic buffer compensation
				symbols_since_skp <= 0;
				train_sym_skp <= 0;
				state <= ST_TRAIN_ACTIVECONFIG_0;
			end
			// Polling.Idle
			if(ltssm_train_idle) begin
				swc <= 0;
				state <= ST_TRAIN_IDLE_0;
			end
		end
	end
	
	ST_TRAIN_RXEQ_0: begin
	
		// transmitting TSEQ
		// N.B. this is just COM + scrambled 00.
		// TODO remove LUT and utilize scrambler
		phy_tx_elecidle_local <= 1'b0;
		case(swc)
		0: {pipe_tx_data, pipe_tx_datak} <= {32'hBCFF17C0, 4'b1000};
		1: {pipe_tx_data, pipe_tx_datak} <= {32'h14B2E702, 4'b0000};
		2: {pipe_tx_data, pipe_tx_datak} <= {32'h82726E28, 4'b0000};
		3: {pipe_tx_data, pipe_tx_datak} <= {32'hA6BE6DBF, 4'b0000};
		4: {pipe_tx_data, pipe_tx_datak} <= {32'h4A4A4A4A, 4'b0000};
		5: {pipe_tx_data, pipe_tx_datak} <= {32'h4A4A4A4A, 4'b0000};
		6: {pipe_tx_data, pipe_tx_datak} <= {32'h4A4A4A4A, 4'b0000};
		7: {pipe_tx_data, pipe_tx_datak} <= {32'h4A4A4A4A, 4'b0000};
		endcase
		
		if(swc == 7) begin
			// increment send count and repeat
			swc <= 0;
			train_count <= train_count + 1'b1;
			if(train_count == 65535) begin
				// proceed
				state <= ST_TRAIN_RXEQ_1;
			end
		end
		
		// allow for swapped lane polarity on receiver
		// if RX polarity was swapped, then D10.2 (0x4A) in TSEQ would appear as D21.5 (0xB5).
		if(pipe_rx_data == 32'hB5B5B5B5) phy_rx_polarity <= 1;
	end
	ST_TRAIN_RXEQ_1: begin
		// allow several cycles for slower FSM in other domain to deassert training signal,
		// and inhibit repeated training
		phy_tx_elecidle_local <= 1'b0;
		
		ltssm_train_rxeq_pass <= 1;
		if(swc == 7) state <= ST_IDLE;
	end
	
	ST_TRAIN_ACTIVECONFIG_0: begin
	
		// transmitting TS1
		phy_tx_elecidle_local <= 1'b0;
		
		// NOTE: once LTSSM switches, mixed-up set could be sent.
		// this will be discarded by the other port, so no big deal.
		if(~set_ts) begin
			case(swc)
			0: {pipe_tx_data, pipe_tx_datak} <= {32'hBCBCBCBC, 4'b1111};
			1: {pipe_tx_data, pipe_tx_datak} <= {32'h00004A4A, 4'b0000};
			2: {pipe_tx_data, pipe_tx_datak} <= {32'h4A4A4A4A, 4'b0000};
			3: {pipe_tx_data, pipe_tx_datak} <= {32'h4A4A4A4A, 4'b0000};
			endcase
		end else begin
			case(swc)
			0: {pipe_tx_data, pipe_tx_datak} <= {32'hBCBCBCBC, 4'b1111};
			1: {pipe_tx_data, pipe_tx_datak} <= {32'h00004545, 4'b0000};
			2: {pipe_tx_data, pipe_tx_datak} <= {32'h45454545, 4'b0000};
			3: {pipe_tx_data, pipe_tx_datak} <= {32'h45454545, 4'b0000};
			endcase
		end
		
		if(swc == 3) begin
			swc <= 0;
			// increment symbols sent for SKP compensation
			train_sym_skp <= train_sym_skp + 13'd16;
			if(train_sym_skp >= (354-16)) begin
				// time to insert SKP ordered set
				state <= ST_TRAIN_ACTIVECONFIG_1;
			end 
			// change sending set from TS1 to TS2
			set_ts <= ltssm_train_config;
			
			if(!(ltssm_train_active || ltssm_train_config)) begin
				// LTSSM has aborted or timed out
				state <= ST_IDLE;
			end
		end
	end
	ST_TRAIN_ACTIVECONFIG_1: begin
		// transmitting SKP ordered set
		// send 00 00 in the other halfword, but scrambled with offset relative
		// to most recent sent COM
		phy_tx_elecidle_local <= 1'b0;
		{pipe_tx_data, pipe_tx_datak} <= {32'h3C3CBE6D, 4'b1100};
		// decrement overflow counter, account for the two D0.0 symbols sent as well
		train_sym_skp <= train_sym_skp - 13'd352;
		// reset sequence index
		swc <= 0;
		state <= ST_TRAIN_ACTIVECONFIG_0;
	end

	ST_TRAIN_IDLE_0: begin
		phy_tx_elecidle_local <= 1'b0;
		//case(swc[0])
		//0: 
		{pipe_tx_data, pipe_tx_datak} <= {32'hFF17C014, 4'b0000};
		//1: {pipe_tx_data, pipe_tx_datak} <= {32'hB2E70282, 4'b0000};
		//endcase
		
		if(!ltssm_training) begin
			// LTSSM has aborted or timed out
			state <= ST_IDLE;
		end
	end
	default: state <= ST_RST_0;
	endcase
	
	
	
	///////////////////////////////////////
	// ORDERED SET ALIGNMENT FSM
	///////////////////////////////////////
	
	case(word_rx_align)
	0: begin
		sync_a <= {pipe_rx_data[31:0]};
		sync_ak <= pipe_rx_datak;
		sync_b <= sync_a;
		sync_bk <= sync_ak;
	end
	1: begin
		sync_a <= {pipe_rx_data[24:0], 8'h0};
		sync_ak <= {pipe_rx_datak[2:0], 1'h0};
		sync_b <= {sync_a[31:8], pipe_rx_data[31:24]};
		sync_bk <= {sync_ak[3:1], pipe_rx_datak[3]};
	end
	2: begin
		sync_a <= {pipe_rx_data[15:0], 16'h0};
		sync_ak <= {pipe_rx_datak[1:0], 2'h0};
		sync_b <= {sync_a[31:16], pipe_rx_data[31:16]};
		sync_bk <= {sync_ak[3:2], pipe_rx_datak[3:2]};
	end
	3: begin
		sync_a <= {pipe_rx_data[7:0], 24'h0};
		sync_ak <= {pipe_rx_datak[0], 3'h0};
		sync_b <= {sync_a[31:24], pipe_rx_data[31:8]};
		sync_bk <= {sync_ak[3:3], pipe_rx_datak[3:1]};
	end
	endcase
	
	case(align_state)
	ALIGN_RESET: begin
		align_state <= ALIGN_IDLE;
	end
	ALIGN_IDLE: begin
		set_sr_data <= 0;
		set_sr_datak <= 0;
		
		// packet framing detected
		// determine bit alignment
		if( sync_start[0] ) begin
			//scr_rx_reset <= 1;
			if( sync_start[3:1] ) begin
				word_rx_align <= 0; 
				sync_a <= pipe_rx_data;
				sync_ak <= pipe_rx_datak;
			end else if( sync_start[2:1] ) begin
				word_rx_align <= 1; 
				sync_a <= {pipe_rx_data[24:0], 8'h0};
				sync_ak <= {pipe_rx_datak[2:0], 1'h0};
			end else if( sync_start[1] ) begin
				word_rx_align <= 2; 
				sync_a <= {pipe_rx_data[15:0], 16'h0};
				sync_ak <= {pipe_rx_datak[1:0], 2'h0};
			end else begin
				word_rx_align <= 3;
				sync_a <= {pipe_rx_data[7:0], 24'h0};
				sync_ak <= {pipe_rx_datak[0], 3'h0};
			end
			
			set_sr_data <= pipe_rx_data;
			set_sr_datak <= pipe_rx_datak;
			ac <= 0;
			
			align_state <= ALIGN_0;
		end
		
		// TODO replace with per-word detection and tokenization
		if(set_reading) begin
			// COM prefixed ordered set was shifted in
			case(word_rx_align)
			0: if({set_sr_data[95:0]} == 96'h00004A4A_4A4A4A4A_4A4A4A4A) set_ts1_found <= 1;
			1: if({set_sr_data[87:0], pipe_rx_data[31:24]} == 96'h00004A4A_4A4A4A4A_4A4A4A4A) set_ts1_found <= 1;
			2: if({set_sr_data[79:0], pipe_rx_data[31:16]} == 96'h00004A4A_4A4A4A4A_4A4A4A4A) set_ts1_found <= 1;
			3: if({set_sr_data[71:0], pipe_rx_data[31:8]} == 96'h00004A4A_4A4A4A4A_4A4A4A4A) set_ts1_found <= 1;
			endcase
			case(word_rx_align)
			0: if({set_sr_data[95:0]} == 96'h00004545_45454545_45454545) set_ts2_found <= 1;
			1: if({set_sr_data[87:0], pipe_rx_data[31:24]} == 96'h00004545_45454545_45454545) set_ts2_found <= 1;
			2: if({set_sr_data[79:0], pipe_rx_data[31:16]} == 96'h00004545_45454545_45454545) set_ts2_found <= 1;
			3: if({set_sr_data[71:0], pipe_rx_data[31:8]} == 96'h00004545_45454545_45454545) set_ts2_found <= 1;
			endcase
		end
	end
	ALIGN_0: begin
		// BC BC BC ** |
		// BC BC ** ** |
		// BC ** ** ** |
		// ** ** ** ** |
		
		set_sr_data <= {set_sr_data[63:0], pipe_rx_data};
		set_sr_datak <= {set_sr_datak[7:0], pipe_rx_datak};
		
		/*
		case(word_rx_align)
		0: begin
			sync_a <= {pipe_rx_data[31:0]};
			sync_ak <= pipe_rx_datak;
		end
		1: begin
			sync_a <= {pipe_rx_data[24:0], 8'h0};
			sync_ak <= {pipe_rx_datak[2:0], 1'h0};
		end
		2: begin
			sync_a <= {pipe_rx_data[15:0], 16'h0};
			sync_ak <= {pipe_rx_datak[1:0], 2'h0};
		end
		3: begin
			sync_a <= {pipe_rx_data[7:0], 24'h0};
			sync_ak <= {pipe_rx_datak[0], 3'h0};
		end
		endcase
		*/
		if(ac == 2) begin
			set_reading <= 1;
			align_state <= ALIGN_IDLE;
		end
	end
	ALIGN_1: begin
		
	end
	default: align_state <= ALIGN_RESET;
	endcase
	

	
	// pass on the descrambled data, bypassing k-symbols which
	// are not scrambled
	
	sync_out <= sync_b;
	sync_outk <= sync_bk;
	
	
	
	///////////////////////////////////////
	// RX DETECTION HANDLING FOR LTSSM
	///////////////////////////////////////
	
	partner_looking <= 0;
	partner_detected <= 0;
	
	case(rxdet_state)
	RXDET_RESET: begin
		rxdet_state <= RXDET_IDLE;
	end
	RXDET_IDLE: begin
		//if(lfps_recv_active & ~lfps_recv_active_1)
		
		if(partner_detect & ~partner_detect_1) begin
			// new rising edge from LTSSM
			// it wants us to perform a receiver check
			rdc <= 0;
			rxdet_timeout <= 0;
			rxdet_state <= RXDET_0;
			partner_looking <= 1;
			
			if(phy_power_down == POWERDOWN_0 || phy_power_down == POWERDOWN_1) begin
				// if in P0, P1 assume we're already connected anyway
				rxdet_state <= RXDET_3;
			end
		end
	end
	RXDET_0: begin
		// NOTE: TX_ELECIDLE must be asserted while this is run,
		// or loopback mode is entered
		// Also, PHY must already be in P2 or P3 mode
		
		partner_looking <= 1;
		// delay the detection attempt
		if(rdc == 31) begin
			rdc <= 31;
			phy_tx_detrx_lpbk_local <= 1'b1;
			
			// check RX_STATUS corresponding to this cycle
			if(pipe_phy_status[1]) begin
				if(pipe_rx_status[5:3] == 3'b011)
					partner_detected <= 1;
				else
					partner_detected <= 0;
				rxdet_state <= RXDET_1;
				
			end else if( pipe_phy_status[0]) begin
				if(pipe_rx_status[2:0] == 3'b011)
					partner_detected <= 1;
				else
					partner_detected <= 0;
				rxdet_state <= RXDET_1;
			end
			
			if(rxdet_timeout[20]) begin
				// it's been 8ms and no response! bail
				rxdet_state <= RXDET_1;
			end
		end
	end
	RXDET_1: begin
		partner_looking <= 0;
		// maintain value
		partner_detected <= partner_detected;
		rxdet_state <= RXDET_2;
	end
	RXDET_2: begin
		partner_detected <= partner_detected;
		rxdet_state <= RXDET_IDLE;
	end
	RXDET_3: begin
		// fake a receiver detect while running
		if(rdc < 2) 
			partner_looking <= 1;
		else 
			partner_detected <= 1;
		if(rdc == 10) rxdet_state <= RXDET_IDLE;
	end
	default: rxdet_state <= RXDET_RESET;
	endcase	
	
	
	
	///////////////////////////////////////
	// PORT POWERDOWN (PHY) MGMT FSM
	///////////////////////////////////////
	
	ltssm_power_ack <= 0;
	ltssm_power_err <= 0;
	
	case(pd_state)
	PD_RESET: begin
		pd_state <= PD_IDLE;
	end
	PD_IDLE: begin
		if(ltssm_power_go & ~ltssm_power_go_1) begin
			// new rising edge from LTSSM
			// it wants to change the POWERDOWN state of the PHY
			pd_state <= PD_0;
			
			if(ltssm_power_down == phy_power_down) begin
				// aready in the requested state
				pd_state <= PD_2;
			end
		end
	end
	PD_0: begin
		phy_power_down <= ltssm_power_down;
		
		// check RX_STATUS corresponding to this cycle
		if(pipe_phy_status[1] | pipe_phy_status[0]) begin
			// PHY asserted status acknowledging the powerstate change
			ltssm_power_ack <= 1;
			pd_state <= PD_1;
		end
	end
	PD_1: begin
		ltssm_power_ack <= 1;
		pd_state <= PD_IDLE;
	end
	PD_2: begin
		ltssm_power_ack <= 1;
		pd_state <= PD_3;
	end
	PD_3: begin
		ltssm_power_ack <= 1;
		pd_state <= PD_IDLE;
	end
	default: pd_state <= PD_RESET;
	endcase	
	
	
	
	if(~reset_n) begin
		// reset
		state <= ST_RST_0;
		align_state <= ALIGN_RESET;
		rxdet_state <= RXDET_RESET;
		pd_state <= PD_RESET;
	end
	
end


//
// RX descramble and filtering
//
usb3_descramble iu3rds (
	.local_clk		( local_clk ),
	.reset_n		( reset_n ),
	
	.raw_valid		( pipe_rx_valid ),
	.raw_status		( pipe_rx_status ),
	.raw_phy_status	( pipe_phy_status ),
	.raw_datak		( pipe_rx_datak ),
	.raw_data		( pipe_rx_data )
);




//
// ALT_DDIO megafunction instantiations
// these are used to clock the PIPE bus and related 250mhz signals
// at the more leisurely 125mhz domain from the parent's PLL
//

//
// TRANSMIT
//
	wire	[23:0]	pipe_tx_h = {				// transmitted on high side of clock
						6'h0,
						pipe_tx_datak_swap[1:0],
						pipe_tx_data_swap[15:0]
					};
	wire	[23:0]	pipe_tx_l = {				// transmitted on low side of clock
						6'h0,
						pipe_tx_datak_swap[3:2],
						pipe_tx_data_swap[31:16]
					};
	// byteswap the outgoing data to the proper order
	wire	[31:0]	pipe_tx_data_swap	= {	pipe_tx_data[7:0], pipe_tx_data[15:8],
											pipe_tx_data[23:16], pipe_tx_data[31:24]};
	wire	[3:0]	pipe_tx_datak_swap	= { pipe_tx_datak[0], pipe_tx_datak[1], 
											pipe_tx_datak[2], pipe_tx_datak[3] };
	reg		[31:0]	pipe_tx_data;
	reg		[3:0]	pipe_tx_datak;
	
	// map DDIO outputs onto wires going to proper IO pins
	wire	[23:0]	pipe_tx_phy;	
	assign			phy_pipe_tx_datak	= pipe_tx_phy[17:16];
	assign			phy_pipe_tx_data	= pipe_tx_phy[15:0];

//
// RECEIVE
//
	wire	[23:0]	pipe_rx_h;
	wire	[23:0]	pipe_rx_l;
	wire	[23:0]	pipe_rx_phy = {
						1'h0,
						phy_phy_status,			// 1
						phy_rx_status,			// 3
						phy_pipe_rx_valid,		// 1
						phy_pipe_rx_datak,		// 2
						phy_pipe_rx_data		// 16
					} /* synthesis keep */ ;

	wire	[1:0]	pipe_rx_valid		= {pipe_rx_h[18],    pipe_rx_l[18]};
	wire	[5:0]	pipe_rx_status		= {pipe_rx_h[21:19], pipe_rx_l[21:19]};
	wire	[1:0]	pipe_phy_status		= {pipe_rx_h[22],    pipe_rx_l[22]};   
	wire	[3:0]	pipe_rx_datak_swap	= {pipe_rx_h[17:16], pipe_rx_l[17:16]};
	wire	[31:0]	pipe_rx_data_swap	= {pipe_rx_h[15:0],  pipe_rx_l[15:0]};

	wire	[3:0]	pipe_rx_datak = {	pipe_rx_datak_swap[0], pipe_rx_datak_swap[1], 
										pipe_rx_datak_swap[2], pipe_rx_datak_swap[3] };
	wire	[31:0]	pipe_rx_data = {	pipe_rx_data_swap[7:0], pipe_rx_data_swap[15:8], 
										pipe_rx_data_swap[23:16], pipe_rx_data_swap[31:24] };

mf_usb3_rx	iu3prx (
	.datain		( pipe_rx_phy ),
	.inclock	( local_clk ),
	.dataout_h	( pipe_rx_h ),
	.dataout_l	( pipe_rx_l )
);

mf_usb3_tx	iu3ptx (
	.datain_h	( pipe_tx_h ),
	.datain_l	( pipe_tx_l ),
	.outclock	( local_clk ),
	.dataout	( pipe_tx_phy )
);

	

endmodule
