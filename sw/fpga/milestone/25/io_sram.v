
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
input	wire			buf_in_ready,
output	reg				buf_in_commit,
output	reg		[9:0]	buf_in_commit_len,
input	wire			buf_in_commit_ack,

output	reg		[8:0]	buf_out_addr,
input	wire	[7:0]	buf_out_q,
input	wire	[9:0]	buf_out_len,
input	wire			buf_out_hasdata,
output	reg				buf_out_arm,
input	wire			buf_out_arm_ack,

input	wire			vend_req_act,
input	wire	[7:0]	vend_req_request,
input	wire	[15:0]	vend_req_val		

);

	reg		[5:0]	state;
	parameter [5:0]	ST_RST_0		= 6'd0,
					ST_RST_1		= 6'd1,
					ST_IDLE			= 6'd10;
					
	reg				sram_dq_oe;
	reg		[15:0]	sram_dq_out;
	assign			sram_dq = sram_dq_oe ? sram_dq_out : 16'bZ;
	
	assign			sram_addr = loc_addr;
	
	reg		[19:0]	loc_addr;
	reg		[10:0]	loc_count;
	
	reg 			reset_1, reset_2;
	reg				vend_req_act_1, vend_req_act_2;
	reg				buf_in_ready_1, buf_in_ready_2;
	reg				buf_out_hasdata_1, buf_out_hasdata_2;
	reg				buf_out_arm_ack_1, buf_out_arm_ack_2;
	reg		[10:0]	dc;

	
always @(posedge clk) begin
	{reset_2, reset_1} <= {reset_1, reset_n};
	{vend_req_act_2, vend_req_act_1} <= {vend_req_act_1, vend_req_act};
	{buf_in_ready_2, buf_in_ready_1} <= {buf_in_ready_1, buf_in_ready};
	{buf_out_hasdata_2, buf_out_hasdata_1} <= {buf_out_hasdata_1, buf_out_hasdata};
	{buf_out_arm_ack_2, buf_out_arm_ack_1} <= {buf_out_arm_ack_1, buf_out_arm_ack};
	
	dc <= dc + 1'b1;
	
	buf_in_commit <= 0;
	buf_out_arm <= 0;
	
	case(state)
	ST_RST_0: begin
		sram_dq_oe <= 0;
		sram_ce_n <= 0;
		sram_oe_n <= 1;
		sram_we_n <= 1;
		sram_ub_n <= 0;
		sram_lb_n <= 0;
		loc_addr <= 0;

		state <= ST_RST_1;
	end
	ST_RST_1: begin
		state <= ST_IDLE;
	end
	

	ST_IDLE: begin
		if(vend_req_act_1 & ~vend_req_act_2) begin
			// vendor request!
			loc_addr <= vend_req_val * 256; 
			loc_count <= 0;
				
			// wants to read from SRAM
			if(vend_req_request == 8'h01) begin
				state <= 20;
			end
			
			// set SRAM write address
			if(vend_req_request == 8'h02) begin
				state <= 29;
			end
		end
	end
	
	20: begin
		sram_dq_oe <= 0;
		sram_oe_n <= 0;
		sram_we_n <= 1;
		
		if(buf_in_ready_2) state <= 21;
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
		
		if(loc_count == (512/2)-1) begin
			state <= ST_IDLE;
			sram_oe_n <= 1;
			buf_in_commit <= 1;
			buf_in_commit_len <= 512;
			dc <= 0;
		end
	end
	
	29: begin
		if(buf_out_hasdata_2) begin
			state <= 30;
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
		
		if(loc_count == (512/2)-1) begin
			state <= 36;
			buf_out_arm <= 1;
			dc <= 0;
		end
	end
	36: begin
		if(buf_out_arm_ack_2) begin
			state <= 37;
			dc <= 0;
		end
	end
	37: begin
		if(~buf_out_arm_ack_2 && dc == 7) begin
			state <= ST_IDLE;
		end
	end
	endcase

	
	if(~reset_2) begin
		// reset
		state <= 0;
	end
end

endmodule
