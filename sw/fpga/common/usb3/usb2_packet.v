
//
// usb 2.0 packet handler
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb2_packet (

// top-level interface
input	wire			phy_clk,
input	wire			reset_n,

// ULPI
input	wire			in_act,
input	wire	[7:0]	in_byte,
input	wire			in_latch,
input	wire			out_cts,
input	wire			out_nxt,
output	wire	[7:0]	out_byte,
output	reg				out_latch,
output	reg				out_stp,

// PROTOCOL
output	reg				xfer_in,
output	reg				xfer_out,
output	reg		[3:0]	xfer_endp,
output	reg		[3:0]	xfer_pid,
input	wire			xfer_ready,

output	reg		[8:0]	buf_in_addr,
output	wire	[7:0]	buf_in_data,
output	wire			buf_in_wren,
output	reg		[8:0]	buf_out_addr,
input	wire	[7:0]	buf_out_q,
input	wire	[9:0]	buf_out_len,

input	wire	[6:0]	dev_addr,

// status
output	reg				err_crc_pid,
output	reg				err_crc_tok,
output	reg				err_crc_pkt,
output	reg				err_pid_out_of_seq,

output	reg		[10:0]	dbg_frame_num,
output	wire	[2:0]	dbg_pkt_type


);

	// edge detection / synch
	reg 			reset_1, reset_2;
	reg				in_act_1;
	reg				out_nxt_1, out_nxt_2;
	
	reg		[3:0]	pkt_pid;

	// pid input
	wire	[3:0]	pid			= in_byte[7:4];
	wire			pid_valid 	= (pid == ~in_byte[3:0]);
	reg		[3:0]	pid_stored;
	reg		[3:0]	pid_last;
	// pid output
	reg		[3:0]	pid_send;
	
	parameter [3:0]	PID_TOKEN_OUT	= 4'hE,
					PID_TOKEN_IN	= 4'h6,
					PID_TOKEN_SOF	= 4'hA,
					PID_TOKEN_SETUP	= 4'h2,
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
					PID_SPEC_PING	= 4'hB,
					PID_SPEC_LPM	= 4'hF;

	reg		[2:0]	pkt_type;
	
	parameter [2:0]	PKT_TYPE_UNDEF	= 3'h0,
					PKT_TYPE_TOKEN	= 3'h1,
					PKT_TYPE_DATA	= 3'h2,
					PKT_TYPE_HAND	= 3'h3,
					PKT_TYPE_SPEC	= 3'h4;
	
	reg		[15:0]	packet_crc;
	

	// usb token data has reversed bitfields. in addition, the data is sent 
	// in reverse bit order, which is reversed per-byte by the PHY.
	reg		[15:0]	packet_token;
	wire	[6:0]	packet_token_addr	= {packet_token[2:0], packet_token[11:8]};
	wire	[3:0]	packet_token_endp	= packet_token[15:12];
	wire	[4:0]	packet_token_crc5 	= packet_token[7:3];
	wire	[10:0]	packet_token_frame	= {packet_token[2:0], packet_token[15:8]};
	
	reg		[10:0]	dc;		// delay counter
	reg		[10:0]	bc;		// byte counter
	
	// TODO flatten
	reg		[15:0]	crc16, crc16_1, crc16_2;
	wire	[15:0]	crc16_fix = ~{crc16_2[8], crc16_2[9], crc16_2[10], crc16_2[11], 
								crc16_2[12], crc16_2[13], crc16_2[14], crc16_2[15],
								crc16_2[0], crc16_2[1], crc16_2[2], crc16_2[3], 
								crc16_2[4], crc16_2[5], crc16_2[6], crc16_2[7]}; 
								
	wire	[15:0]	crc16_fix_out = ~{crc16[8], crc16[9], crc16[10], crc16[11], 
								crc16[12], crc16[13], crc16[14], crc16[15],
								crc16[0], crc16[1], crc16[2], crc16[3], 
								crc16[4], crc16[5], crc16[6], crc16[7]}; 

	assign			buf_in_data = in_byte;
	assign			buf_in_wren = in_latch;
	
	reg				out_byte_buf;
	reg		[7:0]	out_byte_out;
	assign			out_byte	= out_byte_buf ? buf_out_q : out_byte_out;
	reg		[6:0]	assigned_dev_addr;
	
	reg		[5:0]	state /* synthesis preserve */;
	parameter [5:0]	ST_RST_0			= 7'd0,
					ST_RST_1			= 7'd1,
					ST_IDLE				= 7'd10,
					ST_IN_0				= 7'd20,
					ST_IN_1				= 7'd21,
					ST_IN_TOK			= 7'd22,
					ST_PRE_EOP			= 7'd24,
					ST_WAIT_EOP			= 7'd25,
					ST_DATA_CRC			= 7'd26,
					ST_OUT_PRE			= 7'd39,
					ST_OUT_0			= 7'd40,
					ST_OUT_1			= 7'd41,
					ST_OUT_2			= 7'd42,
					ST_OUT_3			= 7'd43;
					
	assign dbg_pkt_type = pkt_type;
	
always @(posedge phy_clk) begin

	in_act_1 <= in_act;
	out_nxt_1 <= out_nxt;
	out_nxt_2 <= out_nxt_1;
	{reset_2, reset_1} <= {reset_1, reset_n};
	
	dc <= dc + 1'b1;
	
	out_stp <= 0;
	
	case(state)
	ST_RST_0: begin
		// reset state
		// NOTE: assigned address from host is lost
		err_crc_pid <= 0;
		err_crc_tok <= 0;
		err_crc_pkt <= 0;
		err_pid_out_of_seq <= 0;
		pid_send <= 0;
		assigned_dev_addr <= 0;
		xfer_in <= 0;
		xfer_out <= 0;
		state <= ST_RST_1;
	end
	ST_RST_1: begin
		// housekeeping goes here
		state <= ST_IDLE;
	end
	
	
	ST_IDLE: begin
		// idle state
		xfer_in <= 0;
		xfer_out <= 0;
		
		if(in_act & ~in_act_1) begin
			// new packet incoming
			
			// TODO verify this 1cycle delay will not pose a problem
			// for handling usb2.0 HIGH SPEED transfers
			
			state <= ST_IN_0;
		end
	end
	
	
	ST_IN_0: begin
		// wait for valid bytes
		if(in_latch) begin
			// check validity of PID
			if(pid_valid) begin
			
				// save it for later
				pid_stored <= pid;
				pid_last <= pid_stored;
				
				case(pid) 
				PID_TOKEN_OUT, 	
				PID_TOKEN_IN, 
				PID_TOKEN_SOF, 
				PID_TOKEN_SETUP: pkt_type <= PKT_TYPE_TOKEN; // expect 16 bits of data
				
				PID_DATA_0,	
				PID_DATA_1, 
				PID_DATA_2,	
				PID_DATA_M:  	pkt_type <= PKT_TYPE_DATA; 	// variable length
				
				PID_HAND_ACK, 
				PID_HAND_NAK, 
				PID_HAND_STALL, 
				PID_HAND_NYET:  pkt_type <= PKT_TYPE_HAND; 	// handshaking, very short
				
				PID_SPEC_PREERR, 
				PID_SPEC_SPLIT, 
				PID_SPEC_PING, 
				PID_SPEC_LPM:  	pkt_type <= PKT_TYPE_SPEC; 	// special cases
				endcase
				
				// reset byte count and latch in packet
				bc <= 0;
				crc16 <= 16'hffff;
				buf_in_addr <= 0;
				state <= ST_IN_1;
			end else begin
				// sit out the rest of the packet, flag error
				//pid_stored <= INVALID
				err_crc_pid <= 1;
				state <= ST_WAIT_EOP;
			end
		end
	end
	
	ST_IN_1: begin
		// read in packet data
		crc16_byte_sel <= 0;
		
		if(pkt_type == PKT_TYPE_DATA) begin
			// check to see if it's for us
			if(packet_token_addr == assigned_dev_addr && 
				(pid_last == PID_TOKEN_OUT || pid_last == PID_TOKEN_SETUP)) begin
				// pass through data to protocol layer
				xfer_in <= 1;
			end
		end
		
		if(in_latch) begin
			bc <= bc + 1'b1;
			buf_in_addr <= buf_in_addr + 1'b1;
			
			// advance CRCs
			crc16 <= next_crc16;
			crc16_1 <= crc16;
			crc16_2 <= crc16_1;
			
			// TODO generalize this case
			// this only handles TOKEN packets
			case(bc)
			0: packet_token[15:8] <= in_byte;
			1: begin 
				packet_token[7:0] <= in_byte;
				crc5_data <= {in_byte[2:0], packet_token[15:8]};
				// finished, process TOKEN 
				if(pkt_type == PKT_TYPE_TOKEN) state <= ST_IN_TOK;
			end
			endcase
			
			// setup packets are 10 bytes long (8 without CRC)
			packet_crc <= {packet_crc[7:0], in_byte};
			if(pid_last == PID_TOKEN_SETUP && bc == 9) begin
				// confirm CRC16
				state <= ST_DATA_CRC;
				// no more data for protocol layer
				xfer_in <= 0;
			end
			
		end
		
		// TODO generalize this case
		// detect EOP
		if(~in_act) begin
			// was it a zero-length OUT?
			if(pid_last == PID_TOKEN_OUT && bc == 2) begin
				// send ack
				pid_send <= PID_HAND_ACK;
				bc <= 0;
				state <= ST_OUT_0;
			end else begin
				state <= ST_IDLE;
			end
		end
	end
	
	ST_IN_TOK: begin
		// default is to wait for EOP
		state <= ST_WAIT_EOP;
		
		case(pid_stored)
		PID_TOKEN_IN: begin
			// switch protocol layer to proper endpoint
			xfer_out <= 1;
			pid_send <= PID_DATA_1;
			// send endpoint OUT buffer
			state <= ST_OUT_PRE;
		end
		PID_TOKEN_OUT: begin
			//
		end
		PID_TOKEN_SOF: begin
			dbg_frame_num <= packet_token_frame;
		end
		PID_TOKEN_SETUP: begin
			//
		end
		endcase
		
		xfer_pid <= pid_stored;
		
		if(pid_stored != PID_TOKEN_SOF)
			xfer_endp <= packet_token_endp;
			
		// confirm token CRC5
		if(packet_token_crc5 != next_crc5) begin
			err_crc_tok <= 1;
			state <= ST_PRE_EOP;
		end
	end
	ST_PRE_EOP: begin
		state <= ST_WAIT_EOP;
	end
	ST_WAIT_EOP: begin
		// detect EOP
		if(~in_act) state <= ST_IDLE;
	end
	
	ST_DATA_CRC: begin
		// check CRC16
		if(packet_crc == crc16_fix) begin
			// good, process etc
			// send ACK
			pid_send <= PID_HAND_ACK;
			bc <= 0;
			state <= ST_OUT_0;
		end else begin
			// invalid CRC, wait for packet to end (it probably did)
			err_crc_pkt <= 1;
			state <= ST_WAIT_EOP;
		end
		
	end
	
	// TODO reduce, check HS use case
	ST_OUT_PRE: begin
		// wait for protocol FSM/endpoint FSM to be ready (usually already is)
		bc <= buf_out_len + 2;
		if(xfer_ready) state <= ST_OUT_0;
	end
	ST_OUT_0: begin
		// send packet through ULPI
		
		// wait for any rx to complete
		crc16_byte_sel <= 1;
		crc16 <= 16'hffff;
		// switch mux from bram to local reg
		out_byte_buf <= 0;
		if(out_cts) state <= ST_OUT_1;
	end
	ST_OUT_1: begin
		// write PID
		out_byte_out <= ~pid_send;
		out_latch <= 1;
		buf_out_addr <= 0;
		state <= ST_OUT_2;
	end
	ST_OUT_2: begin
		out_latch <= 1'b0;
		if(bc > 0) begin
			out_latch <= 1;
			state <= ST_OUT_3;
		end else begin
			if(out_nxt) begin
				out_stp <= 1;
				state <= ST_WAIT_EOP;
			end
		end
	end
	ST_OUT_3: begin
		if(out_nxt) begin
			// phy wants another byte
			if(bc == 0) begin
				out_latch <= 0;
				out_stp <= 1;
				state <= ST_WAIT_EOP;
			end else begin
				// switch mux to bram
				out_byte_buf <= 1;
			end
			
			buf_out_addr <= buf_out_addr + 1'b1;
			bc <= bc - 1'b1;
			
			if(buf_out_addr > 0 && buf_out_addr < buf_out_len ) 
				crc16 <= next_crc16;
			
		end
		if(~out_nxt & out_nxt_1 & out_nxt_2) begin
			// falling edge 
			// bump the bram index back to account for delay
			buf_out_addr <= buf_out_addr - 1'b1;
		end
		
		// last two bytes sent are CRC16
		case(buf_out_len - buf_out_addr + 1)
		0: begin
			out_byte_buf <= 0;
			out_byte_out <= crc16_fix_out[7:0];
		end
		1: begin
			out_byte_buf <= 0;
			out_byte_out <= crc16_fix_out[15:8];
		end
		endcase
	end
	
	endcase
	
	
	if(~reset_2) begin
		// reset
		state <= ST_RST_0;
	end

end


//
// crc5-usb
//
	wire	[4:0]	next_crc5;
	reg		[10:0]	crc5_data;
	
usb2_crc5 ic5 (
	.c			( 5'h1F ),
	.data		( crc5_data ),
	.next_crc	( next_crc5 )
);

//
// crc16-usb
//
	wire	[15:0]	next_crc16;
	reg				crc16_byte_sel;
	wire	[7:0]	crc16_byte	= crc16_byte_sel ? out_byte : in_byte;
	
usb2_crc16 ic16 ( 
	.c			( crc16 ),
	.data		( crc16_byte ),
	.next_crc	( next_crc16 )
);


endmodule
