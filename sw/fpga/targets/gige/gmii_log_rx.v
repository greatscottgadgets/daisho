//
// Log GMII packet data to USB bulk IN endpoint.
//
// Copyright (c) 2014 Jared Boone, ShareBrained Technology, Inc.
//
// This file is part of Project Daisho.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street,
// Boston, MA 02110-1301, USA.
//

module gmii_log_rx (
	input		wire				reset,
	input		wire				clock,
	input		wire				available,
	input		wire	[63:0]	meta,
	output	reg				meta_en,
	input		wire	[ 7:0]	data,
	input		wire				data_stop,
	output	reg				data_en,
	output	wire	[ 8:0]	usb_in_addr,
	output	reg	[ 7:0]	usb_in_data,
	output	reg				usb_in_wren,
	input		wire				usb_in_ready,
	output	reg				usb_in_commit,
	output	reg	[ 9:0]	usb_in_commit_len,
	input		wire				usb_in_commit_ack
);

parameter	[2:0]		ST_IDLE			= 'b000,
							ST_META_WAIT	= 'b001,
							ST_META			= 'b010,
							ST_DATA_WAIT	= 'b011,
							ST_DATA			= 'b100,
							ST_COMMIT		= 'b101,
							ST_WAIT			= 'b110
							;

reg		[ 8:0]		address;
reg		[ 8:0]		address_q;
reg		[ 2:0]		state;

assign					usb_in_addr = address_q;

always @(posedge clock) begin
	meta_en <= 0;
	data_en <= 0;
	address <= 0;
	address_q <= address;
	usb_in_wren <= 0;
	usb_in_commit <= 0;
	usb_in_commit_len <= 0;
	
	if( reset ) begin
		state <= ST_IDLE;
	end
	else begin
		case(state)
		ST_IDLE: begin
			if( available & usb_in_ready ) begin
				meta_en <= 1;
				state <= ST_META_WAIT;
			end
		end
		
		ST_META_WAIT: begin
			// Wait for data from FIFO.
			state <= ST_META;
		end
		
		ST_META: begin
			case(address[2:0])
			0: usb_in_data <= meta[63:56];
			1: usb_in_data <= meta[55:48];
			2: usb_in_data <= meta[47:40];
			3: usb_in_data <= meta[39:32];
			4: usb_in_data <= meta[31:24];
			5: usb_in_data <= meta[23:16];
			6: usb_in_data <= meta[15: 8];
			7: usb_in_data <= meta[ 7: 0];
			endcase
			
			address <= address + 1'b1;
			usb_in_wren <= 1;
			if( address == 7 ) begin
				data_en <= 1;
				state <= ST_DATA_WAIT;
			end
		end
		
		ST_DATA_WAIT: begin
			state <= ST_DATA;
			address <= address;
		end
		
		ST_DATA: begin
			data_en <= 1;
			usb_in_data <= data;
			address <= address + 1'b1;
			usb_in_wren <= 1;
			if( data_stop ) begin
				data_en <= 0;
				state <= ST_COMMIT;
			end
		end
		
		ST_COMMIT: begin
			usb_in_commit <= 1;
			usb_in_commit_len <= address;
			address <= address;
			if( usb_in_commit_ack ) begin
				state <= ST_WAIT;
			end
		end
		
		ST_WAIT: begin
			if( usb_in_commit_ack == 0 ) begin
				state <= ST_IDLE;
			end
		end
		
		endcase
	end
end

endmodule
