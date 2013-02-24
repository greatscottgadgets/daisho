
//
// sram dma interface
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module io_sram (

// top-level interface
input	wire			clk,
input	wire			reset_n,

output	wire	[19:0]	sram_addr,
inout	wire	[15:0]	sram_dq,
output	reg				sram_ce_n,
output	reg				sram_oe_n,
output	reg				sram_we_n,
output	reg				sram_ub_n,
output	reg				sram_lb_n,

output	reg		[8:0]	buf_in_addr,
output	reg		[7:0]	buf_in_data,
output	reg				buf_in_wren,
output	reg				buf_in_ready,
output	reg		[8:0]	buf_out_addr,
input	wire	[7:0]	buf_out_q,
output	reg				buf_out_ready,

input	wire			xfer_read,
input	wire			xfer_write,
input	wire	[9:0]	xfer_len,
output	reg				xfer_done,

output	wire			dbg

);

	reg		[6:0]	state /* synthesis preserve */;
	
	reg				sram_dq_oe;
	reg		[15:0]	sram_dq_out;
	assign			sram_dq = sram_dq_oe ? sram_dq_out : 16'bZ;
	
	assign			sram_addr = loc_addr;
	
	reg		[19:0]	loc_addr;
	reg		[10:0]	loc_count;
	
	reg 			reset_1, reset_2;
	reg		[10:0]	dc;
	reg				xfer_read_1, xfer_read_2;
	reg				xfer_write_1, xfer_write_2;
	
	
always @(posedge clk) begin
	{reset_2, reset_1} <= {reset_1, reset_n};
	{xfer_read_2, xfer_read_1} <= {xfer_read_1, xfer_read};
	{xfer_write_2, xfer_write_1} <= {xfer_write_1, xfer_write};
	
	dc <= dc + 1'b1;
	
	case(state)
	0: begin
		sram_dq_oe <= 0;
		sram_ce_n <= 0;
		sram_oe_n <= 1;
		sram_we_n <= 1;
		sram_ub_n <= 0;
		sram_lb_n <= 0;
		loc_addr <= 0;
		xfer_done <= 0;
		buf_in_ready <= 1;
		buf_out_ready <= 0;
		state <= 1;
	end
	1: begin
		state <= 10;
	end
	
	// please note this code is not that great... it's made to work
	// in a short amount of time, the interface with the usb controller
	// is likely going to change soon
	
	10: begin
		
		if(dc == 2047)begin
			buf_in_ready <= 0;
			buf_out_ready <= 0;
		end
		if(xfer_read_1 & ~xfer_read_2) begin
			xfer_done <= 0;
			buf_out_ready <= 0;
			loc_addr <= 0; 
			loc_count <= 0;
			state <= 20;
		end
		
		if(xfer_write_1 & ~xfer_write_2) begin
			xfer_done <= 0;
			buf_in_ready <= 0;
			loc_addr <= 0;
			loc_count <= 0;
			state <= 30;
		end
		
	end
	
	20: begin
		sram_dq_oe <= 0;
		sram_oe_n <= 0;
		sram_we_n <= 1;
		
		state  <= 21;
	end
	21: begin
		sram_dq_out <= sram_dq;
		buf_in_data <= sram_dq[15:8];
		state <= 22;
	end
	22: begin
		buf_in_wren <= 1;
		state <= 23;
	end
	23: begin
		buf_in_wren <= 0;
		state  <= 27;
	end
	27: begin
		buf_in_data <= sram_dq[7:0];
		buf_in_addr <= buf_in_addr + 1'b1;
		state <= 24;
	end
	24: begin
		buf_in_wren <= 1;
		state <= 25;
	end
	25: begin	
		buf_in_wren <= 0;
		buf_in_addr <= buf_in_addr + 1'b1;
		loc_addr <= loc_addr + 1'b1;
		loc_count <= loc_count + 1'b1;
		state <= 20;
		
		if(loc_count == (xfer_len/2)-1) begin
			state <= 10;
			sram_oe_n <= 1;
			buf_out_ready <= 1;
			xfer_done <= 1;
			dc <= 0;
		end
	end
	
	30: begin
		// write from endpoint buffer to SRAM
		sram_dq_out[15:8] <= buf_out_q;
		buf_out_addr <= buf_out_addr + 1'b1;
		state <= 31;
	end
	31: begin
		// delay
		state <= 32;
	end
	32: begin
		sram_dq_out[7:0] <= buf_out_q;
		buf_out_addr <= buf_out_addr + 1'b1;
		
		dc <= 0;
		state <= 33;
	end
	33: begin
		// setup time
		sram_dq_oe <= 1;
		state <= 34;
	end
	34: begin
		sram_oe_n <= 1;
		sram_we_n <= 0;
		state <= 35;
	end
	35: begin
		sram_we_n <= 1;
		loc_addr <= loc_addr + 1'b1;
		loc_count <= loc_count + 1'b1;
		state <= 30;
		
		if(loc_count == (xfer_len/2)-1) begin
			sram_oe_n <= 0;
			state <= 10;
			buf_in_ready <= 1;
			xfer_done <= 1;
			dc <= 0;
		end
	end
	
	endcase

	
	if(~reset_2) begin
		// reset
		state <= 0;
	end
end

endmodule
