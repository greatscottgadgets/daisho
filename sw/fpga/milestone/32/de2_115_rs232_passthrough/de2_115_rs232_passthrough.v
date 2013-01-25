/*
 * Daisho milestone 32 demonstration project on Terasic DE2-115 FPGA board and
 * HSMC communication board.
 * 
 * Copyright (C) 2013 Jared Boone, ShareBrained Technology, Inc.
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

module de2_115_rs232_passthrough(
	// Clocks
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	SMA_CLKIN,
	SMA_CLKOUT,
	
	// RS232/UART
	UART_RXD,
	UART_TXD,
	UART_RTS,
	UART_CTS,
	
	// PS2
	PS2_DAT,
	PS2_CLK,
	PS2_DAT2,
	PS2_CLK2,
	
	// LCD
	LCD_ON,
	LCD_BLON,
	LCD_EN,
	LCD_RW,
	LCD_RS,
	LCD_DATA,
	
	// LEDs
	LEDR,
	LEDG,
	
	// Hex LEDs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	
	// Keys
	KEY,
	
	// Switches
	SW,
	
	// HSMC communication board
	HSMC_0_RXD,
	HSMC_0_TXD,
	RS485_0_RTS,
	
	HSMC_1_RXD,
	HSMC_1_TXD,
	RS485_1_RTS
);

input HSMC_0_RXD;
output HSMC_0_TXD;
input RS485_0_RTS;

input HSMC_1_RXD;
output HSMC_1_TXD = 1'b1;
input RS485_1_RTS;

input CLOCK_50;
input CLOCK2_50;
input CLOCK3_50;
input SMA_CLKIN;
output SMA_CLKOUT = 1'b0;

input UART_RXD;
output UART_TXD; // = 1'b1;
input UART_RTS;
output UART_CTS = 1'b1;

inout PS2_DAT;
inout PS2_CLK;
inout PS2_DAT2;
inout PS2_CLK2;

output LCD_ON = 1'b0;
output LCD_BLON = 1'b0;
output LCD_EN = 1'b0;
output LCD_RW = 1'b0;
output LCD_RS = 1'b0;
inout [7:0] LCD_DATA;

output [17:0] LEDR; // = 18'b101010101010101010;
output [8:0] LEDG; // = 9'b101010101;

output [6:0] HEX0 = 7'b1111111;
output [6:0] HEX1 = 7'b1111111;
output [6:0] HEX2 = 7'b1111111;
output [6:0] HEX3 = 7'b1111111;
output [6:0] HEX4 = 7'b1111111;
output [6:0] HEX5 = 7'b1111111;
output [6:0] HEX6 = 7'b1111111;
output [6:0] HEX7 = 7'b1111111;

input [3:0] KEY;
input [17:0] SW;

reg [31:0] clock_divider;

always@(posedge CLOCK_50)
begin
	clock_divider <= clock_divider + 1;
end

assign LEDR = clock_divider[31:14];
assign LEDG = { 5'b00000, ~UART_RXD, ~HSMC_0_TXD, ~UART_TXD, ~HSMC_0_RXD };

assign HSMC_0_TXD = UART_RXD;
assign UART_TXD = HSMC_0_RXD;
//assign UART_CTS = RS485_0_RTS;

endmodule
