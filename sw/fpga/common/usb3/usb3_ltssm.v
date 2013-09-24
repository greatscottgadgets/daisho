
//
// usb 3.0 ltssm and lfps
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_ltssm (

input	wire			ext_clk,
input	wire			slow_clk,
input	wire			local_clk,
input	wire			reset_n,

input	wire			vbus_present,
input	wire			port_rx_valid,
input	wire			port_rx_elecidle,
input	wire	[1:0]	port_power_state,
output	reg				port_rx_term,
output	reg				port_tx_detrx_lpbk,
output	reg				port_tx_elecidle,
output	wire	[4:0]	ltssm_state,

input	wire			partner_looking,
input	wire			partner_detected,
output	reg				partner_detect,

input	wire			port_power_ack,
input	wire			port_power_err,
output	reg		[1:0]	port_power_down,
output	reg				port_power_go,

output	reg				training,
output	reg				train_rxeq,
input	wire			train_rxeq_pass,
output	reg				train_active,
input	wire			train_ts1,
input	wire			train_ts2,
output	reg				train_config,
output	reg				train_idle,
input	wire			train_idle_pass,

input	wire			go_recovery,

output	reg				lfps_send_ack,
input	wire			lfps_send_poll,
input	wire			lfps_send_ping,
input	wire			lfps_send_u1,
input	wire			lfps_send_u2lb,
input	wire			lfps_send_u3,

output	reg				lfps_recv_active,
output	reg				lfps_recv_poll_u1,
output	reg				lfps_recv_ping,
output	reg				lfps_recv_reset,
output	reg				lfps_recv_u2lb,
output	reg				lfps_recv_u3,

output	reg				warm_reset

);

`include "usb3_const.vh"

	reg				vbus_present_1, vbus_present_2;
	reg				port_rx_elecidle_1, port_rx_elecidle_2;
	reg				port_rx_valid_1, port_rx_valid_2;

	reg		[4:0]	state;
	reg		[4:0]	lfps_send_state;
	reg		[4:0]	lfps_recv_state;
					
	reg		[24:0]	dc;							// delay count
	reg		[4:0]	tc;							// train count
	reg		[7:0]	tsc;							// train send count
	//reg		[24:0]	ic;							// interval count
	reg		[24:0]	sc;							// send FSM count
	reg		[24:0]	sic;						// send internal count
	reg		[24:0]	rc;							// receive FSM count
	reg		[24:0]	ric;						// receive interval count
	
	reg				lfps_send_poll_local;		// OR'd with external LFPS request
	reg				lfps_send_ping_local;		// inputs, so either source may invoke
	reg				lfps_send_u1_local;			// an LFPS transmission
	reg				lfps_send_u2lb_local;
	reg				lfps_send_u3_local;
	reg				lfps_send_reset_local;
	
	reg				lfps_recv_poll_u1_prev;		// used to detect these specific two LFPS
	reg				lfps_recv_ping_prev;		// patterns that dictate repeat lengths

	reg		[3:0]	rx_detect_attempts;
	reg		[5:0]	polling_lfps_sent;
	reg		[3:0]	polling_lfps_received;
	reg		[3:0]	polling_lfps_sent_after_recv;
	reg				has_trained;
	
assign	ltssm_state = state;

always @(posedge slow_clk) begin
	
	// synchronizers
	{vbus_present_2, vbus_present_1} <= {vbus_present_1, vbus_present};
	{port_rx_elecidle_2, port_rx_elecidle_1} <= {port_rx_elecidle_1, port_rx_elecidle};
	{port_rx_valid_2, port_rx_valid_1} <= {port_rx_valid_1, port_rx_valid};
	
	// default levels for outputs
	port_rx_term <= 1;
	port_tx_detrx_lpbk <= 0;
	port_tx_elecidle <= 1;
	partner_detect <= 0;
	port_power_go <= 0;
	
	training <= 0;
	train_rxeq <= 0;
	train_active <= 0;
	train_config <= 0;
	train_idle <= 0;
	
	lfps_send_ack <= 0;
	lfps_send_poll_local <= 0;
	lfps_send_ping_local <= 0;
	lfps_send_u1_local <= 0;
	lfps_send_u2lb_local <= 0;
	lfps_send_u3_local <= 0;
	lfps_send_reset_local <= 0;
	
	lfps_recv_active <= 0;
	lfps_recv_poll_u1 <= 0;
	lfps_recv_ping <= 0;
	lfps_recv_reset <= 0;
	lfps_recv_u2lb <= 0;
	lfps_recv_u3 <= 0;
	
	warm_reset <= 0;
	
	// counters
	dc <= dc + 1'b1;
	sc <= sc + 1'b1;
	sic <= sic + 1'b1;
	rc <= rc + 1'b1;
	ric <= ric + 1'b1;
	
	
	///////////////////////////////////////
	// LTSSM FSM
	///////////////////////////////////////
	case(state)
	LT_SS_DISABLED: begin
		//port_rx_term <= 0;
		
		//if(lfps_recv_reset) state <= LT_RX_DETECT_RESET;
	end
	LT_SS_INACTIVE: begin
		state <= LT_SS_INACTIVE_DETECT;
	end
	LT_SS_INACTIVE_DETECT: begin
	end
	LT_SS_INACTIVE_QUIET: begin
	end
	LT_RX_DETECT_RESET: begin
		// IF WARM RESET:
		// finish transmitting LFPS.Reset until the duration
		// is reached. (TODO)
		rx_detect_attempts <= 0;
		state <= LT_RX_DETECT_ACTIVE_0;
	end
	LT_RX_DETECT_ACTIVE_0: begin
		partner_detect <= 1;
		if(partner_looking) state <= LT_RX_DETECT_ACTIVE_1;
	end
	LT_RX_DETECT_ACTIVE_1: begin
		if(~partner_looking) begin
			dc <= 0;
			if(partner_detected) begin
				// far-end termination detected
				polling_lfps_sent <= 0;
				polling_lfps_received <= 0;
				polling_lfps_sent_after_recv <= 0;
				state <= LT_POLLING_LFPS;
			end else begin
				// not found
				rx_detect_attempts <= rx_detect_attempts + 1'b1;
				if(rx_detect_attempts == 7) begin
					state <= LT_SS_DISABLED;
				end else begin
					state <= LT_RX_DETECT_QUIET;
				end
			end
		end
	end
	LT_RX_DETECT_QUIET: begin
		// wait a bit, then run the farend detection again
		if(dc == T_RX_DETECT_QUIET) begin
			state <= LT_RX_DETECT_ACTIVE_0;
		end			
	end
	LT_POLLING_LFPS: begin
		lfps_send_poll_local <= 1;
		
		// receiving Polling.LFPS from link partner
		if(lfps_recv_poll_u1) begin
			if(polling_lfps_received < 15)
				polling_lfps_received <= polling_lfps_received + 1'b1;
		end
		
		// confirmed LFPS fsm sent
		if(lfps_send_ack) begin
			if(polling_lfps_sent_after_recv < 15 && polling_lfps_received > 0)
				polling_lfps_sent_after_recv <= polling_lfps_sent_after_recv + 1'b1;
			if(polling_lfps_sent < 20)
				polling_lfps_sent <= polling_lfps_sent + 1'b1;
		end
		
		// exit conditions
		if(	polling_lfps_sent_after_recv >= 4 && 
			polling_lfps_sent >= 16 &&
			polling_lfps_received >= 2) begin
			
			// done
			lfps_send_poll_local <= 0;
			state <= LT_POLLING_RXEQ_0;
		end
		
		if(dc == T_POLLING_LFPS) begin
			// timed out
			if(has_trained) state <= LT_SS_DISABLED;
			dc <= 0;
		end
	end
	LT_POLLING_RXEQ_0: begin
		// wait for any straggling LFPS sends to clear
		dc <= 0;
		if(lfps_send_state == LFPS_IDLE) state <= LT_POLLING_RXEQ_1;
	end
	LT_POLLING_RXEQ_1: begin
		port_power_down <= POWERDOWN_0;
		port_power_go <= 1;
		
		// maintain values, unless overridden below
		training <= 1;
		train_rxeq <= train_rxeq;
		
		// wait until P0 powerdown is entered so that
		// the transceiver proper is ready
		if(port_power_ack) begin
			// signal to PIPE module, TSEQ 65536 send
			train_rxeq <= 1;
		end
		if(train_rxeq_pass) begin
			// reset timeout count and proceed
			dc <= 0;
			tc <= 0;
			state <= LT_POLLING_ACTIVE;
		end
	end
	LT_POLLING_ACTIVE: begin
		// send TS1 until 8 consecutive TS are received
		// N.B. my test root hub only sends 6
		training <= 1;
		train_active <= 1;
		
		if(train_ts1 | train_ts2) tc <= tc + 1'b1;
		
		if(tc == 8) begin
			// received 8 consecutive(TODO?) TS1/TS2
			// reset timeout count and proceed
			dc <= 0;
			tc <= 0;
			tsc <= 0;
			state <= LT_POLLING_CONFIG;
		end
		
		// timeout
		if(dc == T_POLLING_ACTIVE) state <= LT_SS_DISABLED;
	end
	LT_POLLING_CONFIG: begin
		training <= 1;
		train_config <= 1;
	
		// increment TS2 receive count up to 8
		if(train_ts2) begin
			if(tc < 8) tc <= tc + 1'b1;			
		end
		// increment TS2 send count, sequence is 4 cycles long
		if(tc > 0) if(tsc < 16*4) tsc <= tsc + 1'b1;
		
		// exit criteria
		// received 8 and sent 16
		if(tc == 8 && tsc == 16*4) begin
			// reset timeout count and proceed
			dc <= 0;
			tc <= 0;
			tsc <= 0;
			state <= LT_POLLING_IDLE;
		end
		
		// timeout
		if(dc == T_POLLING_CONFIG) state <= LT_SS_DISABLED;
	end
	LT_POLLING_IDLE: begin
		training <= 1;
		train_idle <= 1;
		
		if(train_idle_pass) begin
			// exit conditions:
			// 16 IDLE symbol sent after receiving
			// first of at least 8 symbols.
			dc <= 0;
			state <= LT_U0;
		end
		
		// timeout
		if(dc == T_POLLING_IDLE)  state <= LT_SS_DISABLED;
	end
	LT_U0: begin
	
		if(dc == T_U0_RECOVERY) begin
			// 1ms passed without receiving any link command.
			// transition to recovery state and re-train
			state <= LT_RECOVERY;
		end	
		
		if(train_ts1) begin
			// TS1 detected, go to Recovery
			state <= LT_RECOVERY;
		end
		
		if(go_recovery) begin
			// link layer had a problem, Recovery
			state <= LT_RECOVERY;
		end
	end
	LT_U1: begin
	end
	LT_U2: begin
	end
	LT_U3: begin
	end
	
	LT_RECOVERY: begin
		dc <= 0;
		tc <= 0;
		tsc <= 0;
		state <= LT_RECOVERY_ACTIVE;
	end
	LT_RECOVERY_ACTIVE: begin
		// send TS1 until 8 consecutive TS are received
		training <= 1;
		train_active <= 1;
		
		if(train_ts1 | train_ts2) tc <= tc + 1'b1;
		
		if(tc == 8) begin
			// received 8 consecutive(TODO?) TS1/TS2
			// reset timeout count and proceed
			dc <= 0;
			tc <= 0;
			tsc <= 0;
			state <= LT_RECOVERY_CONFIG;
		end
		
		if(dc == T_RECOV_ACTIVE) state <= LT_SS_INACTIVE;
	end
	LT_RECOVERY_CONFIG: begin
		training <= 1;
		train_config <= 1;
	
		// increment TS2 receive count up to 8
		if(train_ts2) begin
			if(tc < 8) tc <= tc + 1'b1;			
		end
		// increment TS2 send count, sequence is 4 cycles long
		if(tc > 0) if(tsc < 16*4) tsc <= tsc + 1'b1;
		
		// exit criteria
		// received 8 and sent 16
		if(tc == 8 && tsc == 16*4) begin
			// reset timeout count and proceed
			dc <= 0;
			tc <= 0;
			tsc <= 0;
			state <= LT_RECOVERY_IDLE;
		end
		
		if(dc == T_RECOV_CONFIG) state <= LT_SS_INACTIVE;
	end
	LT_RECOVERY_IDLE: begin
		training <= 1;
		train_idle <= 1;
		
		if(train_idle_pass) begin
			// exit conditions:
			// 16 IDLE symbol sent after receiving
			// first of at least 8 symbols.
			dc <= 0;
			state <= LT_U0;
		end
		
		if(dc == T_RECOV_IDLE) state <= LT_SS_INACTIVE;
	end
	
	
	LT_COMPLIANCE: begin
	end
	LT_LOOPBACK: begin
	end
	LT_HOTRESET: begin
		// reset Link Error Count here
		// TODO
		state <= LT_U0;
	end
	
	LT_RESET: begin
		port_rx_term <= 0;
		port_power_down <= POWERDOWN_2;
		has_trained <= 0;
		state <= LT_RX_DETECT_RESET;
	end
	default: state <= LT_RESET;
	endcase
	
	
	
	///////////////////////////////////////
	// LFPS SEND FSM
	///////////////////////////////////////
	case(lfps_send_state)
	LFPS_RESET: begin
		lfps_send_state <= LFPS_IDLE;
	end
	LFPS_IDLE: begin
		if(port_rx_elecidle_2 && !training) begin
			// clear to go
			if(lfps_send_poll | lfps_send_poll_local) begin
				// Polling.LFPS
				sc <= LFPS_POLLING_NOM;
				sic <= LFPS_BURST_POLL_NOM;
				lfps_send_state <= LFPS_SEND_1;
			end else if(lfps_send_ping | lfps_send_ping_local) begin
				// Ping.LFPS
				sc <= LFPS_PING_NOM;
				sic <= LFPS_BURST_PING_NOM;
				lfps_send_state <= LFPS_SEND_1;
			end else if(lfps_send_u1 | lfps_send_u1_local) begin
				// U1 Exit
				sc <= LFPS_U1EXIT_NOM;
				sic <= LFPS_U1EXIT_NOM;
				lfps_send_state <= LFPS_SEND_1;
			end else if(lfps_send_u2lb | lfps_send_u2lb_local) begin
				// U2 Exit
				sc <= LFPS_U2LBEXIT_NOM;
				sic <= LFPS_U2LBEXIT_NOM;
				lfps_send_state <= LFPS_SEND_1;
			end else if(lfps_send_u3 | lfps_send_u3_local) begin
				// U3 Exit
				sc <= LFPS_U3WAKEUP_NOM;
				sic <= LFPS_U3WAKEUP_NOM;
				lfps_send_state <= LFPS_SEND_1;
			end
		end
		if(lfps_send_reset_local) begin
			// WarmReset
			lfps_send_state <= LFPS_SEND_1;
		end
	end
	LFPS_SEND_1: begin
		// decide how to send LFPS based on power state
		if(port_power_state == POWERDOWN_0) begin
			port_tx_elecidle <= 1;
			port_tx_detrx_lpbk <= 1;
		end else begin
			port_tx_elecidle <= 0;
		end
		// decrement pulse width and repeat interval
		sc <= sc - 1'b1;
		sic <= sic - 1'b1;
		if(sc == 0) lfps_send_state <= LFPS_SEND_2;
		
		if(lfps_send_reset_local) begin
			// special case here -- WarmReset must be ack'd 
			// and in response send LFPS until it's deasserted by host
			lfps_send_state <= lfps_send_state;
			// catch the rising edge
			if(port_rx_elecidle_2) begin
				lfps_send_state <= LFPS_IDLE;
			end
		end
	end
	LFPS_SEND_2: begin
		// decrement repeat interval
		sic <= sic - 1'b1;
		if(sic == 0) begin
			lfps_send_ack <= 1;
			lfps_send_state <= LFPS_IDLE;
		end
	end
	LFPS_SEND_3: begin
		// keep
	end
	default: lfps_send_state <= LFPS_RESET;
	endcase
	
	
	
	///////////////////////////////////////
	// LFPS RECEIVE FSM
	///////////////////////////////////////
	case(lfps_recv_state)
	LFPS_RESET: begin
		lfps_recv_state <= LFPS_IDLE;
		lfps_recv_poll_u1_prev <= 0;
		lfps_recv_ping_prev <= 0;
	end
	LFPS_IDLE: begin
		// lfps burst begin
		if(~port_rx_elecidle_2 & ~port_rx_valid_2) begin
			rc <= 0;
			lfps_recv_state <= LFPS_RECV_1;
		end
	end
	LFPS_RECV_1: begin
		// lfps burst end
		// ASSUMPTION: PIPE BUS WILL NOT START A TRANSFER
		// RIGHT AFTER LFPS? (TODO)
		
		// detect WarmReset by seeing if LFPS continues past tResetDelay
		if(rc > LFPS_RESET_DELAY) begin
			// want to send LFPS to signal we acknowledge the WarmReset
			// N.B. per spec this is not acceptable during SS.Disabled
			if(~port_rx_elecidle_2) lfps_send_reset_local <= 1;
		end
		// wait for rising edge
		if(port_rx_elecidle_2) begin
			lfps_recv_state <= LFPS_IDLE;
			lfps_recv_active <= 1;
			
			// reset these by default
			lfps_recv_poll_u1_prev <= 0;
			lfps_recv_ping_prev <= 0;
			
			ric <= 0;
			
			if(rc >= LFPS_POLLING_MIN && rc < LFPS_POLLING_MAX) begin
				// Polling.LFPS (or U1.Exit)
				if(lfps_recv_poll_u1_prev) begin
					// we've received this once already
					// now check burst length parameters
					if(ric >= LFPS_BURST_POLL_MIN && ric < LFPS_BURST_POLL_MAX) 
						lfps_recv_poll_u1 <= 1;
				end else
					lfps_recv_active <= 0;
					
				lfps_recv_poll_u1_prev <= 1;
				ric <= 0;
			end else if(rc >= LFPS_PING_MIN && rc < LFPS_PING_MAX) begin
				// Ping.LFPS
				if(lfps_recv_ping_prev) begin
					// we've received this once already
					// now check burst length parameters
					if(ric >= LFPS_BURST_PING_MIN && ric < LFPS_BURST_PING_MAX) 
						lfps_recv_ping <= 1;
				end else
					lfps_recv_active <= 0;
					
				lfps_recv_ping_prev <= 1;
				ric <= 0;
			end else if(rc >= LFPS_RESET_MIN && rc < LFPS_RESET_MAX) begin
				// WarmReset
				lfps_recv_reset <= 1;
			end else if(rc >= LFPS_U1EXIT_MIN && rc < LFPS_U1EXIT_MAX) begin
				// U1.Exit
				lfps_recv_poll_u1 <= 1;
			end else if(rc >= LFPS_U2LBEXIT_MIN && rc < LFPS_U2LBEXIT_MAX) begin
				// U2/Loopback.Exit
				lfps_recv_u2lb <= 1;
			end else if(rc >= LFPS_U3WAKEUP_MIN && rc < LFPS_U3WAKEUP_MAX) begin
				// U3.Wakeup
				lfps_recv_u3 <= 1;
			end else begin
				// invalid burst
				//lfps_recv_state <= LFPS_IDLE;
				lfps_recv_active <= 0;
			end
		end
	end
	LFPS_RECV_2: begin
	end
	LFPS_RECV_3: begin
	end
	default: lfps_recv_state <= LFPS_RESET;
	endcase
	
	
	
	if(~reset_n | ~vbus_present_2) begin
		// reset
		state <= LT_RESET;
		lfps_send_state <= LFPS_RESET;
		lfps_recv_state <= LFPS_RESET;
	end
end

endmodule
