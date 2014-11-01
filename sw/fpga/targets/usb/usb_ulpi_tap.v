//
// USB 2.0 ULPI tap
//
// Copyright (c) 2012-2013 Marshall H.
// Copyright (c) 2014 Jared Boone, ShareBrained Technology, Inc.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

module usb_ulpi_tap (
	input		wire				ext_clk,
	input		wire				reset_n,
	output	wire				reset_n_out,

	input		wire				phy_ulpi_clk,
	inout		wire	[ 7:0]	phy_ulpi_d,
	input		wire				phy_ulpi_dir,
	output	wire				phy_ulpi_stp,
	input		wire				phy_ulpi_nxt,

	output	wire				ulpi_out_act,
	output	wire	[ 7:0]	ulpi_out_byte,
	output	wire				ulpi_out_latch,

	output	wire				ulpi_in_cts,
	output	wire				ulpi_in_nxt,
	input		wire	[ 7:0]	ulpi_in_byte,
	input		wire				ulpi_in_latch,
	input		wire				ulpi_in_stp,

	input		wire				opt_disable_all,
	input		wire				opt_enable_hs,
	input		wire				opt_ignore_vbus,
	output	wire				stat_connected,
	output	wire				stat_fs,
	output	wire				stat_hs,

	output	wire	[1:0]		dbg_linestate
);

reg 			reset_1, reset_2;				// local reset

// allow reset-time pin strapping for the usb 3.0 phy. 
	// this should not affect regular usb 2.0 PHYs
	//
	assign			phy_ulpi_d = (reset_2 ? (phy_ulpi_d_oe ? phy_ulpi_d_out : 8'bZZZZZZZZ) : 
					{
						1'b0,	// ISO_START	PIPE Isolate Mode
						1'b0,	// ULPI_8BIT	Bus Width ULPI
						2'b11,	// REFCLKSEL	Reference clock freq
						4'b0
					});

	wire	[7:0]	phy_ulpi_d_in = phy_ulpi_d;
	wire	[7:0]	phy_ulpi_d_out;
	wire			phy_ulpi_d_oe;

always @(posedge ext_clk) begin
	// synchronize external reset to local domain
	{reset_2, reset_1} <= {reset_1, reset_n};
end

usb2_ulpi 	ia (
	// reset signal frome external clock domain, must be synchronized
	.reset_n		( reset_n ),
	
	// locally generated reset, triggers local USB reset when cable is 
	// unplugged, OR'd with external reset above
	.reset_local	( reset_n_out ),
	
	// easy flag that will cause all modules to stay in reset and be optimized out
	// useful for testing 3.0 only
	.opt_disable_all ( opt_disable_all ),
	
	// high-speed enable, full speed enumeration works but data transmission
	// is not guaranteed
	.opt_enable_hs	( opt_enable_hs ),
	
	// normally a change in Vbus signals that the device has been disconnected.
	// on some PHYs this may be unreliable (such as TUSB1310A)
	.opt_ignore_vbus (opt_ignore_vbus),
	
	// status signals
	.stat_connected	( stat_connected ),
	.stat_fs		( stat_fs ),
	.stat_hs		( stat_hs ),

	// external PHY interface
	.phy_clk		( phy_ulpi_clk ),
	.phy_d_in		( phy_ulpi_d_in ),
	.phy_d_out_mux	( phy_ulpi_d_out ),
	.phy_d_oe		( phy_ulpi_d_oe ),
	.phy_dir		( phy_ulpi_dir ),
	.phy_stp		( phy_ulpi_stp ),
	.phy_nxt		( phy_ulpi_nxt ),
	
	// packet layer interface
	.pkt_out_act	( ulpi_out_act ),
	.pkt_out_byte	( ulpi_out_byte ),
	.pkt_out_latch	( ulpi_out_latch ),
	.pkt_in_cts		( ulpi_in_cts ),
	.pkt_in_nxt		( ulpi_in_nxt ),
	.pkt_in_byte	( ulpi_in_byte ),
	.pkt_in_latch	( ulpi_in_latch ),
	.pkt_in_stp		( ulpi_in_stp ),
	
	.dbg_linestate 	( dbg_linestate )
);

endmodule
