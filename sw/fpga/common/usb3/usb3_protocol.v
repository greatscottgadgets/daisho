
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

// link interface
input	wire	[3:0]	sel_endp,

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

output	reg				err_undefined

);


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
	
					
always @(posedge local_clk) begin


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
	
	.err_setup_pkt	( err_setup_pkt )
);


endmodule
