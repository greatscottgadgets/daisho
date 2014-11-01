//
// I2C bit timing generator
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

module i2c_bit_clock (
	input					clock_i,
	input					reset_i,
	output	[1:0]		phase_o,
	output				phase_inc_o
);

parameter	QUADRATURE_PERIOD	= 'd32;

reg	[15:0]	quadrature_q = 0;
reg	[1:0]		phase_q = 0;
reg				phase_inc_q = 0;

assign	phase_o = phase_q;
assign	phase_inc_o = phase_inc_q;

always @(posedge clock_i) begin
	phase_inc_q <= 0;
	
	if( reset_i ) begin
		quadrature_q <= 0;
		phase_q <= 0;
	end
	else begin
		quadrature_q <= quadrature_q + 1'b1;
		if( quadrature_q == (QUADRATURE_PERIOD - 1) ) begin
			quadrature_q <= 0;
			phase_q <= phase_q + 1'b1;
			phase_inc_q <= 1;
		end
	end
end

endmodule
