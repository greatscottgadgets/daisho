
//
// usb 2.0 protocol layer
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb2_protocol (

// top-level interface
input	wire			phy_clk,
input	wire			reset_n,

// PACKET
input	wire			xfer_in,
input	wire			xfer_in_ok,
input	wire			xfer_out,
input	wire			xfer_out_ok,
input	wire			xfer_query,
input	wire	[3:0]	xfer_endp,
input	wire	[3:0]	xfer_pid,

input	wire	[8:0]	buf_in_addr,
input	wire	[7:0]	buf_in_data,
input	wire			buf_in_wren,
output	wire			buf_in_ready,
input	wire	[8:0]	buf_out_addr,
output	wire	[7:0]	buf_out_q,
output	wire			buf_out_ready,
output	wire	[9:0]	buf_out_len,
	
// EXTERNAL
input	wire	[8:0]	ext_buf_in_addr,
input	wire	[7:0]	ext_buf_in_data,
input	wire			ext_buf_in_wren,
input	wire			ext_buf_in_ready,
input	wire	[8:0]	ext_buf_out_addr,
output	wire	[7:0]	ext_buf_out_q,
input	wire			ext_buf_out_ready,

output	reg				ext_xfer_read,
output	reg				ext_xfer_write,
output	wire	[9:0]	ext_xfer_len,
input	wire			ext_xfer_ready,
input	wire			ext_xfer_done,


output	wire	[6:0]	dev_addr,
output	reg				err_missed_ep_ready,
output	reg				dbg

);

	reg 			reset_1, reset_2;
	reg				xfer_in_1;
	reg				xfer_in_ok_1;
	reg				xfer_out_1;
	reg				xfer_out_ok_1;
	reg				xfer_query_1;
	reg		[3:0]	xfer_endp_last;
	
	// mux outputs
	wire			ep0_xfer_ready;
	reg				ep0_xfer_ready_1;
	reg				ep0_xfer_ready_latch;
	wire			ep0_xfer_in			= 	sel_endp == SEL_ENDP0 ? xfer_in : 1'h0;
	reg				ep0_xfer_in_ok;
	wire			ep0_xfer_out		= 	sel_endp == SEL_ENDP0 ? xfer_out : 1'h0;
	reg				ep0_xfer_out_ok;
	wire	[3:0]	ep0_xfer_pid		= 	sel_endp == SEL_ENDP0 ? xfer_pid : 4'h0;
	
	wire			ep1_xfer_out		= 	sel_endp == SEL_ENDP1 ? xfer_out : 1'h0;
	reg				ep1_xfer_out_ok;
	wire	[3:0]	ep1_xfer_pid		= 	sel_endp == SEL_ENDP1 ? xfer_pid : 4'h0;
	
	wire			ep2_xfer_in			= 	sel_endp == SEL_ENDP2 ? xfer_in : 1'h0;
	reg				ep2_xfer_in_ok;
	wire	[3:0]	ep2_xfer_pid		= 	sel_endp == SEL_ENDP2 ? xfer_pid : 4'h0;
	
	// mux bram signals
	wire	[5:0]	ep0_buf_in_addr		= 	sel_endp == SEL_ENDP0 ? buf_in_addr[5:0] : 6'h0;
	wire	[7:0]	ep0_buf_in_data		= 	sel_endp == SEL_ENDP0 ? buf_in_data : 8'h0;
	wire			ep0_buf_in_wren		= 	sel_endp == SEL_ENDP0 ? buf_in_wren : 1'h0;
	wire			ep0_buf_in_ready;
	wire	[7:0]	ep0_buf_out_addr	= 	sel_endp == SEL_ENDP0 ? buf_out_addr[7:0] : 7'h0;
	wire	[7:0]	ep0_buf_out_q;
	wire			ep0_buf_out_ready;
	wire	[9:0]	ep0_buf_out_len;
	
	wire	[8:0]	ep1_buf_in_addr		= 	ext_buf_in_addr;
	wire	[7:0]	ep1_buf_in_data		= 	ext_buf_in_data;
	wire			ep1_buf_in_wren		= 	ext_buf_in_wren;
	//wire			ep1_buf_in_ready;
	wire	[8:0]	ep1_buf_out_addr	= 	sel_endp == SEL_ENDP1 ? buf_out_addr : 9'h0;
	wire	[7:0]	ep1_buf_out_q;
	//wire			ep1_buf_out_ready;
	wire	[9:0]	ep1_buf_out_len;
	
	wire	[8:0]	ep2_buf_in_addr		= 	sel_endp == SEL_ENDP2 ? buf_in_addr : 9'h0;
	wire	[7:0]	ep2_buf_in_data		= 	sel_endp == SEL_ENDP2 ? buf_in_data : 8'h0;
	wire			ep2_buf_in_wren		= 	sel_endp == SEL_ENDP2 ? buf_in_wren : 1'h0;
	//wire			ep2_buf_in_ready;
	wire	[8:0]	ep2_buf_out_addr	= 	ext_buf_out_addr;
	wire	[7:0]	ep2_buf_out_q;
	//wire			ep2_buf_out_ready;
	wire	[9:0]	ep2_buf_out_len;

	
	// NOTE this assumes 512 bytes maximum endpoint buffer addressing	
	assign			buf_out_q			= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_q :
											sel_endp == SEL_ENDP1 ? ep1_buf_out_q : 
											sel_endp == SEL_ENDP2 ? ep2_buf_out_q : 8'h0;
	assign			buf_out_len			= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_len : 
											sel_endp == SEL_ENDP1 ? 512 : 
											sel_endp == SEL_ENDP2 ? 512 : 10'h0;
	// endpoint 0 is always ready
	// EP1/EP2 are external device
	
	//
	// TODO convert ep0 ready signal to BUF_IN/OUT_READY used by EP1/EP2
	//
	assign			buf_in_ready		= 	sel_endp == SEL_ENDP0 ? 1 : 
											sel_endp == SEL_ENDP1 ? ext_buf_in_ready : 
											sel_endp == SEL_ENDP2 ? ext_buf_in_ready : 1'h0;
	assign			buf_out_ready		= 	sel_endp == SEL_ENDP0 ? ep0_xfer_ready_latch : 
											sel_endp == SEL_ENDP1 ? ext_buf_out_ready : 
											sel_endp == SEL_ENDP2 ? ext_buf_out_ready : 1'h0;
	
	assign			ext_buf_out_q		=	ep2_buf_out_q;
	assign			ext_xfer_len		=	512;
	
	reg		[3:0]	sel_endp;
	parameter [3:0]	SEL_FREE 	= 0,
					SEL_ENDP0 	= 1,
					SEL_ENDP1 	= 2,
					SEL_ENDP2 	= 3,
					SEL_ENDP3 	= 4,
					SEL_ENDP4	= 5;
					
	reg		[5:0]	dc;
	
	reg		[5:0]	state /* synthesis preserve */;
	
	parameter [5:0]	ST_RST_0			= 6'd0,
					ST_RST_1			= 6'd1,
					ST_IDLE				= 6'd10,
					ST_XFER_IN			= 6'd20,
					ST_XFER_OUT			= 6'd21,
					ST_XFER_ENDQUERY	= 6'd22,
					ST_XFER_DONE		= 6'd23;

always @(posedge phy_clk) begin

	{reset_2, reset_1} <= {reset_1, reset_n};
	xfer_in_1 <= xfer_in;
	xfer_out_1 <= xfer_out;
	xfer_query_1 <= xfer_query;
	
	ep0_xfer_ready_1 <= ep0_xfer_ready;
	if(ep0_xfer_ready & ~ep0_xfer_ready_1) ep0_xfer_ready_latch <= 1;
	else
	// see if the rising edge has triggered when it was already high
	if(ep0_xfer_ready & ~ep0_xfer_ready_1 & ep0_xfer_ready_latch) err_missed_ep_ready <= 1;
	
	dc <= dc + 1'b1;

	ext_xfer_read <= 0;
	ext_xfer_write <= 0;
	
	case(state)
	ST_RST_0: begin
		// reset state
		sel_endp <= SEL_FREE;
		
		err_missed_ep_ready <= 0;
		state <= ST_RST_1;
	end
	ST_RST_1: begin
		state <= ST_IDLE;
	end
	
	ST_IDLE: begin
		// idle state
		
		if(xfer_query & ~xfer_query_1) begin
			// PING xfer, pick endpoint
			case(xfer_endp)
			0: 			sel_endp <= SEL_ENDP0;
			1: 			sel_endp <= SEL_ENDP1;
			2: 			sel_endp <= SEL_ENDP2;
			default: 	sel_endp <= SEL_FREE;
			endcase
			xfer_endp_last <= xfer_endp;
			state <= ST_XFER_ENDQUERY;
		end

		if(xfer_in & ~xfer_in_1) begin
			// OUT xfer, pick endpoint
			case(xfer_endp)
			0: 			sel_endp <= SEL_ENDP0;
			1: 			sel_endp <= SEL_ENDP1;
			2: 			sel_endp <= SEL_ENDP2;
			default: 	sel_endp <= SEL_FREE;
			endcase
			xfer_endp_last <= xfer_endp;
			state <= ST_XFER_IN;
		end
		
		if(xfer_out & ~xfer_out_1) begin
			// IN xfer, pick endpoint
			case(xfer_endp)
			0: 			begin
				sel_endp <= SEL_ENDP0;
				ep0_xfer_in_ok <= 0;
				ep0_xfer_out_ok <= 0;
				//ep0_xfer_ready_latch <= 0;
			end
			1: 			begin
				sel_endp <= SEL_ENDP1;
				ep1_xfer_out_ok <= 0;
				//ep1_xfer_ready_latch <= 0;
			end
			2: 			begin
				sel_endp <= SEL_ENDP2;
				ep2_xfer_in_ok <= 0;
				//ep2_xfer_ready_latch <= 0;
			end
			default: 	sel_endp <= SEL_FREE;
			endcase
			xfer_endp_last <= xfer_endp;
			state <= ST_XFER_OUT;
		end
		
		if(xfer_out_ok & ~xfer_out_ok_1) begin
			// tell last endpoint the transfer was successful
			case(xfer_endp_last)
			0: begin
				ep0_xfer_out_ok <= 1;
			end
			1: begin
				ep1_xfer_out_ok <= 1;
			end
			2:begin
				//
			end
			endcase
		end
	end
	ST_XFER_IN: begin
		if(~xfer_in) begin
			// end of transaction
			state <= ST_XFER_DONE;
			// trigger external device write
			if(xfer_endp == 2) ext_xfer_write <= 1;
		end
	end
	ST_XFER_OUT: begin
		// trigger external device write
		
		// ask device to prepare data into endpoint
		if(xfer_endp == 1) ext_xfer_read <= 1;
		if(~xfer_out) begin
			// end of transaction
			state <= ST_XFER_DONE;
		end
	end
	ST_XFER_ENDQUERY: begin
		if(~xfer_query) begin
			// end of transaction
			state <= ST_XFER_DONE;
		end
	end
	ST_XFER_DONE: begin
		sel_endp <= SEL_FREE;
		state <= ST_IDLE;
	end
	
	endcase
	
	if(~reset_2) begin
		// reset
		state <= ST_RST_0;
	end
	
end



////////////////////////////////////////////////////////////
//
// ENDPOINT 0 IN/OUT
//
////////////////////////////////////////////////////////////

usb2_ep0 ipep (
	.phy_clk		( phy_clk ),
	.reset_n		( reset_n ),

	.xfer_in		( ep0_xfer_in ),
	.xfer_out		( ep0_xfer_out ),
	.xfer_pid		( ep0_xfer_pid ),
	.xfer_ready		( ep0_xfer_ready ),
	
	.buf_in_addr	( ep0_buf_in_addr ),
	.buf_in_data	( ep0_buf_in_data ),
	.buf_in_wren	( ep0_buf_in_wren ),
	.buf_out_addr	( ep0_buf_out_addr ),
	.buf_out_q		( ep0_buf_out_q ),
	.buf_out_len	( ep0_buf_out_len ),
	
	.dev_addr		( dev_addr )
);

////////////////////////////////////////////////////////////
//
// ENDPOINT 1 IN
//
////////////////////////////////////////////////////////////


usb2_ep ipep1 (
	.phy_clk		( phy_clk ),
	.reset_n		( reset_n ),

	.xfer_out		( ep1_xfer_out ),
	.xfer_out_ok	( ep1_xfer_out_ok ),
	.xfer_pid		( ep1_xfer_pid ),
	.xfer_ready		( ep1_xfer_ready ),
	
	.buf_in_addr	( ep1_buf_in_addr ),
	.buf_in_data	( ep1_buf_in_data ),
	.buf_in_wren	( ep1_buf_in_wren ),
	.buf_out_addr	( ep1_buf_out_addr ),
	.buf_out_q		( ep1_buf_out_q ),
	.buf_out_len	( ep1_buf_out_len )
);

////////////////////////////////////////////////////////////
//
// ENDPOINT 2 OUT
//
////////////////////////////////////////////////////////////

usb2_ep ipep2 (
	.phy_clk		( phy_clk ),
	.reset_n		( reset_n ),

	.xfer_in		( ep2_xfer_in ),
	.xfer_pid		( ep2_xfer_pid ),
	.xfer_ready		( ep2_xfer_ready ),
	
	.buf_in_addr	( ep2_buf_in_addr ),
	.buf_in_data	( ep2_buf_in_data ),
	.buf_in_wren	( ep2_buf_in_wren ),
	.buf_out_addr	( ep2_buf_out_addr ),
	.buf_out_q		( ep2_buf_out_q ),
	.buf_out_len	( ep2_buf_out_len )
);



endmodule

