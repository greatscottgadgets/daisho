
//
// usb 3.0 rx descrambling and alignment
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_descramble (

input	wire			clock,
input	wire			local_clk,
input	wire			reset_n,
								
input	wire	[1:0]	raw_valid,
input	wire	[5:0]	raw_status,
input	wire	[1:0]	raw_phy_status,
input	wire	[3:0]	raw_datak,
input	wire	[31:0]	raw_data,

//output	reg		[1:0]	proc_valid,
//output	reg		[5:0]	proc_status,
//output	reg		[1:0]	proc_phy_status,
output	reg		[3:0]	proc_datak,
output	reg		[31:0]	proc_data,
output	reg				proc_active,

output	reg				err_skp_unexpected
);


	reg		[31:0]	sync_a /* synthesis noprune */;
	reg		[3:0]	sync_ak /* synthesis noprune */;
	reg		[31:0]	sync_b /* synthesis noprune */;
	reg		[3:0]	sync_bk /* synthesis noprune */;
	reg		[31:0]	sync_out /* synthesis noprune */;
	reg		[3:0]	sync_outk /* synthesis noprune */;
	reg				sync_out_valid /* synthesis noprune */;
	
	// combinational detection of valid packet framing
	// k-symbols within a received word.
	wire			sync_byte_3 = raw_datak[3] && (	raw_data[31:24] == 8'h5C || raw_data[31:24] == 8'hBC ||
													raw_data[31:24] == 8'hFB || raw_data[31:24] == 8'hFE ||
													raw_data[31:24] == 8'hF7 );
	wire			sync_byte_2 = raw_datak[2] && (	raw_data[23:16] == 8'h5C || raw_data[23:16] == 8'hBC ||
													raw_data[23:16] == 8'hFB || raw_data[23:16] == 8'hFE ||
													raw_data[23:16] == 8'hF7 );
	wire			sync_byte_1 = raw_datak[1] && (	raw_data[15:8] == 8'h5C || raw_data[15:8] == 8'hBC ||
													raw_data[15:8] == 8'hFB || raw_data[15:8] == 8'hFE ||
													raw_data[15:8] == 8'hF7 );
	wire			sync_byte_0 = raw_datak[0] && (	raw_data[7:0] == 8'h5C || raw_data[7:0] == 8'hBC ||
													raw_data[7:0] == 8'hFB || raw_data[7:0] == 8'hFE ||
													raw_data[7:0] == 8'hF7 );
	wire	[3:0]	sync_start 	= {sync_byte_3, sync_byte_2, sync_byte_1, sync_byte_0};
	
	wire			sync_byte_3_end = raw_datak[3] && (	raw_data[31:24] == 8'h7C || raw_data[31:24] == 8'hFD );
	wire			sync_byte_2_end = raw_datak[2] && (	raw_data[23:16] == 8'h7C || raw_data[23:16] == 8'hFD );
	wire			sync_byte_1_end = raw_datak[1] && (	raw_data[15:8] == 8'h7C || raw_data[15:8] == 8'hFD );
	wire			sync_byte_0_end = raw_datak[0] && (	raw_data[7:0] == 8'h7C || raw_data[7:0] == 8'hFD );
	wire	[3:0]	sync_end	= {sync_byte_3_end, sync_byte_2_end, sync_byte_1_end, sync_byte_0_end};
	
	
	// indicates presence of SKP at any symbol position
	wire	[3:0]	skip	= {	(raw_data[31:24] == 8'h3C) & raw_datak[3], (raw_data[23:16] == 8'h3C) & raw_datak[2], 
								(raw_data[15:8] == 8'h3C) & raw_datak[1],  (raw_data[7:0] == 8'h3C) & raw_datak[0] };
	// indicates presence of COM at any symbol position (K28.5)
	wire	[3:0]	comma	= {	(coll_data[31:24] == 8'hBC) & coll_datak[3], (coll_data[23:16] == 8'hBC) & coll_datak[2], 
								(coll_data[15:8] == 8'hBC) & coll_datak[1],  (coll_data[7:0] == 8'hBC) & coll_datak[0] };
	
// step 1.
// collapse incoming stream to remove all SKP symbols.
// these may be sent as 0x3C, 0x3C3C, 0x3C3C3C and so on.
	
	reg		[5:0]	skr_status /* synthesis noprune */;
	reg		[31:0]	skr_data /* synthesis noprune */;
	reg		[3:0]	skr_datak /* synthesis noprune */; 
	reg		[2:0]	skr_num /* synthesis noprune */; 
	reg		[1:0]	skr_valid;

always @(posedge local_clk) begin
	
	case(skip)
	// no SKP symbols to remove
	4'b0000: begin
		skr_data 	<= raw_data;
		skr_datak	<= raw_datak; end
	4'b0001: begin
		skr_data 	<= raw_data[31:8];
		skr_datak	<= raw_datak[3:1]; end
	4'b0010: begin
		skr_data 	<= {raw_data[31:16], raw_data[7:0]};
		skr_datak	<= {raw_datak[3:2], raw_datak[0]}; end
	4'b0011: begin
		skr_data 	<= raw_data[31:16];
		skr_datak	<= raw_datak[3:2]; end
	4'b0100: begin
		skr_data 	<= {raw_data[31:24], raw_data[15:0]};
		skr_datak	<= {raw_datak[3], raw_datak[1:0]}; end
	4'b0110: begin
		skr_data 	<= {raw_data[31:24], raw_data[7:0]};
		skr_datak	<= {raw_datak[3], raw_datak[0]}; end
	4'b0111: begin
		skr_data 	<= raw_data[31:24];
		skr_datak	<= raw_datak[3]; end
	4'b1110: begin
		skr_data 	<= raw_data[7:0];
		skr_datak	<= raw_datak[0]; end
	4'b1100: begin
		skr_data 	<= raw_data[15:0];
		skr_datak	<= raw_datak[1:0]; end
	4'b1000: begin
		skr_data 	<= raw_data[23:0];
		skr_datak	<= raw_datak[2:0]; end
	4'b1111: begin
		skr_data 	<= 0;
		skr_datak	<= 0; end
	default: begin
		{skr_status, skr_data, skr_datak} <= 0;
		err_skp_unexpected <= 1;
	end
	endcase

	// count valid symbols
	skr_num <= 4-(skip[3] + skip[2] + skip[1] + skip[0]);
	skr_status <= raw_status;
	skr_valid <= raw_valid;
	
	if(~reset_n) begin
		err_skp_unexpected <= 0;
	end
end



// step 2.
// accumulate these fragments and then squeeze them out
// 32bits at a time.

	reg		[5:0]	acc_status /* synthesis noprune */;
	reg		[63:0]	acc_data /* synthesis noprune */;
	reg		[7:0]	acc_datak /* synthesis noprune */; 
	
	reg		[2:0]	acc_depth /* synthesis noprune */; 
	
always @(posedge local_clk) begin

	case(skr_num)
	0: begin end
	1: begin
		acc_data  <= {acc_data[55:0], skr_data[7:0]};
		acc_datak <= {acc_datak[6:0], skr_datak[0:0]};
		acc_depth <= acc_depth + 3'd1;
	end
	2: begin
		acc_data  <= {acc_data[47:0], skr_data[15:0]};
		acc_datak <= {acc_datak[5:0], skr_datak[1:0]};
		acc_depth <= acc_depth + 3'd2;
	end
	3: begin
		acc_data  <= {acc_data[39:0], skr_data[23:0]};
		acc_datak <= {acc_datak[4:0], skr_datak[2:0]};
		acc_depth <= acc_depth + 3'd3;
	end
	4: begin
		acc_data  <= {acc_data[31:0], skr_data[31:0]};
		acc_datak <= {acc_datak[3:0], skr_datak[3:0]};
		acc_depth <= acc_depth + 3'd4;
	end
	endcase
	
	coll_valid <= skr_valid;
	coll_active <= (acc_depth > 3);
	case(acc_depth)
	4: begin
		{coll_data, coll_datak} <= {acc_data[31:0], acc_datak[3:0]};
		acc_depth <= 3'd0 + skr_num;
	end
	5: begin
		{coll_data, coll_datak} <= {acc_data[39:8], acc_datak[4:1]};
		acc_depth <= 3'd1 + skr_num;
	end
	6: begin
		{coll_data, coll_datak} <= {acc_data[47:16], acc_datak[5:2]};
		acc_depth <= 3'd2 + skr_num;
	end
	7: begin
		{coll_data, coll_datak} <= {acc_data[55:24], acc_datak[6:3]};
		acc_depth <= 3'd3 + skr_num;
	end
	endcase
	
	if(~reset_n) begin
		acc_depth <= 0;
	end
end


// step 3.
// handle descrambling LFSR, resetting upon COM with
// proper symbol alignment.

	reg		[31:0]	coll_data /* synthesis noprune */;
	reg		[3:0]	coll_datak /* synthesis noprune */;
	reg				coll_active /* synthesis noprune */;
	reg		[1:0]	coll_valid /* synthesis noprune */;
	
	reg		[2:0]	ds_align;
	reg		[2:0]	scr_defer;
	
always @(posedge local_clk) begin

	if(scr_defer < 4) scr_defer <= scr_defer + 1'b1;
	if(|comma) scr_defer <= 0;

	case(comma)
	4'b1111: begin
		ds_align <= 0;
	end
	4'b1110: begin
		ds_align <= 1;
	end
	4'b1100: begin
		ds_align <= 2;
	end
	4'b1000: begin
		ds_align <= 3;
	end
	endcase
	
	if(coll_active) begin
		// only apply descrambling to data, not K-symbols
		proc_data[31:24] <= coll_data[31:24] ^ (coll_datak[3] ? 0 : ds_delay[31:24]);
		proc_data[23:16] <= coll_data[23:16] ^ (coll_datak[2] ? 0 : ds_delay[23:16]);
		proc_data[15:8] <= coll_data[15:8] ^ (coll_datak[1] ? 0 : ds_delay[15:8]);
		proc_data[7:0] <= coll_data[7:0] ^ (coll_datak[0] ? 0 : ds_delay[7:0]);
		proc_datak <= coll_datak;
		
		// match incoming alignment
		case(ds_align)
		0: ds_delay <= {ds_last};
		1: ds_delay <= {ds_last[23:0], ds_out[31:24]};
		2: ds_delay <= {ds_last[15:0], ds_out[31:16]};
		3: ds_delay <= {ds_last[7:0], ds_out[31:8]};
		endcase
		ds_last <= ds_out;
	end
	
	proc_active <= coll_active;
	
	// squelch invalids
	if(~coll_valid) begin
		proc_data <= 32'h0;
		proc_datak <= 4'b0;
		proc_active <= 0;
	end
	
end


//
// data de-scrambling for RX
//
	reg				ds_enable;
	reg		[31:0]	ds_delay;
	reg		[31:0]	ds_last;
	wire	[31:0]	ds_out = 	(|comma | (scr_defer < 1)) ? 0 : 
								{ds_out_swap[7:0], ds_out_swap[15:8], ds_out_swap[23:16], ds_out_swap[31:24]};
	wire	[31:0]	ds_out_swap;
	
usb3_lfsr iu3srx(

	.clock		( local_clk ),
	.reset_n	( reset_n ),
	
	.data_in	( 32'h0 ),
	.scram_en	( coll_active ),
	.scram_rst	( |comma ),
	.data_out	( ds_out_swap )
	
);

endmodule
