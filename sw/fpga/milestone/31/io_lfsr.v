
//
// lfsr source/sink for testing
//
// Copyright (c) 2014 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module io_lfsr (

// top-level interface
input	wire			clk,
input	wire			reset_n,

// interface to usb
output	reg		[8:0]	buf_in_addr,
output	reg		[31:0]	buf_in_data,
output	reg				buf_in_wren,
input	wire			buf_in_request,
input	wire			buf_in_ready,
output	reg				buf_in_commit,
output	reg		[10:0]	buf_in_commit_len,
input	wire			buf_in_commit_ack,

output	reg		[8:0]	buf_out_addr,
input	wire	[31:0]	buf_out_q,
input	wire	[10:0]	buf_out_len,
input	wire			buf_out_hasdata,
output	reg				buf_out_arm,
input	wire			buf_out_arm_ack,

input	wire			vend_req_act,
input	wire	[7:0]	vend_req_request,
input	wire	[15:0]	vend_req_val,		

output	reg				compare_good,
output	reg				compare_fail
);

	reg		[5:0]	rx_state;
	reg		[5:0]	tx_state;
	
	parameter [5:0]	ST_RST_0		= 6'd0,
					ST_RST_1		= 6'd1,
					ST_IDLE			= 6'd10,
					ST_RECV_0		= 6'd20,
					ST_RECV_1		= 6'd21,
					ST_RECV_2		= 6'd22,
					ST_RECV_3		= 6'd23,
					ST_RECV_4		= 6'd24,
					ST_RECV_5		= 6'd25,
					ST_SEND_0		= 6'd30,
					ST_SEND_1		= 6'd31,
					ST_SEND_2		= 6'd32,
					ST_SEND_3		= 6'd33,
					ST_SEND_4		= 6'd34,
					ST_SEND_5		= 6'd35;
					
	reg		[31:0]	tx_lfsr;
	reg		[31:0]	rx_lfsr;
	
	wire	[10:0]	buf_out_word_len = buf_out_len / 4; // TODO round up, not down
	reg 			reset_1, reset_2;
	reg				vend_req_act_1, vend_req_act_2;
	reg				buf_in_request_1, buf_in_request_2;
	reg				buf_in_ready_1, buf_in_ready_2;
	reg				buf_in_commit_ack_1, buf_in_commit_ack_2;
	reg				buf_out_hasdata_1, buf_out_hasdata_2;
	reg				buf_out_arm_ack_1, buf_out_arm_ack_2;
	reg		[24:0]	dc;

parameter	[31:0]	lfsr_start	= 32'h38A3D76C;
	wire	[31:0]	tx_lfsr_	= {	tx_lfsr[27], tx_lfsr[ 5], tx_lfsr[ 3], tx_lfsr[17], tx_lfsr[12], tx_lfsr[26], tx_lfsr[22], tx_lfsr[31], 
									tx_lfsr[22], tx_lfsr[ 8], tx_lfsr[ 0], tx_lfsr[11], tx_lfsr[13], tx_lfsr[29], tx_lfsr[23], tx_lfsr[15], 
									tx_lfsr[26], tx_lfsr[ 3], tx_lfsr[ 1], tx_lfsr[29], tx_lfsr[13], tx_lfsr[25], tx_lfsr[21], tx_lfsr[30], 
									tx_lfsr[25], tx_lfsr[ 9], tx_lfsr[ 2], tx_lfsr[15], tx_lfsr[17], tx_lfsr[22], tx_lfsr[ 5], tx_lfsr[21] } ;
									
	wire	[31:0]	rx_lfsr_	= {	rx_lfsr[27], rx_lfsr[ 5], rx_lfsr[ 3], rx_lfsr[17], rx_lfsr[12], rx_lfsr[26], rx_lfsr[22], rx_lfsr[31], 
									rx_lfsr[22], rx_lfsr[ 8], rx_lfsr[ 0], rx_lfsr[11], rx_lfsr[13], rx_lfsr[29], rx_lfsr[23], rx_lfsr[15], 
									rx_lfsr[26], rx_lfsr[ 3], rx_lfsr[ 1], rx_lfsr[29], rx_lfsr[13], rx_lfsr[25], rx_lfsr[21], rx_lfsr[30], 
									rx_lfsr[25], rx_lfsr[ 9], rx_lfsr[ 2], rx_lfsr[15], rx_lfsr[17], rx_lfsr[22], rx_lfsr[ 5], rx_lfsr[21] } ;
	// endian swap (faster here than on PC)
	wire	[31:0]	tx_lfsr_out = {	tx_lfsr_[7:0], tx_lfsr_[15:8], tx_lfsr_[23:16], tx_lfsr_[31:24] } /* synthesis keep */;
	wire	[31:0]	rx_lfsr_out = {	rx_lfsr_[7:0], rx_lfsr_[15:8], rx_lfsr_[23:16], rx_lfsr_[31:24] } /* synthesis keep */;
	
	
always @(posedge clk) begin
	{reset_2, reset_1} <= {reset_1, reset_n};
	{vend_req_act_2, vend_req_act_1} <= {vend_req_act_1, vend_req_act};
	{buf_in_request_2, buf_in_request_1} <= {buf_in_request_1, buf_in_request};
	{buf_in_ready_2, buf_in_ready_1} <= {buf_in_ready_1, buf_in_ready};
	{buf_in_commit_ack_2, buf_in_commit_ack_1} <= {buf_in_commit_ack_1, buf_in_commit_ack};
	{buf_out_hasdata_2, buf_out_hasdata_1} <= {buf_out_hasdata_1, buf_out_hasdata};
	{buf_out_arm_ack_2, buf_out_arm_ack_1} <= {buf_out_arm_ack_1, buf_out_arm_ack};
	
	dc <= dc + 1'b1;

	buf_in_commit <= 0;
	buf_in_wren <= 0;
	buf_out_arm <= 0;
	
	compare_good <= 0;
	compare_fail <= 0;
	
	case(rx_state)
	ST_RST_0: begin
		rx_lfsr <= lfsr_start;
		rx_state <= ST_RST_1;
	end
	ST_RST_1: begin
		rx_state <= ST_IDLE;
	end
	ST_IDLE: begin
		buf_out_addr <= 0;
		
		// incoming data
		if(buf_out_hasdata_2) begin
			rx_state <= ST_RECV_0;
		end
	end
	
	ST_RECV_0: begin
		// 1cycle delay to account for registered BRAM output
		buf_out_addr <= buf_out_addr + 1'b1;
		rx_state <= ST_RECV_1;
	end
	ST_RECV_1: begin
		// 1cycle delay to account for registered BRAM output
		buf_out_addr <= buf_out_addr + 1'b1;
		rx_state <= ST_RECV_2;
		
	end
	ST_RECV_2: begin	
		// increment address except on last cycle
		if(buf_out_addr < buf_out_word_len-1) begin
			buf_out_addr <= buf_out_addr + 1'b1;
			dc <= 0;
		end
		
		if(rx_lfsr_out == buf_out_q)
			compare_good <= 1; 
		else 
			compare_fail <= 1;
		
		// advance lfsr
		rx_lfsr <= {rx_lfsr[4] ^ rx_lfsr[14] ^ rx_lfsr[27] ^ rx_lfsr[7], rx_lfsr[31:1]};
		
		// hack to keep processing after stalled address increment
		if(dc == 2) rx_state <= ST_RECV_3;
	end
	ST_RECV_3: begin
		buf_out_arm <= 1;
		if(buf_out_arm_ack_2) rx_state <= ST_RECV_4;
	end
	ST_RECV_4: begin
		if(~buf_out_arm_ack_2) rx_state <= ST_IDLE;
	end	
	endcase

	
	case(tx_state)
	ST_RST_0: begin
		tx_lfsr <= lfsr_start;
		tx_state <= ST_RST_1;
	end
	ST_RST_1: begin
		tx_state <= ST_IDLE;
	end
	ST_IDLE: begin
		buf_in_addr <= -1;
		
		// host wants data, so send
		if(buf_in_request_2) begin
			if(buf_in_ready_2) tx_state <= ST_SEND_0;
		end
	end
	ST_SEND_0: begin
		buf_in_data <= tx_lfsr_out;
		buf_in_wren <= 1;
		buf_in_commit_len <= 1024;
		buf_in_addr <= buf_in_addr + 1'b1;
		
		if(buf_in_addr == 255) begin
			// commit
			tx_state <= ST_SEND_1;
		end else begin
			// advance lfsr
			tx_lfsr <= {tx_lfsr[4] ^ tx_lfsr[14] ^ tx_lfsr[27] ^ tx_lfsr[7], tx_lfsr[31:1]};
		end
	end
	ST_SEND_1: begin
		buf_in_commit <= 1;
		if(buf_in_commit_ack_2) begin
			tx_state <= ST_SEND_2;
		end
	end
	ST_SEND_2: begin
		if(~buf_in_commit_ack_2) begin
			tx_state <= ST_SEND_3;
		end
	end
	ST_SEND_3: begin
		if(~buf_in_request_2) begin
			tx_state <= ST_IDLE;
		end
	end
	endcase
	
	
	if(~reset_2) begin
		// reset
		rx_state <= 0;
		tx_state <= 0;
	end
end

endmodule
