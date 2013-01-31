/*
 * Daisho debouncer test demonstration project on Terasic DE2-115 FPGA board
 * 
 * Copyright (C) 2013 Benjamin Vernoux
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

module de2_115_debouncer_test(
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
	input	wire	[17:0]	SW
);

/* Push button 0 to 3 states(with debounce) */
wire B0_state_active; // 1 If active(down), 0 if not active(up)
wire B0_state_pushed; // Only active 1 clock cycle
wire B0_state_released; // Only active 1 clock cycle

wire B1_state_active; // 1 If active(down), 0 if not active(up)
wire B1_state_pushed; // Only active 1 clock cycle
wire B1_state_released; // Only active 1 clock cycle

wire B2_state_active; // 1 If active(down), 0 if not active(up)
wire B2_state_pushed; // Only active 1 clock cycle
wire B2_state_released; // Only active 1 clock cycle

wire B3_state_active; // 1 If active(down), 0 if not active(up)
wire B3_state_pushed; // Only active 1 clock cycle
wire B3_state_released; // Only active 1 clock cycle

assign SMA_CLKOUT = 1'b0;

assign UART_CTS = 1'b1;

assign LCD_ON = 1'b0;
assign LCD_BLON = 1'b0;
assign LCD_EN = 1'b0;
assign LCD_RW = 1'b0;
assign LCD_RS = 1'b0;

reg [31:0] clock_divider;

reg [31:0] active_cnt = 32'd0;

reg [31:0] b0_active_cnt = 32'd0;
reg [3:0] b0_push_cnt = 4'd0;

reg [31:0] b1_active_cnt = 32'd0;
reg [3:0] b1_push_cnt = 4'd0;

reg [31:0] b2_active_cnt = 32'd0;
reg [3:0] b2_push_cnt = 4'd0;

reg [31:0] b3_active_cnt = 32'd0;
reg [3:0] b3_push_cnt = 4'd0;

always@(posedge CLOCK_50)
begin
	clock_divider <= clock_divider + 1;
end

/* Button 0,1,2,3 */
always@(posedge CLOCK_50)
begin
	if(B0_state_active)
	begin
		b0_active_cnt <= b0_active_cnt + 1;
		active_cnt <= b0_active_cnt;
	end

	if(B1_state_active)
	begin
		b1_active_cnt <= b1_active_cnt + 1;
		active_cnt <= b1_active_cnt;
	end
		
	if(B2_state_active)
	begin
		b2_active_cnt <= b2_active_cnt + 1;
		active_cnt <= b2_active_cnt;
	end

	if(B3_state_active)
	begin
		b3_active_cnt <= b3_active_cnt + 1;
		active_cnt <= b3_active_cnt;
	end
	
	if(B0_state_pushed)
		b0_push_cnt <= b0_push_cnt + 1;

	if(B1_state_pushed)
		b1_push_cnt <= b1_push_cnt + 1;

	if(B2_state_pushed)
		b2_push_cnt <= b2_push_cnt + 1;

	if(B3_state_pushed)
		b3_push_cnt <= b3_push_cnt + 1;
end

/*
assign LEDR = clock_divider[31:14];
*/
assign LEDR[17:8] = clock_divider[31:23];

assign LEDG = { 9'd0 };

pbutton_debouncer b0	(// Inputs
							.CLOCK_50(CLOCK_50),
							.PB(KEY[0]),
							.nb_debounce_cycle(32'd150000), // Debounce 3ms (3ms pushed + 3ms released)
							 // Outputs
							.PB_state_active(B0_state_active),
							.PB_state_pushed(B0_state_pushed),
							.PB_state_released(B0_state_released) );
							
pbutton_debouncer b1	(// Inputs
							.CLOCK_50(CLOCK_50),
							.PB(KEY[1]),
							.nb_debounce_cycle(32'd1500000), // Debounce 30ms (30ms pushed + 30ms released)
							 // Outputs
							.PB_state_active(B1_state_active),
							.PB_state_pushed(B1_state_pushed),
							.PB_state_released(B1_state_released) );
							
pbutton_debouncer b2	(// Inputs
							.CLOCK_50(CLOCK_50),
							.PB(KEY[2]),
							.nb_debounce_cycle(32'd25000000), // Debounce 500ms (500ms pushed + 500ms released)
							 // Outputs
							.PB_state_active(B2_state_active),
							.PB_state_pushed(B2_state_pushed),
							.PB_state_released(B2_state_released) );
							
pbutton_debouncer b3	(// Inputs
							.CLOCK_50(CLOCK_50),
							.PB(KEY[3]),
							.nb_debounce_cycle(32'd50000000), // Debounce 1000ms/1s (1s pushed + 1s released)
							 // Outputs
							.PB_state_active(B3_state_active),
							.PB_state_pushed(B3_state_pushed),
							.PB_state_released(B3_state_released) );

/* Just display number of time button is pressed and released */
seg7 s0 ( .o_dig(HEX0), .i_val(b0_push_cnt) );
seg7 s1 ( .o_dig(HEX1), .i_val(b1_push_cnt) );
seg7 s2 ( .o_dig(HEX2), .i_val(b2_push_cnt) );
seg7 s3 ( .o_dig(HEX3), .i_val(b3_push_cnt) );

/* Just display active button counting(16bits MSB only) time of button pressed(including debounce pressed & released) */
seg7 s4 ( .o_dig(HEX4), .i_val(active_cnt[19:16]) );
seg7 s5 ( .o_dig(HEX5), .i_val(active_cnt[23:20]) );
seg7 s6 ( .o_dig(HEX6), .i_val(active_cnt[27:24]) );
seg7 s7 ( .o_dig(HEX7), .i_val(active_cnt[31:28]) );

endmodule
