
//
// usb 3.0 tx scrambling and elastic buffer padding
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_scramble (

input	wire			clock,
input	wire			local_clk,
input	wire			reset_n,

input	wire			enable,

input	wire			skp_inhibit,
input	wire			skp_defer,

input	wire	[3:0]	raw_datak,
input	wire	[31:0]	raw_data,
input	wire			raw_active,
output	reg				raw_stall,

output	reg		[3:0]	proc_datak,
output	reg		[31:0]	proc_data,

output	reg				err_undef
);
	
	// indicates presence of COM at last symbol position (K28.5)
	wire			comma	= {	(raw_data[7:0] == 8'hBC) & raw_datak[0] };
	
// step 1.
// apply scrambling to incoming data.
// data is XORd with free running LFSR that is reset whenever 
// we send out any 0xBC (COM) K-symbol.
	
	reg		[31:0]	sc_data;
	reg		[3:0]	sc_datak; 
	reg		[2:0]	sc_num; 

always @(posedge local_clk) begin
	
	sc_data[31:24] <= raw_datak[3] ? raw_data[31:24] : raw_data[31:24] ^ ds_out[31:24];
	sc_data[23:16] <= raw_datak[2] ? raw_data[23:16] : raw_data[23:16] ^ ds_out[23:16];
	sc_data[15:8] <= raw_datak[1] ? raw_data[15:8] : raw_data[15:8] ^ ds_out[15:8];
	sc_data[7:0] <= raw_datak[0] ? raw_data[7:0] : raw_data[7:0] ^ ds_out[7:0];
	
	sc_datak <= raw_datak;
	
	if(~reset_n) begin
		//err_skp_unexpected <= 0;
	end
end

always @(posedge local_clk) begin

	proc_datak <= sc_datak;
	proc_data  <= sc_data;
end



	reg		[2:0]	scr_defer;

//
// data scrambling for TX
//
	reg		[31:0]	ds_delay;
	reg		[31:0]	ds_last;
	//wire			ds_suppress = |comma | (scr_defer < 1);
	wire			ds_enable = enable ;
	wire	[31:0]	ds_out = ds_enable ? 
							{ds_out_swap[7:0], ds_out_swap[15:8], 
							ds_out_swap[23:16], ds_out_swap[31:24]} : 0;
	wire	[31:0]	ds_out_swap;
	
usb3_lfsr iu3srx(

	.clock		( local_clk ),
	.reset_n	( reset_n ),
	
	.data_in	( 32'h0 ),
	.scram_en	( 1 ), // TODO WHEN INPUT IS NOT ACTIVE
	.scram_rst	( comma ),
	.scram_init ( 16'h4DE8 ),
	.data_out	( ds_out_swap )
	
);

endmodule
