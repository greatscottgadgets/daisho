
//
// usb 3.0 link level
//
// Copyright (c) 2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb3_link (

input	wire			slow_clk,
input	wire			local_clk,
input	wire			reset_n,


input	wire	[31:0]	in_data,
input	wire	[3:0]	in_datak,
input	wire			in_active,

output	reg		[31:0]	out_data,
output	reg		[3:0]	out_datak,
output	reg				out_active,
output	reg				out_skp_inhibit,
output	reg				out_skp_defer,
input	wire			out_stall,


output	wire			last

);


always @(posedge local_clk) begin

	out_skp_inhibit <= 0;
	out_skp_defer <= 0;
	
	out_data <= 32'h0;
	out_datak <= 4'b0000;
	out_active <= 1'b1;
	
	
end



endmodule
