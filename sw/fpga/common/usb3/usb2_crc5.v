
//
// usb 2.0 crc-5
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb2_crc5 (

input	wire	[4:0]	c,
input	wire	[10:0]	data,
output	wire	[4:0]	next_crc

);

	// reverse input
	wire	[10:0]	d = { 	data[0], data[1], data[2], data[3], data[4], 
							data[5], data[6], data[7], data[8], data[9], 
							data[10] };
							
	wire	[4:0]	q = {
		^d[10:9] ^ ^d[6:5] ^ d[3] ^ d[0] ^ c[0] ^ ^c[4:3],
		d[10] ^ ^d[7:6] ^ d[4] ^ d[1] ^ ^c[1:0] ^ c[4],
		^d[10:7] ^ d[6] ^ ^d[3:2] ^ d[0] ^ ^c[4:0],
		^d[10:7] ^^ d[4:3] ^ d[1] ^ ^c[4:1],
		^d[10:8] ^ ^d[5:4] ^ d[2] ^ ^c[4:2],
	};
	
	assign	next_crc = ~q;

endmodule
