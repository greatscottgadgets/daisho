/*
 * Daisho milestone 32 demonstration project on Terasic DE2-115 FPGA board with
 * HSMC communication board or Daisho RS232 development front-end.
 * 
 * Copyright (C) 2013 Jared Boone, ShareBrained Technology, Inc.
 * Copyright (C) 2013 Dominic Spill
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
	input	wire	CLOCK_50,
	input	wire	CLOCK2_50,
	input	wire	CLOCK3_50,
	input	wire	SMA_CLKIN,
	output	wire	SMA_CLKOUT,
	
	// RS232/UART
	input	wire	UART_RXD,
	output	wire	UART_TXD,
	input	wire	UART_RTS,
	output	wire	UART_CTS,
	
	// PS2
	inout	wire	PS2_DAT,
	inout	wire	PS2_CLK,
	inout	wire	PS2_DAT2,
	inout	wire	PS2_CLK2,
	
	// LCD
	output	wire	LCD_ON,
	output	wire	LCD_BLON,
	output	wire	LCD_EN,
	output	wire	LCD_RW,
	output	wire	LCD_RS,
	inout	wire	[7:0]	LCD_DATA,
	
	// LEDs
	output	wire	[17:0]	LEDR,
	output	wire	[8:0]	LEDG,
	
	// Hex LEDs
	output	wire	[6:0]	HEX0,
	output	wire	[6:0]	HEX1,
	output	wire	[6:0]	HEX2,
	output	wire	[6:0]	HEX3,
	output	wire	[6:0]	HEX4,
	output	wire	[6:0]	HEX5,
	output	wire	[6:0]	HEX6,
	output	wire	[6:0]	HEX7,
	
	// Keys
	input	wire	[3:0]	KEY,
	
	// Switches
	input	wire	[17:0]	SW,
	
	// HSMC communication board
	input	wire	HSMC_0_RXD,
	output	wire	HSMC_0_TXD,
	input	wire	RS485_0_RTS,
	
	input	wire	HSMC_1_RXD,
	output	wire	HSMC_1_TXD,
	input	wire	RS485_1_RTS,
	
	// DCE
	output	wire	DAISHO_RS232_A_RTS,
	output	wire	DAISHO_RS232_A_TXD,
	output	wire	DAISHO_RS232_A_DTR,
	input	wire	DAISHO_RS232_A_RXD,
	input	wire	DAISHO_RS232_A_CTS,
	input	wire	DAISHO_RS232_A_CD,
	input	wire	DAISHO_RS232_A_RI,
	input	wire	DAISHO_RS232_A_DSR,
	
	// DTE
	output	wire	DAISHO_RS232_B_RXD,
	output	wire	DAISHO_RS232_B_CTS,
	output	wire	DAISHO_RS232_B_CD,
	output	wire	DAISHO_RS232_B_RI,
	output	wire	DAISHO_RS232_B_DSR,
	input	wire	DAISHO_RS232_B_RTS,
	input	wire	DAISHO_RS232_B_TXD,
	input	wire	DAISHO_RS232_B_DTR,
	
	// DCE
	output	wire	DAISHO_RS232_C_RTS,
	output	wire	DAISHO_RS232_C_TXD,
	output	wire	DAISHO_RS232_C_DTR,
	input	wire	DAISHO_RS232_C_RXD,
	input	wire	DAISHO_RS232_C_CTS,
	input	wire	DAISHO_RS232_C_CD,
	input	wire	DAISHO_RS232_C_RI,
	input	wire	DAISHO_RS232_C_DSR,
	
	// DTE
	output	wire	DAISHO_RS232_D_RXD,
	output	wire	DAISHO_RS232_D_CTS,
	output	wire	DAISHO_RS232_D_CD,
	output	wire	DAISHO_RS232_D_RI,
	output	wire	DAISHO_RS232_D_DSR,
	input	wire	DAISHO_RS232_D_RTS,
	input	wire	DAISHO_RS232_D_TXD,
	input	wire	DAISHO_RS232_D_DTR,

	output	wire	DAISHO_RS232_SD_ALL
);

assign DAISHO_RS232_SD_ALL = 1'b0;

assign SMA_CLKOUT = 1'b0;

assign UART_CTS = 1'b1;

assign LCD_ON = 1'b0;
assign LCD_BLON = 1'b0;
assign LCD_EN = 1'b0;
assign LCD_RW = 1'b0;
assign LCD_RS = 1'b0;

assign HEX0 = 7'b1111111;
assign HEX1 = 7'b1111111;
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;

reg [31:0] clock_divider;

always@(posedge CLOCK_50)
begin
	clock_divider <= clock_divider + 1;
end

assign LEDR = clock_divider[31:14];
assign LEDG = { 3'b000, ~DAISHO_RS232_A_TXD, ~DAISHO_RS232_B_RXD,
				~DAISHO_RS232_C_TXD, ~DAISHO_RS232_D_RXD,
				~UART_RXD, ~HSMC_0_RXD };

assign DAISHO_RS232_A_TXD = DAISHO_RS232_B_TXD;
assign DAISHO_RS232_A_RTS = DAISHO_RS232_B_RTS;
assign DAISHO_RS232_A_DTR = DAISHO_RS232_B_DTR;
assign DAISHO_RS232_B_RXD = DAISHO_RS232_A_RXD;
assign DAISHO_RS232_B_CTS = DAISHO_RS232_A_CTS;
assign DAISHO_RS232_B_DSR = DAISHO_RS232_A_DSR;
assign DAISHO_RS232_B_CD = DAISHO_RS232_A_CD;
assign DAISHO_RS232_B_RI = DAISHO_RS232_A_RI;

assign DAISHO_RS232_C_TXD = DAISHO_RS232_D_TXD;
assign DAISHO_RS232_C_RTS = DAISHO_RS232_D_RTS;
assign DAISHO_RS232_C_DTR = DAISHO_RS232_D_DTR;
assign DAISHO_RS232_D_RXD = DAISHO_RS232_C_RXD;
assign DAISHO_RS232_D_CTS = DAISHO_RS232_C_CTS;
assign DAISHO_RS232_D_DSR = DAISHO_RS232_C_DSR;
assign DAISHO_RS232_D_CD = DAISHO_RS232_C_CD;
assign DAISHO_RS232_D_RI = DAISHO_RS232_C_RI;

assign HSMC_0_TXD = UART_RXD;
assign UART_TXD = HSMC_0_RXD;

endmodule
