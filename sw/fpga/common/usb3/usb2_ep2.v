
//
// usb 2.0 endpoint 2 OUT
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb2_ep2 (

// top-level interface
input	wire			phy_clk,
input	wire			reset_n,

// PROTOCOL
input	wire			xfer_in,
input	wire			xfer_out,
input	wire	[3:0]	xfer_pid,
output	reg				xfer_ready,

input	wire	[8:0]	buf_in_addr,
input	wire	[7:0]	buf_in_data,
input	wire			buf_in_wren,

input	wire	[8:0]	buf_out_addr,
output	wire	[7:0]	buf_out_q,
output	reg		[9:0]	buf_out_len,

output	wire			dbg

);

	reg 			reset_1, reset_2;
	reg				xfer_in_1;
	reg				xfer_out_1;
	
	parameter [3:0]	PID_TOKEN_OUT	= 4'hE,
					PID_TOKEN_IN	= 4'h6,
					PID_TOKEN_SOF	= 4'hA,
					PID_TOKEN_SETUP	= 4'h2,
					PID_TOKEN_PING	= 4'hB,
					PID_DATA_0		= 4'hC,
					PID_DATA_1		= 4'h4,
					PID_DATA_2		= 4'h8,
					PID_DATA_M		= 4'h0,
					PID_HAND_ACK	= 4'hD,
					PID_HAND_NAK	= 4'h5,
					PID_HAND_STALL	= 4'h1,
					PID_HAND_NYET	= 4'h9,
					PID_SPEC_PREERR	= 4'h3,
					PID_SPEC_SPLIT	= 4'h7,
					PID_SPEC_LPM	= 4'hF;
	
	reg		[8:0]	desired_out_len;
	reg		[15:0]	packet_out_len;

	reg		[6:0]	dc;
	
	reg		[5:0]	state /* synthesis preserve */;
	parameter [5:0]	ST_RST_0			= 6'd0,
					ST_RST_1			= 6'd1,
					ST_IDLE				= 6'd10,
					ST_IN_WAIT			= 6'd20,
					ST_IN_PARSE_0		= 6'd21,
					ST_IN_PARSE_1		= 6'd22;

					
always @(posedge phy_clk) begin

	// synchronizers
	{reset_2, reset_1} <= {reset_1, reset_n};
	xfer_in_1 <= xfer_in;
	xfer_out_1 <= xfer_out;
	
	dc <= dc + 1'b1;
		
	// main fsm
	case(state) 
	ST_RST_0: begin
		xfer_ready <= 0;
		buf_out_len <= 0;
		desired_out_len <= 0;
		state <= ST_RST_1;
	end
	ST_RST_1: begin
		state <= ST_IDLE;
	end
	
	ST_IDLE: begin
		// idle state
		
		if(xfer_in & ~xfer_in_1) begin
			// data is coming to this endpoint!
			xfer_ready <= 0;
			state <= ST_IN_WAIT;
		end
		
		if(xfer_out & ~xfer_out_1) begin
			// reading data from this endpoint's IN buffer
			xfer_ready <= 1;
		end
	end
	
	ST_IN_WAIT: begin
		// wait for end of transaction
		if(~xfer_in) begin
			dc <= 0;
			state <= ST_IN_PARSE_0;
		end
	end
	
	endcase
	
	if(~reset_2) begin
		// reset
		state <= ST_RST_0;
	end
	
end
	

// endpoint OUT buffer

mf_usb2_ep2out	mf_usb2_ep2out_inst (
	.clock 		( phy_clk ),
	.data 		( buf_in_data ),
	.rdaddress 	( buf_out_addr ),
	.wraddress 	( buf_in_addr ),
	.wren 		( buf_in_wren ),
	.q 			( buf_out_q )
);

	
endmodule
