
// 
// Copyright (C) 2009 OutputLogic.com
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
// 

module usb3_crc_cw(

input 	wire	[10:0] 	data_in,
output 	wire	[4:0] 	crc_out

);

	// reverse input
	wire	[10:0]	d = { 	data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], 
							data_in[5], data_in[6], data_in[7], data_in[8], data_in[9], 
							data_in[10] };
	wire	[4:0]	c = 5'h1F;						
	wire	[4:0]	q = {
		^d[10:9] ^ ^d[6:5] ^ d[3] ^ d[0] ^ c[0] ^ ^c[4:3],
		d[10] ^ ^d[7:6] ^ d[4] ^ d[1] ^ ^c[1:0] ^ c[4],
		^d[10:7] ^ d[6] ^ ^d[3:2] ^ d[0] ^ ^c[4:0],
		^d[10:7] ^^ d[4:3] ^ d[1] ^ ^c[4:1],
		^d[10:8] ^ ^d[5:4] ^ d[2] ^ ^c[4:2],
	};
	
	assign	crc_out = ~q;
	
endmodule

//
// CRC module for data[95:0] ,   crc[15:0]=1+x^2+x^4+x^12+x^16;
// 

module usb3_crc_hp(

input [95:0] data_in,
input crc_en,
output [15:0] crc_out,
input rst,
input clk

);

reg [15:0] lfsr_q,lfsr_c;

assign crc_out = lfsr_q;

always @(*) begin
    lfsr_c[0] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[0] ^ data_in[4] ^ data_in[8] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[37] ^ data_in[41] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[56] ^ data_in[57] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[62] ^ data_in[64] ^ data_in[65] ^ data_in[66] ^ data_in[67] ^ data_in[68] ^ data_in[69] ^ data_in[73] ^ data_in[75] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[83] ^ data_in[84] ^ data_in[87] ^ data_in[88] ^ data_in[89] ^ data_in[90] ^ data_in[94] ^ data_in[95];
    lfsr_c[1] = lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[34] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[47] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[59] ^ data_in[63] ^ data_in[64] ^ data_in[70] ^ data_in[73] ^ data_in[74] ^ data_in[75] ^ data_in[76] ^ data_in[79] ^ data_in[85] ^ data_in[87] ^ data_in[91] ^ data_in[94];
    lfsr_c[2] = lfsr_q[0] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[15] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[35] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[48] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[60] ^ data_in[64] ^ data_in[65] ^ data_in[71] ^ data_in[74] ^ data_in[75] ^ data_in[76] ^ data_in[77] ^ data_in[80] ^ data_in[86] ^ data_in[88] ^ data_in[92] ^ data_in[95];
    lfsr_c[3] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[34] ^ data_in[35] ^ data_in[36] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[46] ^ data_in[49] ^ data_in[50] ^ data_in[54] ^ data_in[57] ^ data_in[58] ^ data_in[59] ^ data_in[62] ^ data_in[64] ^ data_in[67] ^ data_in[68] ^ data_in[69] ^ data_in[72] ^ data_in[73] ^ data_in[76] ^ data_in[77] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[82] ^ data_in[83] ^ data_in[84] ^ data_in[88] ^ data_in[90] ^ data_in[93] ^ data_in[94] ^ data_in[95];
    lfsr_c[4] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[47] ^ data_in[50] ^ data_in[51] ^ data_in[55] ^ data_in[58] ^ data_in[59] ^ data_in[60] ^ data_in[63] ^ data_in[65] ^ data_in[68] ^ data_in[69] ^ data_in[70] ^ data_in[73] ^ data_in[74] ^ data_in[77] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[89] ^ data_in[91] ^ data_in[94] ^ data_in[95];
    lfsr_c[5] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[15] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[48] ^ data_in[51] ^ data_in[52] ^ data_in[56] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[64] ^ data_in[66] ^ data_in[69] ^ data_in[70] ^ data_in[71] ^ data_in[74] ^ data_in[75] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[90] ^ data_in[92] ^ data_in[95];
    lfsr_c[6] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[13] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[49] ^ data_in[52] ^ data_in[53] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[62] ^ data_in[65] ^ data_in[67] ^ data_in[70] ^ data_in[71] ^ data_in[72] ^ data_in[75] ^ data_in[76] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[83] ^ data_in[85] ^ data_in[86] ^ data_in[87] ^ data_in[91] ^ data_in[93];
    lfsr_c[7] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[14] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[34] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[50] ^ data_in[53] ^ data_in[54] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[63] ^ data_in[66] ^ data_in[68] ^ data_in[71] ^ data_in[72] ^ data_in[73] ^ data_in[76] ^ data_in[77] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[83] ^ data_in[84] ^ data_in[86] ^ data_in[87] ^ data_in[88] ^ data_in[92] ^ data_in[94];
    lfsr_c[8] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[15] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[35] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[51] ^ data_in[54] ^ data_in[55] ^ data_in[59] ^ data_in[62] ^ data_in[63] ^ data_in[64] ^ data_in[67] ^ data_in[69] ^ data_in[72] ^ data_in[73] ^ data_in[74] ^ data_in[77] ^ data_in[78] ^ data_in[81] ^ data_in[82] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[87] ^ data_in[88] ^ data_in[89] ^ data_in[93] ^ data_in[95];
    lfsr_c[9] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[36] ^ data_in[37] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[45] ^ data_in[46] ^ data_in[47] ^ data_in[52] ^ data_in[55] ^ data_in[56] ^ data_in[60] ^ data_in[63] ^ data_in[64] ^ data_in[65] ^ data_in[68] ^ data_in[70] ^ data_in[73] ^ data_in[74] ^ data_in[75] ^ data_in[78] ^ data_in[79] ^ data_in[82] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[88] ^ data_in[89] ^ data_in[90] ^ data_in[94];
    lfsr_c[10] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[37] ^ data_in[38] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^ data_in[48] ^ data_in[53] ^ data_in[56] ^ data_in[57] ^ data_in[61] ^ data_in[64] ^ data_in[65] ^ data_in[66] ^ data_in[69] ^ data_in[71] ^ data_in[74] ^ data_in[75] ^ data_in[76] ^ data_in[79] ^ data_in[80] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[87] ^ data_in[89] ^ data_in[90] ^ data_in[91] ^ data_in[95];
    lfsr_c[11] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[33] ^ data_in[38] ^ data_in[39] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^ data_in[54] ^ data_in[57] ^ data_in[58] ^ data_in[62] ^ data_in[65] ^ data_in[66] ^ data_in[67] ^ data_in[70] ^ data_in[72] ^ data_in[75] ^ data_in[76] ^ data_in[77] ^ data_in[80] ^ data_in[81] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[87] ^ data_in[88] ^ data_in[90] ^ data_in[91] ^ data_in[92];
    lfsr_c[12] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[0] ^ data_in[4] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[33] ^ data_in[37] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[46] ^ data_in[48] ^ data_in[49] ^ data_in[52] ^ data_in[53] ^ data_in[55] ^ data_in[56] ^ data_in[57] ^ data_in[58] ^ data_in[60] ^ data_in[61] ^ data_in[62] ^ data_in[63] ^ data_in[64] ^ data_in[65] ^ data_in[69] ^ data_in[71] ^ data_in[75] ^ data_in[76] ^ data_in[77] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[90] ^ data_in[91] ^ data_in[92] ^ data_in[93] ^ data_in[94] ^ data_in[95];
    lfsr_c[13] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[1] ^ data_in[5] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31] ^ data_in[34] ^ data_in[38] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[47] ^ data_in[49] ^ data_in[50] ^ data_in[53] ^ data_in[54] ^ data_in[56] ^ data_in[57] ^ data_in[58] ^ data_in[59] ^ data_in[61] ^ data_in[62] ^ data_in[63] ^ data_in[64] ^ data_in[65] ^ data_in[66] ^ data_in[70] ^ data_in[72] ^ data_in[76] ^ data_in[77] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[87] ^ data_in[91] ^ data_in[92] ^ data_in[93] ^ data_in[94] ^ data_in[95];
    lfsr_c[14] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[2] ^ data_in[6] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[32] ^ data_in[35] ^ data_in[39] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[54] ^ data_in[55] ^ data_in[57] ^ data_in[58] ^ data_in[59] ^ data_in[60] ^ data_in[62] ^ data_in[63] ^ data_in[64] ^ data_in[65] ^ data_in[66] ^ data_in[67] ^ data_in[71] ^ data_in[73] ^ data_in[77] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[85] ^ data_in[86] ^ data_in[87] ^ data_in[88] ^ data_in[92] ^ data_in[93] ^ data_in[94] ^ data_in[95];
    lfsr_c[15] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[3] ^ data_in[7] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[36] ^ data_in[40] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[55] ^ data_in[56] ^ data_in[58] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[63] ^ data_in[64] ^ data_in[65] ^ data_in[66] ^ data_in[67] ^ data_in[68] ^ data_in[72] ^ data_in[74] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[83] ^ data_in[86] ^ data_in[87] ^ data_in[88] ^ data_in[89] ^ data_in[93] ^ data_in[94] ^ data_in[95];
end // always

always @(posedge clk, posedge rst) begin
	if(rst) begin
		lfsr_q <= {16{1'b1}};
	end
	else begin
		lfsr_q <= crc_en ? lfsr_c : lfsr_q;
	end
end // always
endmodule // crc