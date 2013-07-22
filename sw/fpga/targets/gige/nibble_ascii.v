//
// Translate a 4-bit (nibble) value into a hexadecimal ASCII value.
//
// Copyright (c) 2013 Jared Boone, ShareBrained Technology, Inc.
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

module nibble_ascii (
	input	wire	[3:0]	nibble,
	output	reg		[7:0]	ascii
);

always @(nibble) begin
	case(nibble)
		0:	ascii <= 8'h30;
		1:	ascii <= 8'h31;
		2:	ascii <= 8'h32;
		3:	ascii <= 8'h33;
		4:	ascii <= 8'h34;
		5:	ascii <= 8'h35;
		6:	ascii <= 8'h36;
		7:	ascii <= 8'h37;
		8:	ascii <= 8'h38;
		9:	ascii <= 8'h39;
		10:	ascii <= 8'h61;
		11:	ascii <= 8'h62;
		12:	ascii <= 8'h63;
		13:	ascii <= 8'h64;
		14:	ascii <= 8'h65;
		15:	ascii <= 8'h66;
	endcase
end

endmodule
