
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
input	wire	[3:0]	xfer_endp,
input	wire	[3:0]	xfer_pid,
output	wire			xfer_ready,

input	wire	[8:0]	buf_in_addr,
input	wire	[7:0]	buf_in_data,
input	wire			buf_in_wren,
input	wire	[8:0]	buf_out_addr,
output	wire	[7:0]	buf_out_q,
output	wire	[9:0]	buf_out_len,
	
output	wire	[6:0]	dev_addr,

output	reg				err_missed_ep_ready,

input	wire			dbg_bulk_loop,
output	reg				dbg

);

	reg 			reset_1, reset_2;
	reg				xfer_in_1;
	reg				xfer_in_ok_1;
	reg				xfer_out_1;
	reg				xfer_out_ok_1;
	reg				xfer_endp_last;
	
	assign			xfer_ready			= 	sel_endp == SEL_ENDP0 ? ep0_xfer_ready_latch : 
											sel_endp == SEL_ENDP1 ? ep1_xfer_ready_latch : 
											sel_endp == SEL_ENDP2 ? ep2_xfer_ready_latch : 1'h0;
	// mux outputs
	wire			ep0_xfer_ready;
	reg				ep0_xfer_ready_1;
	reg				ep0_xfer_ready_latch;
	wire			ep0_xfer_in			= 	sel_endp == SEL_ENDP0 ? xfer_in : 1'h0;
	reg				ep0_xfer_in_ok;
	wire			ep0_xfer_out		= 	sel_endp == SEL_ENDP0 ? xfer_out : 1'h0;
	reg				ep0_xfer_out_ok;
	wire	[3:0]	ep0_xfer_pid		= 	sel_endp == SEL_ENDP0 ? xfer_pid : 4'h0;
	
	wire			ep1_xfer_ready;
	reg				ep1_xfer_ready_1;
	reg				ep1_xfer_ready_latch;
	wire			ep1_xfer_out		= 	sel_endp == SEL_ENDP1 ? xfer_out : 1'h0;
	reg				ep1_xfer_out_ok;
	wire	[3:0]	ep1_xfer_pid		= 	sel_endp == SEL_ENDP1 ? xfer_pid : 4'h0;
	
	wire			ep2_xfer_ready;
	reg				ep2_xfer_ready_1;
	reg				ep2_xfer_ready_latch;
	wire			ep2_xfer_in			= 	sel_endp == SEL_ENDP2 ? xfer_in : 1'h0;
	reg				ep2_xfer_in_ok;
	wire	[3:0]	ep2_xfer_pid		= 	sel_endp == SEL_ENDP2 ? xfer_pid : 4'h0;
	
	// mux bram signals
	wire	[5:0]	ep0_buf_in_addr		= 	sel_endp == SEL_ENDP0 ? buf_in_addr[5:0] : 6'h0;
	wire	[7:0]	ep0_buf_in_data		= 	sel_endp == SEL_ENDP0 ? buf_in_data : 8'h0;
	wire			ep0_buf_in_wren		= 	sel_endp == SEL_ENDP0 ? buf_in_wren : 1'h0;
	wire	[7:0]	ep0_buf_out_addr	= 	sel_endp == SEL_ENDP0 ? buf_out_addr[7:0] : 7'h0;
	wire	[7:0]	ep0_buf_out_q;
	wire	[9:0]	ep0_buf_out_len;
	
	wire	[8:0]	ep1_buf_in_addr		= 	dbg_buf_wraddr;
	wire	[7:0]	ep1_buf_in_data		= 	ep2_buf_out_q;
	wire			ep1_buf_in_wren		= 	dbg_buf_wren;
	wire	[8:0]	ep1_buf_out_addr	= 	sel_endp == SEL_ENDP1 ? buf_out_addr : 9'h0;
	wire	[7:0]	ep1_buf_out_q;
	wire	[9:0]	ep1_buf_out_len;
	
	wire	[8:0]	ep2_buf_in_addr		= 	sel_endp == SEL_ENDP2 ? buf_in_addr : 9'h0;
	wire	[7:0]	ep2_buf_in_data		= 	sel_endp == SEL_ENDP2 ? buf_in_data : 8'h0;
	wire			ep2_buf_in_wren		= 	sel_endp == SEL_ENDP2 ? buf_in_wren : 1'h0;
	wire	[8:0]	ep2_buf_out_addr	= 	dbg_buf_rdaddr;
	wire	[7:0]	ep2_buf_out_q;
	wire	[9:0]	ep2_buf_out_len;

	reg		[8:0]	dbg_buf_rdaddr;
	reg		[8:0]	dbg_buf_wraddr;
	reg				dbg_buf_wren;
	
	// NOTE this assumes 512 bytes maximum endpoint buffer addressing	
	assign			buf_out_q			= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_q :
											sel_endp == SEL_ENDP1 ? ep1_buf_out_q : 
											sel_endp == SEL_ENDP2 ? ep2_buf_out_q : 8'h0;
	assign			buf_out_len			= 	sel_endp == SEL_ENDP0 ? ep0_buf_out_len : 
											sel_endp == SEL_ENDP1 ? ep1_buf_out_len : 
											sel_endp == SEL_ENDP2 ? ep2_buf_out_len : 10'h0;
	
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
					ST_XFER_DONE		= 6'd22;

always @(posedge phy_clk) begin

	{reset_2, reset_1} <= {reset_1, reset_n};
	xfer_in_1 <= xfer_in;
	xfer_out_1 <= xfer_out;
	
	ep0_xfer_ready_1 <= ep0_xfer_ready;
	ep1_xfer_ready_1 <= ep1_xfer_ready;
	ep2_xfer_ready_1 <= ep2_xfer_ready;
	if(ep0_xfer_ready & ~ep0_xfer_ready_1) ep0_xfer_ready_latch <= 1;
	if(ep1_xfer_ready & ~ep1_xfer_ready_1) ep1_xfer_ready_latch <= 1;
	if(ep2_xfer_ready & ~ep2_xfer_ready_1) ep2_xfer_ready_latch <= 1;
	else
	// see if the rising edge has triggered when it was already high
	if(ep0_xfer_ready & ~ep0_xfer_ready_1 & ep0_xfer_ready_latch) err_missed_ep_ready <= 1;
	
	dc <= dc + 1'b1;

	dbg_ep1_xfer_in <= 0;
	
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
		end
	end
	ST_XFER_OUT: begin
		if(~xfer_out) begin
			// end of transaction
			state <= ST_XFER_DONE;
		end
	end
	ST_XFER_DONE: begin
		sel_endp <= SEL_FREE;
		state <= ST_IDLE;
		
		// TODO remove once fully debugged
		if(dbg_bulk_loop && sel_endp == SEL_ENDP2) begin
			state <= 30;
		end
	end
	
	30: begin
		dbg_buf_rdaddr <= 0;
		dbg_buf_wraddr <= 0;
		dc <= 0;
		state <= 31;
	end
	
	31: begin
		dbg_buf_wren <= 0;
		if(dc == 2) begin
			dbg_buf_wren <= 1;
		end
		if(dc == 3) begin
			dbg_buf_rdaddr <= dbg_buf_rdaddr + 1'b1;
			dbg_buf_wraddr <= dbg_buf_wraddr + 1'b1;
			
			if(dbg_buf_rdaddr == 511) begin
				dbg_ep1_xfer_in <= 1;
				state <= ST_IDLE;
			end
			
			dc <= 0;
		end
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


reg		dbg_ep1_xfer_in;

usb2_ep1 ipep1 (
	.phy_clk		( phy_clk ),
	.reset_n		( reset_n ),

	.xfer_in		( dbg_ep1_xfer_in ),
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

usb2_ep2 ipep2 (
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

