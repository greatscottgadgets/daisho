
//
// usb 3.0 protocol layer
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_protocol (

input	wire			slow_clk,
input	wire			local_clk,
input	wire			reset_n,
input	wire	[4:0]	ltssm_state,

// link interface
input	wire			rx_tp,
input	wire			rx_tp_hosterr,
input	wire			rx_tp_retry,
input	wire			rx_tp_pktpend,
input	wire	[3:0]	rx_tp_subtype,
input	wire	[3:0]	rx_tp_endp,
input	wire	[4:0]	rx_tp_nump,
input	wire	[4:0]	rx_tp_seq,
input	wire	[15:0]	rx_tp_stream,

input	wire			rx_dph,
input	wire			rx_dph_eob,
input	wire			rx_dph_setup,
input	wire			rx_dph_pktpend,
input	wire	[3:0]	rx_dph_endp,
input	wire	[4:0]	rx_dph_seq,
input	wire	[15:0]	rx_dph_len,
input	wire			rx_dpp_done,
input	wire			rx_dpp_crcgood,

output	reg				tx_tp_a,
output	reg				tx_tp_a_retry,
output	reg				tx_tp_a_dir,
output	reg		[3:0]	tx_tp_a_subtype,
output	reg		[3:0]	tx_tp_a_endp,
output	reg		[4:0]	tx_tp_a_nump,
output	reg		[4:0]	tx_tp_a_seq,
output	reg		[15:0]	tx_tp_a_stream,

output	reg				tx_tp_b,
output	reg				tx_tp_b_retry,
output	reg				tx_tp_b_dir,
output	reg		[3:0]	tx_tp_b_subtype,
output	reg		[3:0]	tx_tp_b_endp,
output	reg		[4:0]	tx_tp_b_nump,
output	reg		[4:0]	tx_tp_b_seq,
output	reg		[15:0]	tx_tp_b_stream,

output	reg				tx_dph,
output	reg				tx_dph_eob,
output	reg				tx_dph_dir,
output	reg		[3:0]	tx_dph_endp,
output	reg		[4:0]	tx_dph_seq,
output	reg		[15:0]	tx_dph_len,
input	wire			tx_dpp_done,



input	wire	[8:0]	buf_in_addr,
input	wire	[31:0]	buf_in_data,
input	wire			buf_in_wren,
output	wire			buf_in_ready,
input	wire			buf_in_commit,
input	wire	[10:0]	buf_in_commit_len,
output  wire            buf_in_commit_ack,    

input	wire	[8:0]	buf_out_addr,
output  wire    [31:0]	buf_out_q, 
output	wire	[10:0]	buf_out_len,
output	wire			buf_out_hasdata,
input	wire			buf_out_arm,
output	wire			buf_out_arm_ack,
	
// external interface
input	wire	[8:0]	ext_buf_in_addr,
input	wire	[31:0]	ext_buf_in_data,
input	wire			ext_buf_in_wren,
output	wire			ext_buf_in_ready,
input	wire			ext_buf_in_commit,
input	wire	[10:0]	ext_buf_in_commit_len,
output	wire			ext_buf_in_commit_ack,

input	wire	[8:0]	ext_buf_out_addr,
output	wire	[31:0]	ext_buf_out_q,
output	wire	[10:0]	ext_buf_out_len,
output	wire			ext_buf_out_hasdata,
input	wire			ext_buf_out_arm,
output	wire			ext_buf_out_arm_ack,

output	wire	[1:0]	endp_mode,

output	wire			vend_req_act,
output	wire	[7:0]	vend_req_request,
output	wire	[15:0]	vend_req_val,

output	wire	[6:0]	dev_addr,
output	wire			configured,

output	reg				err_miss_rx,
output	reg				err_miss_tx,
output	reg				err_tp_subtype

);

`include "usb3_const.vh"	
	
	// mux bram signals
	wire	[8:0]	ep0_buf_in_addr		= 	sel_endp == SEL_ENDP0 ? buf_in_addr : 'h0;
	wire	[31:0]	ep0_buf_in_data		= 	sel_endp == SEL_ENDP0 ? buf_in_data : 'h0;
	wire			ep0_buf_in_wren		= 	sel_endp == SEL_ENDP0 ? buf_in_wren : 'h0;
	wire			ep0_buf_in_ready;
	wire			ep0_buf_in_commit	= 	sel_endp == SEL_ENDP0 ? buf_in_commit : 'h0;
	wire	[10:0]	ep0_buf_in_commit_len = sel_endp == SEL_ENDP0 ? buf_in_commit_len : 'h0;
	wire			ep0_buf_in_commit_ack;

	wire	[8:0]	ep0_buf_out_addr	= 	sel_endp == SEL_ENDP0 ? buf_out_addr : 'h0;
	wire	[31:0]	ep0_buf_out_q;
	wire	[10:0]	ep0_buf_out_len;
	wire			ep0_buf_out_hasdata;
	wire			ep0_buf_out_arm		= 	sel_endp == SEL_ENDP0 ? buf_out_arm : 'h0;
	wire			ep0_buf_out_arm_ack;
	
	wire	[8:0]	ep1_buf_out_addr	= 	sel_endp == SEL_ENDP1 ? buf_out_addr : 'h0;
	wire	[31:0]	ep1_buf_out_q;
	wire	[10:0]	ep1_buf_out_len;	
	wire			ep1_buf_out_hasdata;
	wire			ep1_buf_out_arm		= 	sel_endp == SEL_ENDP1 ? buf_out_arm : 'h0;
	wire			ep1_buf_out_arm_ack;

	wire	[8:0]	ep2_buf_in_addr		= 	sel_endp == SEL_ENDP2 ? buf_in_addr : 'h0;
	wire	[31:0]	ep2_buf_in_data		= 	sel_endp == SEL_ENDP2 ? buf_in_data : 'h0;
	wire			ep2_buf_in_wren		= 	sel_endp == SEL_ENDP2 ? buf_in_wren : 'h0;
	wire			ep2_buf_in_ready;
	wire			ep2_buf_in_commit 	= 	sel_endp == SEL_ENDP2 ? buf_in_commit : 'h0;
	wire	[10:0]	ep2_buf_in_commit_len = sel_endp == SEL_ENDP2 ? buf_in_commit_len : 'h0;
	wire			ep2_buf_in_commit_ack;

	
	assign			buf_in_ready		= 	sel_endp == SEL_ENDP0 ? ep0_buf_in_ready : 
											sel_endp == SEL_ENDP2 ? ep2_buf_in_ready : 'h0;
											
	assign			buf_in_commit_ack	= 	sel_endp == SEL_ENDP0 ? ep0_buf_in_commit_ack : 
											sel_endp == SEL_ENDP2 ? ep2_buf_in_commit_ack : 'h0;

	assign			buf_out_q			= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_q :
											sel_endp == SEL_ENDP1 ? ep1_buf_out_q : 'h0;
											
	assign			buf_out_len			= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_len : 
											sel_endp == SEL_ENDP1 ? ep1_buf_out_len : 'h0;
											
	assign			buf_out_hasdata		= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_hasdata : 
											sel_endp == SEL_ENDP1 ? ep1_buf_out_hasdata : 'h0;
											
	assign			buf_out_arm_ack		= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_arm_ack : 
											sel_endp == SEL_ENDP1 ? ep1_buf_out_arm_ack : 'h0;
											
	assign			endp_mode			=	sel_endp == SEL_ENDP1 ? EP1_MODE : 
											sel_endp == SEL_ENDP2 ? EP2_MODE : EP_MODE_CONTROL;
											
											
	parameter [3:0]	SEL_ENDP0 			= 4'd0,
					SEL_ENDP1 			= 4'd1,
					SEL_ENDP2 			= 4'd2,
					SEL_ENDP3 			= 4'd3,
					SEL_ENDP4 			= 4'd4,
					SEL_ENDP5 			= 4'd5,
					SEL_ENDP6 			= 4'd6,
					SEL_ENDP7 			= 4'd7;
					
	parameter [1:0]	EP_MODE_CONTROL		= 2'd0,
					EP_MODE_ISOCH		= 2'd1,
					EP_MODE_BULK		= 2'd2,
					EP_MODE_INTERRUPT	= 2'd3;
					
	// assign endpoint modes here and also 
	// in the descriptor strings
	wire	[1:0]	EP1_MODE			= EP_MODE_BULK;
	wire	[1:0]	EP2_MODE			= EP_MODE_BULK;
	
	reg		[4:0]	rx_state;
parameter	[4:0]	RX_RESET		= 'd0,
					RX_IDLE			= 'd1,
					RX_0			= 'd2,
					RX_1			= 'd3,
					RX_2			= 'd4,
					RX_TP_0			= 'd10,
					RX_TP_1			= 'd11,
					RX_TP_2			= 'd12,
					RX_DPH_0		= 'd20,
					RX_DPH_1		= 'd21,
					RX_DPH_2		= 'd22;
					
	reg		[4:0]	tx_state;
parameter	[4:0]	TX_RESET		= 'd0,
					TX_IDLE			= 'd1,
					TX_DP_0			= 'd2,
					TX_DP_1			= 'd3,
					TX_DP_2			= 'd4,
					TX_DP_3			= 'd5;
					
	reg		[4:0]	in_dpp_seq /* synthesis noprune */;
	reg		[4:0]	out_dpp_seq /* synthesis noprune */;
	wire			reset_dp_seq;
	
	reg		[15:0]	out_length;
	reg		[4:0]	out_nump;
	
	reg				do_send_dpp;
	
	reg		[10:0]	dc;
	
	reg		[3:0]	sel_endp;
	
always @(posedge local_clk) begin

	tx_tp_a <= 0;
	tx_tp_b <= 0;
	tx_dph <= 0;
	
	do_send_dpp <= 0;
	
	`INC(dc);
	
	case(rx_state)
	RX_RESET: rx_state <= RX_IDLE;
	RX_IDLE: begin
		if(rx_dph) begin
			// receiving data packet header, link layer is stuffing payload
			// into the endpoint buffer
			//if(rx_dph_endp == 0) 
			in_dpp_seq <= rx_dph_seq;
			sel_endp <= rx_dph_endp;
			rx_state <= RX_DPH_0;
		end else 
		if(rx_tp) begin
			// receving transaction packet, could be ACK or something else
			rx_state <= RX_TP_0;
		end
	
	end
	RX_DPH_0: begin
		if(rx_dpp_done) begin
			if(rx_dpp_crcgood) `INC(in_dpp_seq);
			rx_state <= RX_DPH_1;
		end
	end
	RX_DPH_1: begin
		// send ACK
		tx_tp_a			<= 1'b1;
		tx_tp_a_retry	<= rx_dpp_crcgood ? LP_TP_NORETRY : LP_TP_RETRY;
		tx_tp_a_dir		<= LP_TP_HOSTTODEVICE;
		tx_tp_a_subtype <= LP_TP_SUB_ACK;
		tx_tp_a_endp	<= rx_dph_endp;
		tx_tp_a_nump	<= 5'h1;
		tx_tp_a_seq		<= in_dpp_seq;
		tx_tp_a_stream	<= 16'h0;
		
		rx_state <= RX_IDLE;
	end
	RX_TP_0: begin
		// unless otherwise directed, immediately return
		rx_state <= RX_IDLE;
		
		case(rx_tp_subtype) 
		LP_TP_SUB_ACK: begin
			if(rx_tp_pktpend && rx_tp_nump > 0) begin
				// IN, expecting us to send data
				// switch endpoint mux
				sel_endp <= rx_tp_endp;
				out_nump <= rx_tp_nump;
				out_dpp_seq <= rx_tp_seq;
				
				do_send_dpp <= 1;
			end else begin
				// ACK from a previously sent packet
			end
		end
		LP_TP_SUB_NRDY: begin
		
		end
		LP_TP_SUB_ERDY: begin
		
		end
		LP_TP_SUB_STATUS: begin
			tx_tp_b			<= 1'b1;
			tx_tp_b_retry	<= LP_TP_NORETRY;
			tx_tp_b_dir		<= LP_TP_HOSTTODEVICE;
			tx_tp_b_subtype <= LP_TP_SUB_ACK;
			tx_tp_b_endp	<= rx_tp_endp;
			tx_tp_b_nump	<= 5'h0;
			tx_tp_b_seq		<= in_dpp_seq;
			tx_tp_b_stream	<= 16'h0;
			
		end
		LP_TP_SUB_PING: begin
		
		end
		default: begin
			// invalid subtype
			err_tp_subtype <= 1;
		end
		endcase
	end
	
	RX_0: begin
	
	end
	RX_1: begin
	
	end
	endcase
	
	case(tx_state) 
	TX_RESET: tx_state <= TX_IDLE;
	TX_IDLE: begin
		if(do_send_dpp) begin
			// note: overall transfer length
			out_length <= buf_out_len;
			tx_state <= TX_DP_0;
		end
	end
	TX_DP_0: begin
		tx_dph			<= 1'b1;
		tx_dph_eob		<= 0; // TODO
		tx_dph_dir		<= rx_tp_endp == 0 ? 0 : LP_TP_DEVICETOHOST;
		tx_dph_endp		<= sel_endp;
		tx_dph_seq		<= out_dpp_seq;
		tx_dph_len		<= out_length; // TODO

		dc <= 0;
		tx_state <= TX_DP_1;
	end
	TX_DP_1: begin
		// check done flag after 5 cycles
		if(dc == 4) begin
			if(tx_dpp_done) tx_state <= TX_IDLE;
			dc <= 4;
		end
		
	end
	endcase
	
	
	
	if(rx_state != RX_IDLE) begin
		// missed an incoming transaction!
		if(rx_dph || rx_tp) err_miss_rx <= 1;
	end
	if(tx_state != TX_IDLE) begin
		if(do_send_dpp) err_miss_tx <= 1;
	end
	
	
	if(~reset_n || ltssm_state != LT_U0) begin
		rx_state <= RX_RESET;
		tx_state <= TX_RESET;
	end

	if(~reset_n) begin
		err_miss_rx <= 0;
		err_miss_tx <= 0;
		err_tp_subtype <= 0;
	end
end

////////////////////////////////////////////////////////////
//
// ENDPOINT 0 IN/OUT
//
////////////////////////////////////////////////////////////

usb3_ep0 iu3ep0 (
	.slow_clk			( slow_clk ),
	.local_clk			( local_clk ),
	.reset_n			( reset_n ),

	.buf_in_addr		( ep0_buf_in_addr ),
	.buf_in_data		( ep0_buf_in_data ),
	.buf_in_wren		( ep0_buf_in_wren ),
	.buf_in_ready		( ep0_buf_in_ready ),
	.buf_in_commit		( ep0_buf_in_commit ),
	.buf_in_commit_len 	( ep0_buf_in_commit_len ),
	.buf_in_commit_ack 	( ep0_buf_in_commit_ack ),
	
	.buf_out_addr		( ep0_buf_out_addr ),
	.buf_out_q			( ep0_buf_out_q ),
	.buf_out_len		( ep0_buf_out_len ),
	.buf_out_hasdata	( ep0_buf_out_hasdata ),
	.buf_out_arm		( ep0_buf_out_arm ),
	.buf_out_arm_ack	( ep0_buf_out_arm_ack ),
	
	.vend_req_act		( vend_req_act ),
	.vend_req_request	( vend_req_request ),
	.vend_req_val		( vend_req_val ),

	.dev_addr		( dev_addr ),
	.configured		( configured ),
	.reset_dp_seq	( reset_dp_seq )
	
	//.err_setup_pkt	( err_setup_pkt )
);


endmodule
