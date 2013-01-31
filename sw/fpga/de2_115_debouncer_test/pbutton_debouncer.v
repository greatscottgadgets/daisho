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

module pbutton_debouncer(CLOCK_50, PB, nb_debounce_cycle, PB_state_active, PB_state_pushed, PB_state_released);

// Inputs Clocks and Push button
input CLOCK_50; // 50 MHz Clock assumed
input PB; // Push Button with glitch to apply debounce
input [31:0] nb_debounce_cycle; // Number of debounce cycle
// Example nb_debounce_cycle 1500000 => 1500000/50MHz = 3ms
// Example nb_debounce_cycle 500000 = 10ms, 500000 = 100ms

// Outputs Push button state
output PB_state_active; // 1 If active(down), 0 if not active(up)
output PB_state_pushed; // Only active 1 clock cycle
output PB_state_released; // Only active 1 clock cycle

parameter PB_ACTIVE_STATE_HIGH = 0; // 0 means PB active state = 0/LOW, 1 means PB active state = 1/HIGH

reg [31:0] pb_debouncer_cnt = 32'd0; /* max cnt=2^32 => @50MHz max debounce time about 85s */
reg PB_state_active = 1'd0;
reg PB_sync_0;
reg PB_sync_1;

wire PB_not_active = (PB_state_active==PB_sync_1); /* PB idle (not active)*/
wire PB_cnt_max = (pb_debouncer_cnt==nb_debounce_cycle);

assign PB_state_pushed = ~PB_state_active & ~PB_not_active & PB_cnt_max;  // true for one clock cycle when we detect that PB went down
assign PB_state_released =  PB_state_active & ~PB_not_active & PB_cnt_max;  // true for one clock cycle when we detect that PB went up

// Synchronize PB with clock domain
always@(posedge CLOCK_50)
begin
	if(PB_ACTIVE_STATE_HIGH)
		PB_sync_0 <= PB;  // does not invert PB => PB_sync_0 active high
	else
		PB_sync_0 <= ~PB;  // invert PB => PB_sync_0 active high

	PB_sync_1 <= PB_sync_0;
end

// When the push-button is pushed or released, we increment the counter
// The counter has to be maxed out before we decide that the push-button state has changed

always@(posedge CLOCK_50)
begin
	if(PB_not_active)
		pb_debouncer_cnt <= 0;
	else
		begin
			pb_debouncer_cnt <= pb_debouncer_cnt + 1;
			
			if(PB_cnt_max)
				PB_state_active <= ~PB_state_active; // Max debounce count reached invert the state
		end
end

endmodule
