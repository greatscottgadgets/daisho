
//
// usb 2.0 endpoint 0 control
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb2_ep0 (

// top-level interface
input	wire			phy_clk,
input	wire			reset_n,

// PROTOCOL
input	wire			xfer_in,
input	wire			xfer_out,
input	wire	[3:0]	xfer_pid,
output	reg				xfer_ready,

input	wire	[5:0]	buf_in_addr,
input	wire	[7:0]	buf_in_data,
input	wire			buf_in_wren,
input	wire	[7:0]	buf_out_addr,
output	wire	[7:0]	buf_out_q,
output	reg		[5:0]	buf_out_len,

input	wire			se0_reset,
output	reg		[6:0]	dev_addr,

output	reg				err_setup_pkt,
output	reg				dbg

);

	reg 			reset_1, reset_2;
	reg				xfer_in_1;
	reg				xfer_out_1;
	
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
	
	reg		[79:0]	packet_setup;
	wire	[7:0]	packet_setup_reqtype = packet_setup[79:72];	
	wire			packet_setup_dir	= packet_setup_reqtype[7];
	parameter		SETUP_DIR_HOSTTODEV	= 1'b0,
					SETUP_DIR_DEVTOHOST	= 1'b1;
	wire	[1:0]	packet_setup_type	= packet_setup_reqtype[6:5];
	parameter [1:0]	SETUP_TYPE_STANDARD	= 2'h0,
					SETUP_TYPE_CLASS	= 2'h1,
					SETUP_TYPE_VENDOR	= 2'h2,
					SETUP_TYPE_RESVD	= 2'h3;
	wire	[4:0]	packet_setup_recpt	= packet_setup_reqtype[4:0];
	parameter [4:0]	SETUP_RECPT_DEVICE	= 5'h0,
					SETUP_RECPT_IFACE	= 5'h1,
					SETUP_RECPT_ENDP	= 5'h2,
					SETUP_RECPT_OTHER	= 5'h3;
	wire	[7:0]	packet_setup_req	= packet_setup[71:64];
	parameter [7:0]	REQ_GET_STATUS		= 8'h0,
					REQ_CLEAR_FEAT		= 8'h1,
					REQ_SET_FEAT		= 8'h3,
					REQ_SET_ADDR		= 8'h5,
					REQ_GET_DESCR		= 8'h6,
					REQ_SET_DESCR		= 8'h7,
					REQ_GET_CONFIG		= 8'h8,
					REQ_SET_CONFIG		= 8'h9,
					REQ_SYNCH_FRAME		= 8'h12;
	wire	[15:0]	packet_setup_wval	= {packet_setup[55:48], packet_setup[63:56]};
	wire	[15:0]	packet_setup_widx	= {packet_setup[39:32], packet_setup[47:40]};
	wire	[15:0]	packet_setup_wlen	= {packet_setup[23:16], packet_setup[31:24]};
	wire	[15:0]	packet_setup_crc16	= packet_setup[15:0];
	
	reg		[5:0]	desired_out_len;
	reg		[15:0]	packet_out_len;
	reg		[3:0]	dev_config;
	
	reg		[3:0]	cnt;
	reg		[6:0]	dc;
	
	reg		[5:0]	state /* synthesis preserve */;
	parameter [5:0]	ST_RST_0			= 6'd0,
					ST_RST_1			= 6'd1,
					ST_IDLE				= 6'd10,
					ST_IN_WAIT			= 6'd20,
					ST_IN_PARSE_0		= 6'd21,
					ST_IN_PARSE_1		= 6'd22,
					ST_REQ_DESCR		= 6'd30,
					ST_RDLEN_0			= 6'd31,
					ST_RDLEN_1			= 6'd32,
					ST_RDLEN_2			= 6'd33,
					ST_REQ_GETCONFIG	= 6'd34,
					ST_REQ_SETCONFIG	= 6'd35,
					ST_REQ_SETADDR		= 6'd36;

					
always @(posedge phy_clk) begin

	// synchronizers
	{reset_2, reset_1} <= {reset_1, reset_n};
	xfer_in_1 <= xfer_in;
	xfer_out_1 <= xfer_out;
	
	dc <= dc + 1'b1;
	
	//if(se0_reset) dev_addr <= 0;
	
	// main fsm
	case(state) 
	ST_RST_0: begin
		xfer_ready <= 0;
		buf_out_len <= 0;
		desired_out_len <= 0;
		dev_addr <= 0;
		dev_config <= 0;
		err_setup_pkt <= 0;
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
			if(xfer_pid == PID_TOKEN_SETUP) begin
				// wait for data latch
				state <= ST_IN_WAIT;
			end
		end
		
		if(xfer_out & ~xfer_out_1) begin
			// reading data from this endpoint's OUT buffer
			//if(xfer_pid == PID_TOKEN_SETUP) begin
				// wait for data latch
			//	state <= 20;
			//end
			xfer_ready <= 1;
		end
	end
	
	ST_IN_WAIT: begin
		// wait for end of transaction
		if(~xfer_in) begin
			// end of setup packet, hopefully it was 8+2crc bytes as expected
			dc <= 0;
			cnt <= 0;
			buf_in_rdaddr <= 0;
			state <= ST_IN_PARSE_0;
		end
	end
	ST_IN_PARSE_0: begin
		// parse setup packet
		buf_in_rdaddr <= buf_in_rdaddr + 1'b1;
		
		packet_setup <= {packet_setup[71:0], buf_in_q[7:0]};
		if(dc == (10+2-1)) state <= ST_IN_PARSE_1;		
	end
	ST_IN_PARSE_1: begin
		// parse setup packet
		packet_out_len <= packet_setup_wlen;
		
		// confirm this is going in the right direction
		//if(packet_setup_dir != SETUP_DIR_DEVTOHOST) begin
		//	err_setup_pkt <= 1;
		//	state <= 10;
		//end else begin
			// proceed with parsing
			
			case(packet_setup_req)
			REQ_GET_DESCR: begin
				state <= ST_REQ_DESCR;
			end
			REQ_GET_CONFIG: begin
				state <= ST_REQ_GETCONFIG;
			end
			REQ_SET_CONFIG: begin
				state <= ST_REQ_SETCONFIG;
			end
			REQ_SET_ADDR: begin
				state <= ST_REQ_SETADDR;
			end
			default: begin
				state <= ST_IDLE;
			end
			endcase
		//end
	end
	
	ST_REQ_DESCR: begin
		
		// GET_DESCRIPTOR
		case(packet_setup_wval)
		16'h0100: begin
			// device descriptor
			descrip_addr_offset <= DESCR_OFF_DEVICE;
		end
		16'h0200: begin
			// config descriptor
			descrip_addr_offset <= DESCR_OFF_CONFIG;
		end
		16'h0300: begin
			// string: languages
			descrip_addr_offset <= DESCR_OFF_STRING0;
		end
		16'h0301: begin
			// string: manufacturer
			descrip_addr_offset <= DESCR_OFF_MFGNAME;
		end
		16'h0302: begin
			// string: product name
			descrip_addr_offset <= DESCR_OFF_PRODNAME;
		end
		16'h0303: begin
			// string: serial number
			descrip_addr_offset <= DESCR_OFF_SERIAL;
		end
		16'h0600: begin
			// device qualifier descriptor
			descrip_addr_offset <= DESCR_OFF_DEVQUAL;
		end
		default: begin
			packet_out_len <= 0;
		end
		endcase
		
		state <= ST_RDLEN_0;
	end
	ST_RDLEN_0: begin
		// wait cycle if descriptor BRAM has a buffered output
		state <= ST_RDLEN_1;
	end
	ST_RDLEN_1: begin
		// pick off the first byte at the pointer
		desired_out_len <= buf_out_q;
		state <= ST_RDLEN_2;
	end
	ST_RDLEN_2: begin
		// pick smaller of the setup packet's wanted length and the stored length
		buf_out_len <= packet_out_len < desired_out_len ? packet_out_len : desired_out_len; 
		// send response (DATA1)
		xfer_ready <= 1;
		state <= ST_IDLE;
	end
	ST_REQ_GETCONFIG: begin
		// GET DEVICE CONFIGURATION
		
		// send response (DATA1)
		buf_out_len <= 1;
		descrip_addr_offset <= dev_config ? RESP_OFF_CONFIGY : RESP_OFF_CONFIGN;
		xfer_ready <= 1;
		state <= ST_IDLE;
	end
	ST_REQ_SETCONFIG: begin
		// SET DEVICE CONFIGURATION
		dev_config <= packet_setup_wval[6:0];
	
		// send response (DATA1)
		buf_out_len <= 0;
		xfer_ready <= 1;
		state <= ST_IDLE;
	end
	ST_REQ_SETADDR: begin
		// SET DEVICE ADDRESS
		dev_addr <= packet_setup_wval[6:0];
	
		// send response (DATA1)
		buf_out_len <= 0;
		xfer_ready <= 1;
		state <= ST_IDLE;
	end
	endcase
	
	if(~reset_2) begin
		// reset
		state <= ST_RST_0;
	end
	
end
	
	
// endpoint IN buffer
// 64 bytes

	reg		[5:0]	buf_in_rdaddr;
	wire	[7:0]	buf_in_q;
	
mf_usb2_ep0in	iu2ep0i (
	.clock 		( phy_clk ),
	.data 		( buf_in_data ),
	.rdaddress 	( buf_in_rdaddr ),
	.wraddress 	( buf_in_addr ),
	.wren 		( buf_in_wren ),
	.q 			( buf_in_q )
);


// endpoint OUT buffer
// segmented
// relevant descriptors (device, interface, endpoint etc)

	parameter [7:0] DESCR_OFF_DEVICE	= 8'd0;
	parameter [7:0] DESCR_OFF_DEVQUAL	= 8'd18;
	parameter [7:0] DESCR_OFF_CONFIG	= 8'd32;
	parameter [7:0] DESCR_OFF_PRODNAME	= 8'd64;
	parameter [7:0] DESCR_OFF_SERIAL	= 8'd106;
	parameter [7:0] DESCR_OFF_STRING0	= 8'd132;
	parameter [7:0] DESCR_OFF_MFGNAME	= 8'd136;
	
	parameter [7:0] RESP_OFF_CONFIGY	= 8'd176;
	parameter [7:0] RESP_OFF_CONFIGN	= 8'd177;
	
	reg		[7:0]	descrip_addr_offset;
	
mf_usb2_descrip	iu2d (
	.clock 		( phy_clk ),
	.address 	( buf_out_addr + descrip_addr_offset),
	.q 			( buf_out_q )
);

	
endmodule
