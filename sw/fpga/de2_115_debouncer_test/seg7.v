/*
 * Daisho "push button debouncer" for FPGA board.
 * 
 * Copyright (C) 2013 Benjamin Vernoux.
 * 
 * This file is part of the Daisho project.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */ 

/* Basic 7 Segment display (input i_val 4bit to 7bit segment o_dig) */
 
module seg7(o_dig, i_val);

output	[6:0] o_dig;
input	[3:0] i_val;
reg	[6:0] o_dig;

always @(i_val)
begin
	case(i_val)
		4'h0: o_dig = 7'b1000000;
		4'h1: o_dig = 7'b1111001;
		4'h2: o_dig = 7'b0100100;
		4'h3: o_dig = 7'b0110000;
		4'h4: o_dig = 7'b0011001;
		4'h5: o_dig = 7'b0010010;
		4'h6: o_dig = 7'b0000010;
		4'h7: o_dig = 7'b1111000;
		4'h8: o_dig = 7'b0000000;
		4'h9: o_dig = 7'b0011000;
		4'ha: o_dig = 7'b0001000;
		4'hb: o_dig = 7'b0000011;
		4'hc: o_dig = 7'b1000110;
		4'hd: o_dig = 7'b0100001;
		4'he: o_dig = 7'b0000110;
		4'hf: o_dig = 7'b0001110;
	endcase
end

endmodule

