
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

output	wire	[8:0]	buf_in_addr,
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
	// these are not valid for SOF 
	reg		[15:0]	packet_token;
	wire	[6:0]	packet_token_addr	= packet_token[14:8] /* synthesis keep */;
	wire	[3:0]	packet_token_endp	= {packet_token[2:0], packet_token[15]} /* synthesis keep */;
	wire	[4:0]	packet_token_crc5 	= packet_token[7:3];
	wire	[10:0]	packet_token_frame	= {packet_token[2:0], packet_token[15:8]};
	
	reg		[10:0]	dc;		// delay counter
	reg		[10:0]	bc;		// byte counter
	
	reg		[6:0]	local_dev_addr;
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

	// two byte delay for incoming data
	//
	assign			buf_in_addr = buf_in_addr_0;
	assign			buf_in_data = buf_in_data_0;
	assign			buf_in_wren = buf_in_wren_0;
	
	reg		[8:0]	buf_in_addr_2, buf_in_addr_1, buf_in_addr_0;
	reg		[7:0]	buf_in_data_1, buf_in_data_0;
	reg				buf_in_wren_1, buf_in_wren_0;

	reg				out_byte_buf;
	reg		[7:0]	out_byte_out;
	reg		[1:0]	out_byte_crc;
	wire	[7:0]	out_crc_mux = 	out_byte_crc[0] ? crc16_fix_out[15:8] : crc16_fix_out[7:0];
	assign			out_byte	= 	out_byte_crc[1] ? out_crc_mux :
									out_byte_buf ? buf_out_q : out_byte_out;
	
	reg		[5:0]	state /* synthesis preserve */;
	parameter [5:0]	ST_RST_0			= 6'd0,
					ST_RST_1			= 6'd1,
					ST_IDLE				= 6'd10,
					ST_IN_1				= 6'd21,
					ST_IN_TOK			= 6'd22,
					ST_PRE_EOP			= 6'd24,
					ST_WAIT_EOP			= 6'd25,
					ST_DATA_CRC			= 6'd26,
					ST_OUT_PRE			= 6'd39,
					ST_OUT_0			= 6'd40,
					ST_OUT_1			= 6'd41,
					ST_OUT_2			= 6'd42,
					ST_OUT_3			= 6'd43;
					
	assign dbg_pkt_type = pkt_type;
	
always @(posedge phy_clk) begin

	in_act_1 <= in_act;
	out_nxt_1 <= out_nxt;
	out_nxt_2 <= out_nxt_1;
	{reset_2, reset_1} <= {reset_1, reset_n};
	
	if(in_latch) begin
		// delay incoming data by 2 bytes
		// we don't know incoming packet size, only that the last two bytes are CRC
		{buf_in_addr_1, buf_in_addr_0} <= {buf_in_addr_2, buf_in_addr_1};
		{buf_in_data_1, buf_in_data_0} <= {in_byte, buf_in_data_1};
		{buf_in_wren_1, buf_in_wren_0} <= {in_latch && (state == ST_IN_1) && (bc < 512), buf_in_wren_1};
	end
	
	dc <= dc + 1'b1;
	
	out_stp <= 0;
	
	case(state)
	ST_RST_0: begin
		// reset state
		// NOTE: assigned address from host is lost
		bc <= 0;
		err_crc_pid <= 0;
		err_crc_tok <= 0;
		err_crc_pkt <= 0;
		err_pid_out_of_seq <= 0;
		pid_send <= 0;
		pid_stored <= 0;
		pid_last <= 0;
		local_dev_addr <= 0;
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
		//xfer_in <= 0;
		xfer_out <= 0;
		
		if(in_act) begin

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
					buf_in_addr_2 <= 0;
					state <= ST_IN_1;
				end else begin
					// sit out the rest of the packet, flag error
					err_crc_pid <= 1;
					state <= ST_WAIT_EOP;
				end
			end
		end
	end
	
	ST_IN_1: begin
		// read in packet data
		crc16_byte_sel <= 0;
		
		if(in_latch) begin
			bc <= bc + 1'b1;
			buf_in_addr_2 <= buf_in_addr_2 + 1'b1;
			
			// advance CRCs
			crc16 <= next_crc16;
			crc16_1 <= crc16;
			crc16_2 <= crc16_1;
			
			// this only handles TOKEN packets
			if(pkt_type == PKT_TYPE_TOKEN) begin
				case(bc)
				0: packet_token[15:8] <= in_byte;
				1: begin 
					packet_token[7:0] <= in_byte;
					crc5_data <= {in_byte[2:0], packet_token[15:8]};
					// finished, process TOKEN 
					state <= ST_IN_TOK;
				end
				endcase
			end
			
			// setup packets are 10 bytes long (8 without CRC)
			packet_crc <= {packet_crc[7:0], in_byte};
		end
		
		// detect EOP
		if(~in_act) begin
			// default is to IDLE
			state <= ST_IDLE;
			
			if(packet_token_addr == local_dev_addr) begin
				// was it a zero-length OUT?
				if(pid_last == PID_TOKEN_OUT && bc == 2) begin
					pid_send <= PID_HAND_ACK;
					bc <= 0;
					state <= ST_OUT_0;
					xfer_in <= 0;

				end else if(pid_last == PID_TOKEN_OUT || pid_last == PID_TOKEN_SETUP) begin
					state <= ST_DATA_CRC;
					xfer_in <= 0;
				end
			end
		end
	end
	
	ST_IN_TOK: begin
		// default is to wait for EOP
		state <= ST_WAIT_EOP;
		
		case(pid_stored)
		PID_TOKEN_SOF: begin
			dbg_frame_num <= packet_token_frame;
		end
		endcase
		
		// only parse tokens at our address
		if(packet_token_addr == local_dev_addr) begin
			case(pid_stored)
			PID_TOKEN_IN: begin
				// switch protocol layer to proper endpoint
				xfer_out <= 1;
				pid_send <= PID_DATA_1;
				local_dev_addr <= dev_addr;
				// send endpoint OUT buffer
				state <= ST_OUT_PRE;
			end
			PID_TOKEN_OUT: begin
				//
				xfer_in <= 1;
			end
			PID_TOKEN_SETUP: begin
				//
				xfer_in <= 1;
			end
			endcase
			
			xfer_pid <= pid_stored;
			
			if(pid_stored != PID_TOKEN_SOF)
				xfer_endp <= packet_token_endp;
		end
		
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
		out_latch <= 0;
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
		
		if(xfer_ready) begin
			bc <= buf_out_len + 2;
			state <= ST_OUT_0;
		end
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
		out_byte_out <= {4'h4, ~pid_send};
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
				//out_latch <= 0;
				out_stp <= 1;
				state <= ST_WAIT_EOP;
				out_byte_crc <= 2'b00;
			end else begin
				// switch mux to bram
				out_byte_buf <= 1;
			end
			
			buf_out_addr <= buf_out_addr + 1'b1;
			bc <= bc - 1'b1;
			
			if(buf_out_addr > 0 && bc > 1)
				crc16 <= next_crc16;
				
			if(bc == 2) out_byte_crc <= 2'b11;
			if(bc == 1) out_byte_crc <= 2'b10;
			
		end
		if(~out_nxt & out_nxt_1 ) begin 
			// falling edge 
			// keep this byte
			out_byte_out <= buf_out_q;
			out_byte_buf <= 0;
		end
		
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
