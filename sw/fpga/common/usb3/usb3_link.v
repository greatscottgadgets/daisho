
//
// usb 3.0 link level
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_link (

input	wire			slow_clk,
input	wire			local_clk,
input	wire			reset_n,

input	wire	[4:0]	ltssm_state,
input	wire			ltssm_hot_reset,
output	reg				ltssm_go_recovery,

// pipe interface
input	wire	[31:0]	in_data,
input	wire	[3:0]	in_datak,
input	wire			in_active,

output	reg		[31:0]	out_data,
output	reg		[3:0]	out_datak,
output	reg				out_active,
output	reg				out_skp_inhibit,
output	reg				out_skp_defer,
input	wire			out_stall,

// protocol interface
output	reg		[3:0]	sel_endp,
input	wire	[1:0]	endp_mode,
input	wire	[6:0]	dev_addr,

output	reg		[8:0]	buf_in_addr,
output	reg		[31:0]	buf_in_data,
output	reg				buf_in_wren,
input	wire			buf_in_ready,
output	reg				buf_in_commit,
output	reg		[10:0]	buf_in_commit_len,
input	wire			buf_in_commit_ack,

output	reg		[9:0]	buf_out_addr,
input	wire	[31:0]	buf_out_q,
input	wire	[10:0]	buf_out_len,
input	wire			buf_out_hasdata,
output	reg				buf_out_arm,
input	wire			buf_out_arm_ack,

// error outputs
output	reg				err_lcmd_undefined,
output	reg				err_lcrd_mismatch,
output	reg				err_lgood_order,
output	reg				err_hp_crc,
output	reg				err_hp_seq,
output	reg				err_hp_type,
output	reg				err_dpp_len_mismatch

);

`include "usb3_const.vh"	
	
	reg		[5:0]	send_state;
parameter	[5:0]	LINK_SEND_RESET		= 'd0,
					LINK_SEND_IDLE		= 'd2,
					LINK_SEND_0			= 'd4,
					LINK_SEND_1			= 'd6,
					LINK_SEND_2			= 'd8,
					LINK_SEND_3			= 'd10,
					LINK_SEND_4			= 'd12,
					LINK_SEND_CMDW_0	= 'd14,
					LINK_SEND_CMDW_1	= 'd16,
					LINK_SEND_HP_0		= 'd18,
					LINK_SEND_HP_1		= 'd20;

	reg		[5:0]	recv_state;
parameter	[5:0]	LINK_RECV_RESET		= 'd0,
					LINK_RECV_IDLE		= 'd2,
					LINK_RECV_HP_0		= 'd4,
					LINK_RECV_HP_1		= 'd5,
					LINK_RECV_DP_0		= 'd7,
					LINK_RECV_DP_1		= 'd8,
					LINK_RECV_DP_2		= 'd9,
					LINK_RECV_DP_3		= 'd10,
					LINK_RECV_CMDW_0		= 'd15,
					LINK_RECV_CMDW_1		= 'd16,
					LINK_RECV_CMDW_2		= 'd17,
					LINK_RECV_CMDW_3		= 'd18,
					LINK_RECV_CMDW_4		= 'd19;

	reg		[5:0]	read_dpp_state;
parameter	[5:0]	READ_DPP_RESET		= 'd0,
					READ_DPP_IDLE		= 'd1,
					READ_DPP_0			= 'd2,
					READ_DPP_1			= 'd3,
					READ_DPP_2			= 'd4,
					READ_DPP_3			= 'd5,
					READ_DPP_4			= 'd6,
					READ_DPP_5			= 'd7,
					READ_DPP_6			= 'd8;
					
	reg		[5:0]	write_dpp_state;
parameter	[5:0]	WRITE_DPP_RESET		= 'd0,
					WRITE_DPP_IDLE		= 'd1,
					WRITE_DPP_0			= 'd2,
					WRITE_DPP_1			= 'd3,
					WRITE_DPP_2			= 'd4,
					WRITE_DPP_3			= 'd5,
					WRITE_DPP_4			= 'd6,
					WRITE_DPP_5			= 'd7,
					WRITE_DPP_6			= 'd8,
					WRITE_DPP_7			= 'd9,
					WRITE_DPP_8			= 'd10,
					WRITE_DPP_9			= 'd11,
					WRITE_DPP_10		= 'd12,
					WRITE_DPP_11		= 'd13,
					WRITE_DPP_12		= 'd14,
					WRITE_DPP_13		= 'd15;
					
	reg		[5:0]	check_hp_state;
parameter	[5:0]	CHECK_HP_RESET		= 'd0,
					CHECK_HP_IDLE		= 'd1,
					CHECK_HP_0			= 'd2,
					CHECK_HP_1			= 'd3,
					CHECK_HP_2			= 'd4,
					CHECK_HP_3			= 'd5;

	reg		[5:0]	expect_state;
parameter	[5:0]	LINK_EXPECT_RESET		= 'd0,
					LINK_EXPECT_IDLE		= 'd2,
					LINK_EXPECT_HDR_SEQ_AD	= 'd4,
					LINK_EXPECT_HP_1		= 'd6,
					LINK_EXPECT_HP_2		= 'd8,
					LINK_EXPECT_HP_3		= 'd10;
					
	reg		[5:0]	queue_state;
parameter	[5:0]	LINK_QUEUE_RESET		= 'd0,
					LINK_QUEUE_IDLE			= 'd2,
					LINK_QUEUE_HDR_SEQ_AD	= 'd4,
					LINK_QUEUE_PORTCAP		= 'd6,
					LINK_QUEUE_PORTCFGRSP	= 'd8,
					LINK_QUEUE_ACK			= 'd10,
					LINK_QUEUE_DP			= 'd12;
						
	reg		[4:0]	rd_hp_state;
parameter	[4:0]	RD_HP_RESET			= 'd0,
					RD_HP_IDLE			= 'd1,
					RD_HP_LMP_0			= 'd4,
					RD_HP_LMP_1			= 'd5,
					RD_HP_TP_0			= 'd10,
					RD_HP_TP_1			= 'd11,
					RD_HP_TP_2			= 'd12,
					RD_HP_TP_3			= 'd13,
					RD_HP_TP_4			= 'd14,
					RD_HP_DP_0			= 'd16,
					RD_HP_DP_1			= 'd17,
					RD_HP_DP_2			= 'd18,
					RD_HP_DP_3			= 'd19,
					RD_HP_0				= 'd20,
					RD_HP_1				= 'd21,
					RD_HP_2				= 'd22,
					RD_HP_3				= 'd22,
					RD_HP_ITP_0			= 'd23,
					RD_HP_ITP_1			= 'd24;
					
					
	reg		[3:0]	rd_lcmd_state;
parameter	[3:0]	RD_LCMD_RESET		= 'd0,
					RD_LCMD_IDLE		= 'd1,
					RD_LCMD_0			= 'd2;
					
	reg		[3:0]	wr_lcmd_state;
parameter	[3:0]	WR_LCMD_RESET		= 'd0,
					WR_LCMD_IDLE		= 'd1,
					WR_LCMD_0			= 'd2,
					WR_LCMD_1			= 'd3;
					
	reg		[3:0]	wr_hp_state;
parameter	[3:0]	WR_HP_RESET		= 'd0,
					WR_HP_IDLE		= 'd1,
					WR_HP_0			= 'd2,
					WR_HP_1			= 'd3,
					WR_HP_2			= 'd4,
					WR_HP_3			= 'd5,
					WR_HP_4			= 'd6,
					WR_HP_5			= 'd7,
					WR_HP_6			= 'd8,
					WR_HP_7			= 'd9;
	
	reg		[4:0]	ltssm_last;
	reg		[4:0]	ltssm_stored /* synthesis noprune */;
	reg				ltssm_changed /* synthesis noprune */;
	reg				ltssm_go_recovery_1;
	
	reg		[24:0]	dc;
	
	reg		[24:0]	u0l_timeout;
	reg		[24:0]	u0_recovery_timeout;
	reg		[24:0]	pending_hp_timer;
	reg		[24:0]	credit_hp_timer;
	reg		[7:0]	link_error_count;
	reg				force_linkpm_accept;
	reg		[24:0]	T_PORT_U2_TIMEOUT;
	
	reg		[2:0]	tx_hdr_seq_num /* synthesis noprune */;			// Header Sequence Number (0-7)
	reg		[2:0]	ack_tx_hdr_seq_num /* synthesis noprune */;		// ACK Header Seq Num
	reg		[2:0]	rx_hdr_seq_num /* synthesis noprune */;			// RX Header Seq Num
	wire	[2:0]	rx_hdr_seq_num_dec = rx_hdr_seq_num - 3'h1;
	reg		[2:0]	local_rx_cred_count /* synthesis noprune */;	// Local RX Header Credit Count (0-4)
	reg		[2:0]	remote_rx_cred_count /* synthesis noprune */;	// Remote RX Header Credit
	reg		[1:0]	tx_cred_idx /* synthesis noprune */;			
	reg		[1:0]	rx_cred_idx /* synthesis preserve */;
	reg		[26:0]	itp_value;
	wire	[13:0]	bus_interval_count = itp_value[13:0];
	
	reg		[3:0]	in_header_pkt_queued;
	reg		[1:0]	in_header_pkt_pick;
	reg		[95:0]	in_header_pkt_work /* synthesis noprune */;
	reg		[95:0]	in_header_pkt_a;
	reg		[95:0]	in_header_pkt_b;
	reg		[95:0]	in_header_pkt_c;
	reg		[95:0]	in_header_pkt_d;
	reg		[1:0]	out_header_pkt_pick;
	wire	[95:0]	out_header_pkt_mux = (	out_header_pkt_pick == 0 ? out_header_pkt_a :
											out_header_pkt_pick == 1 ? out_header_pkt_b :
											out_header_pkt_pick == 2 ? out_header_pkt_c : 
											out_header_pkt_d );
	reg		[95:0]	out_header_pkt_a;
	reg		[95:0]	out_header_pkt_b;
	reg		[95:0]	out_header_pkt_c;
	reg		[95:0]	out_header_pkt_d;
	
	reg		[31:0]	out_data_1, out_data_2;
	reg		[3:0]	out_datak_1, out_datak_2;
	reg				out_active_1, out_active_2;
	reg		[10:0]	out_header_cw;
	
	reg		[15:0]	in_header_cw_a;
	reg		[15:0]	in_header_cw_b;
	reg		[15:0]	in_header_cw_c;
	reg		[15:0]	in_header_cw_d;
	reg		[15:0]	in_header_cw;
	wire	[2:0]	in_header_seq = in_header_cw[2:0];
	reg		[15:0]	in_header_crc;
	reg		[1:0]	in_header_err_count;
	
	reg				out_header_first_since_entry;
	
	reg		[31:0]	in_link_command /* synthesis noprune */;
	reg		[31:0]	in_link_command_1 /* synthesis noprune */;
	reg				in_link_command_act /* synthesis noprune */;

	wire	[31:0]	in_data_swap16 = {in_data[23:16], in_data[31:24], in_data[7:0], in_data[15:8]};
	wire	[31:0]	in_data_swap32 = {in_data[7:0], in_data[15:8], in_data[23:16], in_data[31:24]};
	reg		[31:0]	in_data_1;
	reg		[31:0]	in_data_2;
	reg		[31:0]	in_data_3;
	reg		[31:0]	in_data_4;
	reg		[31:0]	in_data_5;
	reg		[31:0]	in_data_6 /* synthesis noprune */;
	reg		[3:0]	in_datak_1;
	reg		[3:0]	in_datak_2;
	reg		[3:0]	in_datak_3;
	reg		[3:0]	in_datak_4;
	reg		[3:0]	in_datak_5;
	reg		[3:0]	in_datak_6 /* synthesis noprune */;
	
	reg		[15:0]	in_dpp_length /* synthesis noprune */;
	reg		[15:0]	in_dpp_length_expect /* synthesis noprune */;
	reg				in_dpp_setup /* synthesis noprune */;
	reg		[4:0]	in_dpp_seq /* synthesis noprune */;
	reg				in_dpp_expect /* synthesis noprune */;
	reg				in_dpp_wasready;
	reg		[31:0]	in_dpp_crc32 /* synthesis noprune */;
	
	reg		[15:0]	out_dpp_length /* synthesis noprune */;
	reg		[15:0]	out_dpp_length_remain /* synthesis noprune */;
	reg		[15:0]	out_dpp_length_remain_1 /* synthesis noprune */;
	reg				out_dpp_setup /* synthesis noprune */;
	reg		[4:0]	out_dpp_seq /* synthesis noprune */;
	reg		[95:0]	out_dpp_end;
	reg		[11:0]	out_dpp_endk;
	
	//reg				out_dpp_expect /* synthesis noprune */;
	//reg				out_dpp_wasready;
	//reg		[31:0]	in_dpp_crc32 /* synthesis noprune */;
	
	reg				buf_in_ready_1;
	
	reg		[10:0]	rx_lcmd  /* synthesis noprune */;
	reg				rx_lcmd_act  /* synthesis noprune */;
	
	reg		[10:0]	tx_lcmd  /* synthesis noprune */;
	reg				tx_lcmd_act  /* synthesis noprune */;
	reg				tx_lcmd_act_1;
	reg				tx_lcmd_queue;
	wire			tx_lcmd_do = (tx_lcmd_act & ~tx_lcmd_act_1) | tx_lcmd_queue;
	reg		[10:0]	tx_lcmd_latch;
	reg				tx_lcmd_done  /* synthesis noprune */;
	
	reg		[6:0]	local_dev_addr;
	
	reg		[31:0]	tx_hp_word_0;
	reg		[31:0]	tx_hp_word_1;
	reg		[31:0]	tx_hp_word_2;	

	reg				tx_hp_act  /* synthesis noprune */;
	reg				tx_hp_act_1;
	reg				tx_hp_queue;
	wire			tx_hp_do = (tx_hp_act & ~tx_hp_act_1) | tx_hp_queue;
	reg		[10:0]	tx_hp_latch;
	reg				tx_hp_done  /* synthesis noprune */;
	reg				tx_hp_dph;
	
	reg				tx_queue_open;
	reg				tx_queue_lup;
	reg		[2:0]	tx_queue_lcred;	// {strobe, CRD_A-CRD_D[1:0]
	reg		[6:0]	tx_queue_ack;	// {err, strobe, NumP[4:0]
	reg		[6:0]	tx_queue_erdy;	// {err, strobe, NumP[4:0]
	reg				tx_queue_nrdy;
	reg				tx_queue_dpp;
	
	reg				send_port_cfg_resp;
	
	reg		[9:0]	qc;		// queue counter
	reg				queue_send_u0_adv;
	reg				sent_u0_adv;
	reg				queue_send_u0_portcap;
	reg				sent_u0_portcap;
	
	reg		[9:0]	rc;		// receive counter
	reg		[9:0]	sc;		// send counter
	
always @(posedge local_clk) begin

	ltssm_last <= ltssm_state;
	ltssm_changed <= 0;
	ltssm_go_recovery_1 <= ltssm_go_recovery;
	
	out_skp_inhibit <= 0;
	out_skp_defer <= 0;
	
	out_data <= 32'h0;
	out_data_1 <= 32'h0;
	out_data_2 <= 32'h0;
	out_datak <= 4'b0000;
	out_datak_1 <= 4'b0000;
	out_datak_2 <= 4'b0000;
	out_active <= 1'b0;
	out_active_1 <= 1'b0;
	out_active_2 <= 1'b0;
	
	{in_data_6, in_data_5,  in_data_4,  in_data_3,  in_data_2,  in_data_1}  <= 
		{in_data_5, in_data_4,  in_data_3,  in_data_2,  in_data_1,  in_data};
	{in_datak_6, in_datak_5, in_datak_4, in_datak_3, in_datak_2, in_datak_1} <= 
		{in_datak_5, in_datak_4, in_datak_3, in_datak_2, in_datak_1, in_datak};
	
	tx_lcmd_act <= 0;
	tx_lcmd_act_1 <= tx_lcmd_act;
	tx_lcmd_done <= 0;
	if(tx_lcmd_do) tx_lcmd_queue <= 1;
	
	tx_hp_act <= 0;
	tx_hp_act_1 <= tx_hp_act;
	tx_hp_done <= 0;
	if(tx_hp_do) tx_hp_queue <= 1;
	
	rx_lcmd_act <= 0;

	crc_hprx_rst <= 0;
	crc_hptx_rst <= 0;
	crc_dpprx_rst <= 0;
	crc_dpptx_rst <= 0;
	
	buf_in_wren <= 0;
	buf_in_commit <= 0;
	buf_out_arm <= 0;
	buf_in_ready_1 <= buf_in_ready;
	
	`INC(dc);
	`INC(rc);
	`INC(sc);
		
	// detect LTSSM change
	if(ltssm_last != ltssm_state) begin
		ltssm_changed <= 1;
		ltssm_stored <= ltssm_last;
	end	

	if(ltssm_go_recovery & ~ltssm_go_recovery_1) begin
		// rising edge, increment error count
		`INC(link_error_count);
	end
	
	// handle LTSSM change
	if(ltssm_changed) begin
		case(ltssm_state) 
		LT_U0: begin
			// upon entry to U0, we must send : (Page 194)
			// 1. Header Sequence Advertisement [LGOOD_(rx_hdr_seq_num-1)]
			// 2. Advertisement of Link Credits (ABCD)
			// flush all header packets in Tx Header Buffers =< advertised number
			// initialize ACK Tx HdrSeqNum to value_received+1
			// start PENDING_HP_TIMER and CREDIT_HP_TIMER in expectation of HdrSeqNum and RxHdrBufCred
			// Note that the state should be preserved upon U0 entry because Recovery and thereby U0
			// are entered quite frequently, and both ends need to keep track of what packets had been
			// sent prior to Recovery, whether by a random phy error or power state change (ex. U1->U0)
			
			if(ltssm_stored == LT_POLLING_IDLE || ltssm_stored == LT_HOTRESET_EXIT) begin
				// only reset these in inital U0 entry or Hot Reset, lose state
				tx_hdr_seq_num <= 0;
				rx_hdr_seq_num <= 0;
				local_rx_cred_count <= 4;
				
				// clear HP parse queue
				in_header_pkt_queued <= 4'b0000;
				// flush all header packet buffers
				in_header_pkt_a <= 'h0;
				in_header_pkt_b <= 'h0;
				in_header_pkt_c <= 'h0;
				in_header_pkt_d <= 'h0;
				
				link_error_count <= 0;
			end
			
			//if(ltssm_stored == LT_POLLING_IDLE || ltssm_stored == LT_RECOVERY_IDLE || ltssm_stored == LT_HOTRESET_EXIT) begin
				// initiate advertisement
				queue_send_u0_adv <= 1;
				queue_send_u0_portcap <= 1;
			//end
			
			// note that the local_rx_cred is not updated here.
			// it should be continually processed by internal logic and updated based on
			// the buffer contents.
			tx_cred_idx <= 0; // A
			rx_cred_idx <= 0; // A
			remote_rx_cred_count <= 0;
			// reset timers
			pending_hp_timer <= 0;
			credit_hp_timer <= 0;
			u0l_timeout <= 0;
			u0_recovery_timeout <= 0;
			dc <= 0;
			// reset flags
			force_linkpm_accept <= 0;
			tx_queue_lup <= 0;
			tx_queue_lcred <= 0;
			tx_queue_ack <= 0;
			tx_queue_nrdy <= 0;
			tx_queue_dpp <= 0;
			tx_queue_open <= 1;
			send_port_cfg_resp <= 0;
			// upon sending of first header packet, the remote rx hdr cred count
			// should be decremented
			out_header_first_since_entry <= 1;
			in_header_err_count <= 0;
			in_dpp_expect <= 0;
		end
		LT_RECOVERY_IDLE: begin
			// we can de-assert the recovery signal now
			ltssm_go_recovery <= 0;
		end
		endcase	
	end
	
	//
	case(ltssm_state)
	LT_U0: begin
		`INC(pending_hp_timer);
		`INC(credit_hp_timer);
		
		// increment U0LTimeout up to its triggering amount (10uS)
		// shall be reset when sending any data, paused then restarted upon idle re-entry
		if(u0l_timeout < T_U0L_TIMEOUT) 
			`INC(u0l_timeout);
			
		// increment U0RecoveryTimeout up to 1ms
		// shall be reset every time link command is received
		if(u0_recovery_timeout < T_U0_RECOVERY)
			`INC(u0_recovery_timeout);
		
		// U0LTimeout generation (LUP/LDN) keepalive
		if(u0l_timeout == T_U0L_TIMEOUT) begin
			// we need to send LUP
			tx_queue_lup <= 1;
			u0l_timeout <= 0;
		end

		// detect absence of far-end heartbeat
		if(u0_recovery_timeout == T_U0_RECOVERY) begin
			// tell LTSSM to transition to Recovery
			ltssm_go_recovery <= 1;
		end
		
		// disable CREDIT_HP_TIMER if no header packets
		// were sent and still unparsed
		if(remote_rx_cred_count == 4) credit_hp_timer <= 0;
	end
	default: begin
		sent_u0_adv <= 0;
		sent_u0_portcap <= 0;
	end
	endcase
	
	
	
	in_link_command_act <= 0;
	in_link_command_1 <= in_link_command;
	
	///////////////////////////////////////
	// LINK RECEIVE (RX) FSM
	///////////////////////////////////////
	
	case(recv_state)
	LINK_RECV_RESET: begin
		recv_state <= LINK_RECV_IDLE;
	end
	LINK_RECV_IDLE: begin
		if(ltssm_state == LT_U0 && in_active) begin
		if({in_data, in_datak} == {32'hFEFEFEF7, 4'b1111}) begin
			// Link Command Word
			u0_recovery_timeout <= 0;
			recv_state <= LINK_RECV_CMDW_0;
		end
		
		if({in_data, in_datak} == {32'hFBFBFBF7, 4'b1111}) begin
			// HPSTART ordered set
			rc <= 0;
			crc_hprx_rst <= 1;
			recv_state <= LINK_RECV_HP_0;
		end
		
		if({in_data, in_datak} == {32'h5C5C5CF7, 4'b1111}) begin
			// Data Packet
			rc <= 0;
			crc_dpprx_rst <= 1;
			recv_state <= LINK_RECV_DP_0;
		end
		end
	end
	LINK_RECV_HP_0: begin
		// shift in header packet (12 bytes)
		// account for possible active de-assert on last word
		if(in_active) begin
			case(rx_cred_idx)
			0: in_header_pkt_a <= {swap32(in_data), in_header_pkt_a[95:32]};
			1: in_header_pkt_b <= {swap32(in_data), in_header_pkt_b[95:32]};
			2: in_header_pkt_c <= {swap32(in_data), in_header_pkt_c[95:32]};
			3: in_header_pkt_d <= {swap32(in_data), in_header_pkt_d[95:32]};
			endcase
			crc_hprx_in <= swap32(in_data);
			if(rc == 2) recv_state <= LINK_RECV_HP_1;
		end else rc <= rc;
	end
	LINK_RECV_HP_1: begin
		// load crc16 of HP + control word (4 bytes)
		if(in_active) begin
			in_header_crc <= in_data_swap16[31:16];
			in_header_cw <= in_data_swap16[15:0];
			// delegate crc and checking of header packet to another fsm
			// so that we can start parsing on the very next cycle
			recv_state <= LINK_RECV_IDLE;
			check_hp_state <= CHECK_HP_0;
		end
	end
	LINK_RECV_CMDW_0: begin
		// byteswap word
		// checks for activity may not be required, since 3C SKP not sent
		// except between packets
		if(in_active) begin
			in_link_command <= in_data_swap16;
			in_link_command_act <= 1;
			recv_state <= LINK_RECV_IDLE;
		end
	end
	LINK_RECV_DP_0: begin
		if(in_active) begin
			
			//crc_dpp_in <= swap32(in_data);
			//if(rc == 2) recv_state <= LINK_RECV_HP_1;
			//if({in_data, in_datak} == {32'hFDFDFDF7, 4'b1111}) 
			recv_state <= LINK_RECV_IDLE;
		end else rc <= rc;
	end
	endcase
	
	//
	// Link State Expect FSM
	//
	case(expect_state)
	LINK_EXPECT_RESET: expect_state <= LINK_EXPECT_IDLE;
	LINK_EXPECT_IDLE: begin
		if(ltssm_state == LT_POLLING_IDLE || ltssm_state == LT_RECOVERY_IDLE) begin
			// finish link training, we will want to expect
			// Header Sequence Advertisement next
			expect_state <= LINK_EXPECT_HDR_SEQ_AD;
		end
	end
	LINK_EXPECT_HDR_SEQ_AD: begin
		if(ltssm_state == LT_U0) begin
			// now it should happen
			case({rx_lcmd, rx_lcmd_act})
			{LCMD_LGOOD_0, 1'b1}: ack_tx_hdr_seq_num <= 1;
			{LCMD_LGOOD_1, 1'b1}: ack_tx_hdr_seq_num <= 2;
			{LCMD_LGOOD_2, 1'b1}: ack_tx_hdr_seq_num <= 3;
			{LCMD_LGOOD_3, 1'b1}: ack_tx_hdr_seq_num <= 4;
			{LCMD_LGOOD_4, 1'b1}: ack_tx_hdr_seq_num <= 5;
			{LCMD_LGOOD_5, 1'b1}: ack_tx_hdr_seq_num <= 6;
			{LCMD_LGOOD_6, 1'b1}: ack_tx_hdr_seq_num <= 7;
			{LCMD_LGOOD_7, 1'b1}: ack_tx_hdr_seq_num <= 0;
			{LCMD_LCRD_A, 1'b1}: begin 
				`INC(remote_rx_cred_count); 
				`INC(rx_cred_idx);
			end
			{LCMD_LCRD_B, 1'b1}: begin 
				`INC(remote_rx_cred_count); 
				`INC(rx_cred_idx);
			end
			{LCMD_LCRD_C, 1'b1}: begin 
				`INC(remote_rx_cred_count); 
				`INC(rx_cred_idx);
			end
			{LCMD_LCRD_D, 1'b1}: begin 
				`INC(remote_rx_cred_count); 
				`INC(rx_cred_idx);
				expect_state <= LINK_EXPECT_IDLE;
			end
			endcase 
		end
	end
	endcase
	
	//
	// Read Data Packet Payload FSM
	//
	case(read_dpp_state)
	READ_DPP_RESET: read_dpp_state <= READ_DPP_IDLE;
	READ_DPP_IDLE: begin
		read_dpp_state <= READ_DPP_0;
		buf_in_wren <= 0;
	end
	READ_DPP_0: begin
		// next cycle, DPP will appear on pipelined in_data
		buf_in_addr <= -1;
		buf_in_wren <= 0;
		in_dpp_length <= 0;
		in_dpp_wasready <= 0;
		buf_in_commit_len <= in_dpp_length_expect;
		crc_dpprx_rst <= 1;
		if({in_data_6, in_datak_6} == {32'h5C5C5CF7, 4'b1111}) begin
			read_dpp_state <= READ_DPP_1;
			in_dpp_wasready <= buf_in_ready;
		end
	end
	READ_DPP_1: begin
		if(in_active) begin
			if(	{in_data_6, in_datak_6} == {32'hFDFDFDF7, 4'b1111}) begin
				// EOP, too early
				read_dpp_state <= READ_DPP_IDLE;
				err_dpp_len_mismatch <= 1;
				
			end else begin
				in_dpp_length <= in_dpp_length + 3'h4;
				`INC(buf_in_addr);
				buf_in_data <= in_data_6;
				crc_dpprx_in <= swap32(in_data_6);
				buf_in_wren <= in_dpp_wasready;
				//if(in_dpp_length == in_dpp_length_expect)
				//	err_dpp_len_mismatch <= 1;
					
				if((in_dpp_length + 3'h4) >= in_dpp_length_expect) begin
					// EOP
					read_dpp_state <= READ_DPP_2;
				end
			end
		end
	end
	READ_DPP_2: begin
		// latch CRC
		in_dpp_crc32 <= swap32(in_data_6);
		read_dpp_state <= READ_DPP_3;
	end
	READ_DPP_3: begin
		// verify CRC
		if(in_dpp_crc32 == crc_dpprx32_out) begin
			// match
			tx_queue_ack <= {1'b0, 1'b1, 5'h1}; // no error, strobe, NumP=0
			`INC(in_dpp_seq);
			buf_in_commit <= 1;
		end else begin
			// fail
			tx_queue_ack <= {1'b1, 1'b1, 5'h1}; // retry, strobe, NumP=0
		end
		read_dpp_state <= READ_DPP_IDLE;
	end
	endcase
	
	
	//
	// Check Header Packet FSM
	//
	case(check_hp_state)
	CHECK_HP_RESET: check_hp_state <= CHECK_HP_IDLE;
	CHECK_HP_IDLE: begin
		// do nothing, triggered by LINK_RECV_FSM	
	end
	CHECK_HP_0: begin
		// check CRC-5, CRC-16 against calculated values
		if(crc_hprx_out == in_header_crc && crc_cw3_out == in_header_cw[15:11]) begin
			// matched
			if(in_header_seq == rx_hdr_seq_num && local_rx_cred_count > 0) begin
				// header seq num matches what we expect
				check_hp_state <= CHECK_HP_1;
			end else begin
				err_hp_seq <= 1;
				check_hp_state <= CHECK_HP_IDLE;
				// transition to Recovery
				ltssm_go_recovery <= 1;
			end
			
		end else begin
			// didn't match
			// issue LBAD and do nothing until either 
			// 1. Recovery entered
			// 2. LRTY received
			tx_lcmd <= LCMD_LBAD;
			tx_lcmd_act <= 1;
			err_hp_crc <= 1;
			`INC(in_header_err_count);
			check_hp_state <= CHECK_HP_IDLE;
			
			if(in_header_err_count >= 2) begin
				// give up, go to Recovery
				// do not transmit LBAD on the third consecutive try
				tx_lcmd_act <= 0;
				ltssm_go_recovery <= 1;
			end
		end
	end
	CHECK_HP_1: begin
		// received properly
		// reset HP error count, decrement local RX cred count
		in_header_err_count <= 0;
		`DEC(local_rx_cred_count);
		`INC(rx_hdr_seq_num);
		// set dirty bit in queue, cause HP to be parsed by next FSM
		in_header_pkt_queued[3-rx_cred_idx] <= 1;
		// send LGOOD
		tx_lcmd <= {LCMD_LGOOD_0[10:3], rx_hdr_seq_num};
		tx_lcmd_act <= 1;
		check_hp_state <= CHECK_HP_IDLE;
	end
	endcase
	
	//
	// Parse Header Packet FSM
	//
	case(rd_hp_state)
	RD_HP_RESET: rd_hp_state <= RD_HP_IDLE;
	RD_HP_IDLE: begin
		case(rx_cred_idx)
		0: begin
			if(in_header_pkt_queued[3]) in_header_pkt_pick <= 3; else
			if(in_header_pkt_queued[2]) in_header_pkt_pick <= 2; else
			if(in_header_pkt_queued[1]) in_header_pkt_pick <= 1; else
			if(in_header_pkt_queued[0]) in_header_pkt_pick <= 0; end
		1: begin
			if(in_header_pkt_queued[2]) in_header_pkt_pick <= 2; else
			if(in_header_pkt_queued[1]) in_header_pkt_pick <= 1; else
			if(in_header_pkt_queued[0]) in_header_pkt_pick <= 0; else
			if(in_header_pkt_queued[3]) in_header_pkt_pick <= 3; end
		2: begin
			if(in_header_pkt_queued[1]) in_header_pkt_pick <= 1; else
			if(in_header_pkt_queued[0]) in_header_pkt_pick <= 0; else
			if(in_header_pkt_queued[3]) in_header_pkt_pick <= 3; else
			if(in_header_pkt_queued[2]) in_header_pkt_pick <= 2; end
		3: begin
			if(in_header_pkt_queued[0]) in_header_pkt_pick <= 0; else
			if(in_header_pkt_queued[3]) in_header_pkt_pick <= 3; else
			if(in_header_pkt_queued[2]) in_header_pkt_pick <= 2; else
			if(in_header_pkt_queued[1]) in_header_pkt_pick <= 1; end
		endcase
		if(|in_header_pkt_queued) rd_hp_state <= RD_HP_0;
	end
	RD_HP_0: begin
		// copy packet to temp reg
		case(in_header_pkt_pick)
		3: in_header_pkt_work <= in_header_pkt_a;
		2: in_header_pkt_work <= in_header_pkt_b;
		1: in_header_pkt_work <= in_header_pkt_c;
		0: in_header_pkt_work <= in_header_pkt_d;
		endcase
		rd_hp_state <= RD_HP_1;
	end
	RD_HP_1: begin
		// decide what type it is
		rd_hp_state <= RD_HP_2;
		case(in_header_pkt_work[4:0])
		LP_TYPE_LMP: rd_hp_state <= RD_HP_LMP_0;
		LP_TYPE_TP: rd_hp_state <= RD_HP_TP_0;
		LP_TYPE_DP: rd_hp_state <= RD_HP_DP_0;
		LP_TYPE_ITP: rd_hp_state <= RD_HP_ITP_0;
		default: err_hp_type <= 1;
		endcase
	end
	RD_HP_2: begin
		// flush buffer, increment credit index and send LCRD
		if(tx_queue_open) begin
			in_header_pkt_queued[in_header_pkt_pick] <= 0;
			tx_queue_lcred[2:0] <= {1'b1, rx_cred_idx};
			`INC(local_rx_cred_count);
			`INC(rx_cred_idx);
			rd_hp_state <= RD_HP_IDLE;
		end
	end	
	RD_HP_LMP_0: begin
		rd_hp_state <= RD_HP_2;
		case(in_header_pkt_work[8:5])
		LP_LMP_SUB_SETLINK: force_linkpm_accept <= in_header_pkt_work[10];
		LP_LMP_SUB_U2INACT: T_PORT_U2_TIMEOUT <= in_header_pkt_work[16:9];
		LP_LMP_SUB_VENDTEST: begin end
		LP_LMP_SUB_PORTCAP: begin end
		LP_LMP_SUB_PORTCFG: send_port_cfg_resp <= 1;
		LP_LMP_SUB_PORTCFGRSP:  begin end
		endcase
	end
	RD_HP_LMP_1: begin	end
	RD_HP_DP_0: begin
		rd_hp_state <= RD_HP_2;
		// parse data packet preamble
		sel_endp 				<= in_header_pkt_work[(11+32):(8+32)];
		in_dpp_length_expect	<= in_header_pkt_work[(31+32):(16+32)];
		in_dpp_setup 			<= in_header_pkt_work[(15+32)];
		in_dpp_seq 				<= in_header_pkt_work[(4+32):(0+32)];
		//in_dpp_expect <= 1;
		read_dpp_state <= READ_DPP_0;
	end
	RD_HP_DP_1: begin	end
	RD_HP_DP_2: begin	end
	RD_HP_TP_0: begin
		case(in_header_pkt_work[35:32])
		LP_TP_SUB_STATUS: begin 
			tx_queue_ack <= {1'b0, 1'b1, 5'h0}; // no error, strobe, NumP=0
		end
		LP_TP_SUB_ACK: begin 
			// decide whether was ACK to prior sent DPP,
			// or requesting payload (IN)
			
			if(in_header_pkt_work[91] && in_header_pkt_work[52:48] > 0) begin
				tx_queue_dpp <= 1;
				out_dpp_seq <= in_header_pkt_work[57:53];
				out_dpp_length <= buf_out_len;
			end
		end
		endcase
		rd_hp_state <= RD_HP_2;
	end
	RD_HP_TP_1: begin
	
	end
	RD_HP_TP_2: begin
	
	end
	RD_HP_TP_3: begin
	
	end
	RD_HP_TP_4: begin
	
	end
	RD_HP_ITP_0: begin
		// latch ITP bus interval count [13:0] and delta [26:14]
		itp_value <= in_header_pkt_work[31:5];
		rd_hp_state <= RD_HP_2;
	end
	endcase
	
	
	//
	// Link Command READ FSM
	//
	case(rd_lcmd_state) 
	RD_LCMD_RESET: rd_lcmd_state <= RD_LCMD_IDLE;
	RD_LCMD_IDLE: begin
		if(in_link_command_act) begin
			// make sure command words match
			if(	in_link_command[10:0] == in_link_command[26:16] &&
				crc_cw1_out == in_link_command[31:27] &&
				crc_cw2_out == in_link_command[15:11] ) begin
				
				rd_lcmd_state <= RD_LCMD_0;
			end
		end
	end
	RD_LCMD_0: begin
		rd_lcmd_state <= RD_LCMD_IDLE;
		rx_lcmd <= in_link_command_1[10:0];
		rx_lcmd_act <= 1;
	end
	endcase
	
	if(rx_lcmd_act) begin
		if(rx_lcmd[10:3] == LCMD_LGOOD_0[10:3] && sent_u0_adv) begin
			// LGOOD, after U0 advertisement is done
			if(ack_tx_hdr_seq_num != rx_lcmd[2:0]) begin
				// out of order
				err_lgood_order <= 1;
				ltssm_go_recovery <= 1;
			end else begin
				`INC(ack_tx_hdr_seq_num);
				pending_hp_timer <= 0;
			end
			
		end else
		if(rx_lcmd[10:2] == LCMD_LCRD_A[10:2] && sent_u0_adv) begin
			// LCRD, after U0 advertisement
			if(remote_rx_cred_count > 3) begin
				// mismatch, remote had too many credits
				err_lcrd_mismatch <= 1;
			end else begin
				`INC(remote_rx_cred_count);
				credit_hp_timer <= 0;
			end
		end else
		if(rx_lcmd[10:2] == LCMD_LGO_U1[10:2]) begin
			// LGO_x
			tx_lcmd <= LCMD_LXU;	// do not accept
			tx_lcmd_act <= 1;
		end else
		if(rx_lcmd[10:2] == LCMD_LRTY[10:2]) begin
			// TODO
			// re-receive header packet
		end
	
	end
	

	
	//
	// Link State Queue FSM
	//
	case(queue_state)
	LINK_QUEUE_RESET: queue_state <= LINK_QUEUE_IDLE;
	LINK_QUEUE_IDLE: begin
		qc <= 0;
		// check for queued advertisement from U0 entry, and wait a bit
		if(queue_send_u0_adv && (dc == 40)) begin
			queue_state <= LINK_QUEUE_HDR_SEQ_AD;
			queue_send_u0_adv <= 0;
		end else
			if(!tx_hp_do) begin
			// send Port Capability HP once advertisement is finished
			if(queue_send_u0_portcap && sent_u0_adv) begin
				queue_state <= LINK_QUEUE_PORTCAP;
				queue_send_u0_portcap <= 0;
			end else
			// send Port Configuration Response HP
			if(send_port_cfg_resp) begin
				queue_state <= LINK_QUEUE_PORTCFGRSP;
				send_port_cfg_resp <= 0;
			end else
			// send ACK TP
			if(|tx_queue_ack ) begin
				queue_state <= LINK_QUEUE_ACK;
			end else
			// send DPH + DPP
			if(tx_queue_dpp) begin
				queue_state <= LINK_QUEUE_DP;
			end
		end
	end
	LINK_QUEUE_HDR_SEQ_AD: begin
		if(tx_lcmd_done) `INC(qc);
		else
		case(qc)
		0: begin
			tx_lcmd <= {LCMD_LGOOD_0[10:3], rx_hdr_seq_num_dec[2:0]};
			tx_lcmd_act <= 1;
		end
		1: begin
			tx_lcmd <= LCMD_LCRD_A;
			tx_lcmd_act <= 1;
			// only advertise up to LOCAL_RX_CRED_COUNT
			if(local_rx_cred_count == 1) qc <= 5; 
		end
		2: begin
			tx_lcmd <= LCMD_LCRD_B;
			tx_lcmd_act <= 1;
			// only advertise up to LOCAL_RX_CRED_COUNT
			if(local_rx_cred_count == 2) qc <= 5;
		end
		3: begin
			tx_lcmd <= LCMD_LCRD_C;
			tx_lcmd_act <= 1;
			// only advertise up to LOCAL_RX_CRED_COUNT
			if(local_rx_cred_count == 3) qc <= 5;
		end
		4: begin
			tx_lcmd <= LCMD_LCRD_D;
			tx_lcmd_act <= 1;
		end
		5: sent_u0_adv <= 1;
		default: queue_state <= LINK_QUEUE_IDLE;
		endcase
	end
	LINK_QUEUE_PORTCAP: begin
		case(qc)
		0: begin
			tx_hp_word_0 <= {16'h0, LP_LMP_SPEED_5GBPS, LP_LMP_SUB_PORTCAP, LP_TYPE_LMP};
			tx_hp_word_1 <= {8'h0, LP_LMP_TIEBREAK, 1'b0, LP_LMP_OTG_INCAPABLE, LP_LMP_DIR_UP, 8'b0, LP_LMP_NUM_HP_4};
			tx_hp_word_2 <= {32'h0};
			tx_hp_act <= 1;
			qc <= 1;
		end
		1: begin
			sent_u0_portcap <= 1;
			queue_state <= LINK_QUEUE_IDLE;
		end		
		endcase
	end
	LINK_QUEUE_PORTCFGRSP: begin
		case(qc)
		0: begin
			tx_hp_word_0 <= {16'h0, LP_LMP_SPEED_ACCEPT, LP_LMP_SUB_PORTCFGRSP, LP_TYPE_LMP};
			tx_hp_word_1 <= {32'h0};
			tx_hp_word_2 <= {32'h0};
			tx_hp_act <= 1;
			qc <= 1;
		end
		1: queue_state <= LINK_QUEUE_IDLE;
		endcase
	end
	LINK_QUEUE_ACK: begin
		case(qc)
		0: begin
			tx_hp_word_0 <= {	local_dev_addr, LP_TP_ROUTE0, LP_TYPE_TP};
			tx_hp_word_1 <= {	6'h0, in_dpp_seq, tx_queue_ack[4:0], 
								1'b0, 3'h0, sel_endp, in_dpp_setup ? 1'b0 : LP_TP_DEVICETOHOST, tx_queue_ack[6], 2'h0, LP_TP_SUB_ACK};
			tx_hp_word_2 <= {	LP_TP_NBI_0, LP_TP_PPEND_NO, LP_TP_DBI_NO, LP_TP_WPA_NO, LP_TP_SSI_NO, 8'h0, 16'h0};
			tx_hp_act <= 1;
			local_dev_addr <= dev_addr;
			qc <= 1;
		end
		1: begin
			tx_queue_ack <= 0;
			queue_state <= LINK_QUEUE_IDLE;
		end
		endcase
	end
	LINK_QUEUE_DP: begin
		case(qc)
		0: begin
			tx_hp_word_0 <= {	local_dev_addr, LP_TP_ROUTE0, LP_TYPE_DP};
			tx_hp_word_1 <= {	out_dpp_length, 1'b0, 3'b0, sel_endp, 1'b0, LP_DP_EOB_LPF_NO, 1'b0, out_dpp_seq};
			tx_hp_word_2 <= {	32'h0};
			tx_hp_act <= 1;
			tx_hp_dph <= 1;
			qc <= 1;
		end
		1: begin
			tx_queue_dpp <= 0;
			queue_state <= LINK_QUEUE_IDLE;
		end
		endcase
	end
	endcase
	
	
	
	///////////////////////////////////////
	// LINK SEND (TX) FSM
	///////////////////////////////////////
	
	case(send_state)
	LINK_SEND_RESET: begin
		send_state <= LINK_SEND_IDLE;
	end
	LINK_SEND_IDLE: begin
		// N.B. potential race condition with loading queued CMD
		// upon exact cycle where queue was closed with another
		// TODO figure out if this ever happens
		tx_queue_open <= 1;
		if(tx_lcmd_do) begin
			tx_lcmd_queue <= 0;
			tx_queue_open <= 0;
			send_state <= LINK_SEND_CMDW_0;
		end else 
		if(|tx_queue_lcred) begin
			tx_queue_lcred <= 0;
			tx_queue_open <= 0;
			tx_lcmd <= {LCMD_LCRD[10:2], tx_queue_lcred[1:0]};
			send_state <= LINK_SEND_CMDW_0;
		end else 
		if(tx_hp_do && remote_rx_cred_count > 0) begin
			tx_queue_open <= 0;
			send_state <= LINK_SEND_HP_0;
		end else
		if(tx_queue_lup) begin
			tx_queue_lup <= 0;
			tx_queue_open <= 0;
			tx_lcmd <= LCMD_LUP;
			send_state <= LINK_SEND_CMDW_0;
		end
	end
	LINK_SEND_CMDW_0: begin
		if(wr_lcmd_state == WR_LCMD_IDLE) begin
			//tx_lcmd_act <= 0;
			tx_lcmd_latch <= tx_lcmd;
			//send_state <= LINK_SEND_CMDW_0;
			wr_lcmd_state <= WR_LCMD_0;
			// reset U0 LUP timeout
			u0l_timeout <= 0;
			send_state <= LINK_SEND_IDLE;
		end
	end
	LINK_SEND_HP_0: begin
		// commit built packet to queue
		case(tx_cred_idx)
		0: out_header_pkt_a <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
		1: out_header_pkt_b <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
		2: out_header_pkt_c <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
		3: out_header_pkt_d <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
		endcase	
		// set to relevant one
		out_header_pkt_pick <= tx_cred_idx;
		
		send_state <= LINK_SEND_HP_1;
	end
	LINK_SEND_HP_1: begin
		if(wr_hp_state == WR_HP_IDLE) begin
			// de-queue HP send request
			tx_hp_queue <= 0;
			wr_hp_state <= WR_HP_0;
			send_state <= LINK_SEND_IDLE;
		end
	end
	endcase	
	
	
	
	//
	// Link Command WRITE FSM
	//
	case(wr_lcmd_state) 
	WR_LCMD_RESET: wr_lcmd_state <= WR_LCMD_IDLE;
	WR_LCMD_IDLE: begin
		// dummy state
	end
	WR_LCMD_0: begin
		{out_data, out_datak} <= {32'hFEFEFEF7, 4'b1111};
		out_active <= 1;
		crc_lcmd_in <= tx_lcmd_latch;
		wr_lcmd_state <= WR_LCMD_1;
	end
	WR_LCMD_1: begin
		{out_data, out_datak} <= {{2{tx_lcmd_latch[7:0], crc_lcmd_out[4:0], tx_lcmd_latch[10:8]}}, 4'b00};
		out_active <= 1;
		wr_lcmd_state <= WR_LCMD_IDLE;
		
		tx_lcmd_done <= 1;
	end
	endcase
	
	
	//
	// Header Packet WRITE FSM
	//
	if(wr_hp_state != WR_HP_IDLE) begin
		// trickery to get around CRC cycle latency
		{out_data, out_data_1} <= {out_data_1, out_data_2} ; 
		{out_datak, out_datak_1} <= {out_datak_1, out_datak_2} ; 
		{out_active, out_active_1} <= {out_active_1, out_active_2} ; 
	end	
	case(wr_hp_state) 
	WR_HP_RESET: wr_hp_state <= WR_HP_IDLE;
	WR_HP_IDLE: begin
		
	end
	WR_HP_0: begin
		crc_hptx_rst <= 1;
		`DEC(remote_rx_cred_count);
		{out_data_2, out_datak_2} <= {32'hFBFBFBF7, 4'b1111};	// HPSTART ordered set
		out_active_2 <= 1;
		sc <= 0;
		wr_hp_state <= WR_HP_1;
	end
	WR_HP_1: begin
		case(sc)
		0: out_data_2 <= swap32(out_header_pkt_mux[95:64]);
		1: out_data_2 <= swap32(out_header_pkt_mux[63:32]);
		2: out_data_2 <= swap32(out_header_pkt_mux[31:0]);
		endcase		
		// TODO set DELAY bit if RETRY
		out_header_cw <= {8'b0, tx_hdr_seq_num};
		out_active_2 <= 1;
		if(sc == 2) wr_hp_state <= WR_HP_2;
	end
	WR_HP_2: begin
		wr_hp_state <= WR_HP_3;
		if(tx_hp_dph) begin
			// fire up DPP writer
			write_dpp_state <= WRITE_DPP_0;
		end
	end
	WR_HP_3: begin
		out_data_1 <= swap32({crc_cw4_out, out_header_cw, crc_hptx_out});
		out_active_1 <= 1;

		wr_hp_state <= WR_HP_4;
	end
	WR_HP_4: begin
		// TODO only increment if this wasn't a RETRY
		`INC(tx_hdr_seq_num);
		if(out_header_first_since_entry) begin
			//remote_rx_cred_count <= remote_rx_cred_count - 1'b1;
			out_header_first_since_entry <= 0;
		end
		if(tx_hp_dph) begin
			wr_hp_state <= WR_HP_5;
		end else begin
			tx_hp_done <= 1;
			wr_hp_state <= WR_HP_IDLE;
		end
	end
	WR_HP_5: begin
		// wait for DPP write to complete
		if(write_dpp_state == WRITE_DPP_IDLE) begin
			tx_hp_done <= 1;
			wr_hp_state <= WR_HP_IDLE;
		end
	end
	endcase
	
	//
	// Write Data Packet Payload FSM
	//
	// this is an abortion, will be dealt with at earliest opportunity
	//
	case(write_dpp_state)
	WRITE_DPP_RESET: write_dpp_state <= WRITE_DPP_IDLE;
	WRITE_DPP_IDLE: begin
		//write_dpp_state <= WRITE_DPP_0;
		buf_out_addr <= 0;
	end
	WRITE_DPP_0: begin
		`INC(buf_out_addr);
		
		write_dpp_state <= WRITE_DPP_1;
	end
	WRITE_DPP_1: begin
		`INC(buf_out_addr);
		
		{out_data_1, out_datak_1} <= {32'h5C5C5CF7, 4'b1111};	// DPP ordered set
		out_active_1 <= 1;
		out_dpp_length_remain <= out_dpp_length;
		out_dpp_length_remain_1 <= out_dpp_length;
		crc_dpptx_rst <= 1;
		
		write_dpp_state <= WRITE_DPP_2;
	end
	WRITE_DPP_2: begin
		case(out_dpp_length_remain_1)
		3: begin
			{out_data, out_datak} <= {out_data_1[31:8], crc_dpptx_out[31:24], 4'b0000};
			write_dpp_state <= WRITE_DPP_6;
		end
		2: begin
			{out_data, out_datak} <= {out_data_1[31:16], crc_dpptx_out[31:16], 4'b0000};
			write_dpp_state <= WRITE_DPP_7;
		end
		1: begin
			{out_data, out_datak} <= {out_data_1[31:24], crc_dpptx_out[31:8], 4'b0000};
			write_dpp_state <= WRITE_DPP_8;
		end
		0: begin
			{out_data, out_datak} <= {out_data_1, 4'b0000};
			write_dpp_state <= WRITE_DPP_5;
		end
		//4: begin
		//	{out_data_1, out_datak_1} <= {buf_out_q, 4'b0000};
		//	if(out_dpp_length == 4)write_dpp_state <= WRITE_DPP_4; else write_dpp_state <= WRITE_DPP_5;
		//end
		
		default: begin
			{out_data_1, out_datak_1} <= {buf_out_q, 4'b0000};
		end
		endcase
		
		if(out_dpp_length_remain_1 == 4 )
		if(out_dpp_length == 4) write_dpp_state <= WRITE_DPP_4; else begin
			{out_data_1, out_datak_1} <= {buf_out_q, 4'b0000};
			write_dpp_state <= WRITE_DPP_9;
		end
		
		// decrement length remaining
		if(out_dpp_length_remain > 4)
			out_dpp_length_remain <= out_dpp_length_remain - 16'h4;
		else
			out_dpp_length_remain <= 0;
		out_dpp_length_remain_1 <= out_dpp_length_remain;
		
		`INC(buf_out_addr);
		crc_dpptx_out_1 <= crc_dpptx_out;
		
		// feed data to CRC
		crc_dpptx_in <= swap32(buf_out_q);
		out_active_1 <= 1;
	end
	WRITE_DPP_3: begin
		// done
		tx_hp_dph <= 0;
		write_dpp_state <= WRITE_DPP_IDLE;
	end
	
	WRITE_DPP_4: begin
		 write_dpp_state <= WRITE_DPP_9;
	end
	WRITE_DPP_5: begin
		{out_data, out_datak, out_active} <= {crc_dpptx_out_1, 4'b0000, 1'b1}; write_dpp_state <= WRITE_DPP_10;
	end
	WRITE_DPP_6: begin
		{out_data, out_datak, out_active} <= {crc_dpptx_out_1[23:0], 8'hFD, 4'b0001, 1'b1}; write_dpp_state <= WRITE_DPP_11;
	end
	WRITE_DPP_7: begin 
		{out_data, out_datak, out_active} <= {crc_dpptx_out_1[15:0], 16'hFDFD, 4'b0011, 1'b1}; write_dpp_state <= WRITE_DPP_12;
	end
	WRITE_DPP_8: begin
		{out_data, out_datak, out_active} <= {crc_dpptx_out_1[7:0], 24'hFDFDFD, 4'b0111, 1'b1}; write_dpp_state <= WRITE_DPP_13;
	end
	
	WRITE_DPP_9: begin
		{out_data, out_datak, out_active} <= {crc_dpptx_out, 4'b0000, 1'b1};
		{out_data_1, out_datak_1, out_active_1} <= {32'hFDFDFDF7, 4'b1111, 1'b1}; write_dpp_state <= WRITE_DPP_3;
	end
	WRITE_DPP_10: begin
		{out_data, out_datak, out_active} <= {32'hFDFDFDF7, 4'b1111, 1'b1}; write_dpp_state <= WRITE_DPP_3;
	end
	WRITE_DPP_11: begin
		{out_data, out_datak, out_active} <= {32'hFDFDF700, 4'b1110, 1'b1}; write_dpp_state <= WRITE_DPP_3;
	end
	WRITE_DPP_12: begin 
		{out_data, out_datak, out_active} <= {32'hFDF70000, 4'b1100, 1'b1}; write_dpp_state <= WRITE_DPP_3;
	end
	WRITE_DPP_13: begin
		{out_data, out_datak, out_active} <= {32'hF7000000, 4'b1000, 1'b1}; write_dpp_state <= WRITE_DPP_3;
	end
	endcase
	
	
	
	
	
	
	if(~reset_n) begin
		send_state <= LINK_SEND_RESET;
		recv_state <= LINK_RECV_RESET;
		expect_state <= LINK_EXPECT_RESET;
		queue_state <= LINK_QUEUE_RESET;
		rd_lcmd_state <= RD_LCMD_RESET;
		rd_hp_state <= RD_HP_RESET;
		wr_lcmd_state <= WR_LCMD_RESET;
		wr_hp_state <= WR_HP_RESET;
		check_hp_state <= CHECK_HP_RESET;
		
		err_lcmd_undefined <= 0;
		err_lcrd_mismatch <= 0;
		err_lgood_order <= 0;
		err_hp_crc <= 0;
		err_hp_seq <= 0;
		err_hp_type <= 0;
		err_dpp_len_mismatch <= 0;
		
		link_error_count <= 0;
		ltssm_go_recovery <= 0;
		queue_send_u0_adv <= 0;
		
		local_dev_addr <= 0;
		sel_endp <= 0;
		tx_hp_dph <= 0;
	end
end




//
// CRC-32 of Data Packet Payloads
//
	wire	[31:0]	crc_dpprx_q;
	reg				crc_dpprx_rst;
	reg		[31:0]	crc_dpprx_in;
	wire	[31:0]	crc_dpprx32_out;
	wire	[31:0]	crc_dpprx24_out;
	wire	[31:0]	crc_dpprx16_out;
	wire	[31:0]	crc_dpprx8_out;
usb3_crc_dpp32 iu3cdprx32 (
	.clk		( local_clk ),
	.rst		( crc_dpprx_rst ),
	.crc_en		( in_active ),
	.di			( crc_dpprx_in ),
	.lfsr_q		( crc_dpprx_q ),
	.crc_out	( crc_dpprx32_out )
);
usb3_crc_dpp24 iu3cdprx24 (
	.di			( crc_dpprx_in[31:8] ),
	.q			( crc_dpprx_q ),
	.crc_out	( crc_dpprx24_out )
);
usb3_crc_dpp16 iu3cdprx16 (
	.di			( crc_dpprx_in[31:16] ),
	.q			( crc_dpprx_q ),
	.crc_out	( crc_dpprx16_out )
);
usb3_crc_dpp8 iu3cdprx8 (
	.di			( crc_dpprx_in[31:24] ),
	.q			( crc_dpprx_q ),
	.crc_out	( crc_dpprx8_out )
);

	wire	[31:0]	crc_dpptx_out = (out_dpp_length_remain_1 == 4) ? (swap32(crc_dpptx32_out)) :
									(out_dpp_length_remain_1 == 3) ? (swap32(crc_dpptx24_out)) :
									(out_dpp_length_remain_1 == 2) ? (swap32(crc_dpptx16_out)) :
									(out_dpp_length_remain_1 == 1) ? (swap32(crc_dpptx8_out)) : (swap32(crc_dpptx32_out));
	reg		[31:0]	crc_dpptx_out_1;
	wire	[31:0]	crc_dpptx_q;
	reg				crc_dpptx_rst;
	reg		[31:0]	crc_dpptx_in;
	wire	[31:0]	crc_dpptx32_out;
	wire	[31:0]	crc_dpptx24_out;
	wire	[31:0]	crc_dpptx16_out;
	wire	[31:0]	crc_dpptx8_out;
usb3_crc_dpp32 iu3cdptx32 (
	.clk		( local_clk ),
	.rst		( crc_dpptx_rst ),
	.crc_en		( 1'b1 ),
	.di			( crc_dpptx_in ),
	.lfsr_q		( crc_dpptx_q ),
	.crc_out	( crc_dpptx32_out )
);
usb3_crc_dpp24 iu3cdptx24 (
	.di			( crc_dpptx_in[23:0] ),
	.q			( crc_dpptx_q ),
	.crc_out	( crc_dpptx24_out )
);
usb3_crc_dpp16 iu3cdptx16 (
	.di			( crc_dpptx_in[15:0] ),
	.q			( crc_dpptx_q ),
	.crc_out	( crc_dpptx16_out )
);
usb3_crc_dpp8 iu3cdptx8 (
	.di			( crc_dpptx_in[7:0] ),
	.q			( crc_dpptx_q ),
	.crc_out	( crc_dpptx8_out )
);


//
// CRC-16 of Header Packet Headers
//
	reg				crc_hprx_rst;
	reg		[31:0]	crc_hprx_in;
	wire	[15:0]	crc_hprx_out;
usb3_crc_hp iu3chprx (
	.clk		( local_clk ),
	.rst		( crc_hprx_rst ),
	.crc_en		( in_active ),
	.di			( crc_hprx_in ),
	.crc_out	( crc_hprx_out )
);

	reg				crc_hptx_rst;
	wire	[31:0]	crc_hptx_in = swap32(out_data_2);
	wire	[15:0]	crc_hptx_out;
usb3_crc_hp iu3chptx (
	.clk		( local_clk ),
	.rst		( crc_hptx_rst ),
	.crc_en		( 1'b1 ),
	.di			( crc_hptx_in ),
	.crc_out	( crc_hptx_out )
);


//
// CRC-5 of Command Words
//

// RX
//
	wire	[10:0]	crc_cw1_in = in_link_command[26:16];
	wire	[4:0]	crc_cw1_out;
usb3_crc_cw iu3ccw1 (
	.di			( crc_cw1_in ),
	.crc_out	( crc_cw1_out )
);

	wire	[10:0]	crc_cw2_in = in_link_command[10:0];
	wire	[4:0]	crc_cw2_out;
usb3_crc_cw iu3ccw2 (
	.di			( crc_cw2_in ),
	.crc_out	( crc_cw2_out )
);

	wire	[10:0]	crc_cw3_in = in_header_cw[10:0];
	wire	[4:0]	crc_cw3_out;
usb3_crc_cw iu3ccw3 (
	.di			( crc_cw3_in ),
	.crc_out	( crc_cw3_out )
);

	wire	[10:0]	crc_cw4_in = out_header_cw[10:0];
	wire	[4:0]	crc_cw4_out;
usb3_crc_cw iu3ccw5 (
	.di			( crc_cw4_in ),
	.crc_out	( crc_cw4_out )
);

// TX
//
	reg		[10:0]	crc_lcmd_in;
	wire	[4:0]	crc_lcmd_out;
usb3_crc_cw iu3ccw4 (
	.di			( crc_lcmd_in ),
	.crc_out	( crc_lcmd_out )
);

endmodule
