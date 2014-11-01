## Generated SDC file "gige.sdc"

## Copyright (C) 1991-2012 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 12.1 Build 243 01/31/2013 Service Pack 1 SJ Web Edition"

## DATE    "Sun Jul 21 16:33:22 2013"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_50} -period 20.000 [get_ports {clk_50}]

create_clock -name {usb_ulpi_clk} -period 16.666 [get_ports {usb_ulpi_clk}]

create_clock -name {usb_pipe_pclk} -period 4.000 [get_ports {usb_pipe_pclk}]
create_clock -name {usb_pipe_tx_clk} -period 4.000 [get_ports {usb_pipe_tx_clk}]

create_clock -name {phy0_gm_rx_clk} -period 8.000 [get_ports {phy0_gm_rx_clk}]
create_clock -name {phy0_gm_gtx_clk} -period 8.000 [get_ports {phy0_gm_gtx_clk}]
create_clock -name {phy0_tx_clk} -period 40.000 [get_ports {phy0_tx_clk}]

create_clock -name {phy1_gm_rx_clk} -period 8.000 [get_ports {phy1_gm_rx_clk}]
create_clock -name {phy1_gm_gtx_clk} -period 8.000 [get_ports {phy1_gm_gtx_clk}]
create_clock -name {phy1_tx_clk} -period 40.000 [get_ports {phy1_tx_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

#create_generated_clock \
	-name phy0_gm_gtx_clk_common \
	-source [get_pins]

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty

#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

#set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_id9:dffpipe15|dffe16a*}]
#set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe12|dffe13a*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

