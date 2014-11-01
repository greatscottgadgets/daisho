## Generated SDC file "top.sdc"

## Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 14.0.0 Build 200 06/17/2014 SJ Web Edition"

## DATE    "Mon Oct  6 16:12:01 2014"

##
## DEVICE  "EP4CE30F29C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

# PIPE

set usb_pclk_period 4.000
#set usb_txclk_period 4.000

# Clock at dedicated clock input to FPGA
create_clock \
	-name usb0_rx_data_clock \
	-period $usb_pclk_period \
	[get_ports {usb0_pclk}]

# Remote (virtual) clock that transmits both the data and clock from the PHY.
create_clock \
	-name usb0_rx_launch_clock \
	-waveform {1 3} \
	-period $usb_pclk_period
	
# Clock used to clock RX input registers.
create_generated_clock \
	-name usb0_rx_latch_clock \
	-source [get_pins {usb0_pclk_pll|altpll_component|auto_generated|pll1|inclk[0]}] \
	[get_pins {usb0_pclk_pll|altpll_component|auto_generated|pll1|clk[0]}]

#create_clock -name usb0_txclk_virt -period $usb_txclk_period
##create_clock -name usb0_txclk_output -period $usb_txclk_period [get_ports {usb0_tx_clk}]
#create_generated_clock \
#	-name usb0_txclk_out \
#	-source [get_pins usb0_tx_clk_out|ALTDDIO_OUT_component|auto_generated|ddio_outa[0]|muxsel] \
#	[get_ports usb0_tx_clk]

#create_clock -name usb1_pclk_virt -period $usb_pclk_period
#create_clock -name usb1_pclk_input -period $usb_pclk_period [get_ports {usb1_pclk}]

#create_clock -name usb1_txclk_virt -period $usb_txclk_period
##create_clock -name usb1_txclk_output -period $usb_txclk_period [get_ports {usb1_tx_clk}]
#create_generated_clock \
#	-name usb1_txclk_out \
#	-source [get_pins usb1_tx_clk_out|ALTDDIO_OUT_component|auto_generated|ddio_outa[0]|muxsel] \
#	[get_ports usb1_tx_clk]

#create_generated_clock \
#	-name usb0_pclk_phase_90 \
#	-source usb0_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 90 \
#	usb0_pclk_pll|altpll_component|auto_generated|pll1|clk[1]
#create_generated_clock \
#	-name usb0_pclk_phase_180 \
#	-source usb0_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 180 \
#	usb0_pclk_pll|altpll_component|auto_generated|pll1|clk[2]
#create_generated_clock \
#	-name usb0_pclk_phase_270 \
#	-source usb0_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 270 \
#	usb0_pclk_pll|altpll_component|auto_generated|pll1|clk[3]

#create_generated_clock \
#	-name usb1_pclk_phase_0 \
#	-source usb1_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 0 \
#	usb1_pclk_pll|altpll_component|auto_generated|pll1|clk[0]
#create_generated_clock \
#	-name usb1_pclk_phase_90 \
#	-source usb1_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 90 \
#	usb1_pclk_pll|altpll_component|auto_generated|pll1|clk[1]
#create_generated_clock \
#	-name usb1_pclk_phase_180 \
#	-source usb1_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 180 \
#	usb1_pclk_pll|altpll_component|auto_generated|pll1|clk[2]
#create_generated_clock \
#	-name usb1_pclk_phase_270 \
#	-source usb1_pclk_pll|altpll_component|auto_generated|pll1|inclk[0] \
#	-phase 270 \
#	usb1_pclk_pll|altpll_component|auto_generated|pll1|clk[3]

# ULPI

#set usb_ulpi_clk_period 16.666
#
#create_clock -name {usb0_ulpi_clk_virt} -period $usb_ulpi_clk_period
#create_clock -name {usb0_ulpi_clk_input} -period $usb_ulpi_clk_period [get_ports {usb0_ulpi_clk}]
#
#create_clock -name {usb1_ulpi_clk_virt} -period $usb_ulpi_clk_period
#create_clock -name {usb1_ulpi_clk_input} -period $usb_ulpi_clk_period [get_ports {usb1_ulpi_clk}]

#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks

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

# PIPE

set usb_rx_data_tco_min 1.000
set usb_rx_data_tco_max 2.000

set usb_tx_tsu 1.000
set usb_tx_thold 0.000

set trace_tolerance 0.100

# From http://www.samtec.com/Documents/WebFiles/testrpt/time-data-summary-SMA_QTH-QSH-05mm_web.pdf
set connector_delay 0.061

# PIPE: USB0

set usb0_pclk_clks_min 0.000
set usb0_pclk_clks_max 0.000
set usb0_pclk_clkd_min [expr 0.316 + $connector_delay - $trace_tolerance]
set usb0_pclk_clkd_max [expr 0.316 + $connector_delay + $trace_tolerance]
set usb0_pclk_bd_min [expr 0.307 + $connector_delay - $trace_tolerance]
set usb0_pclk_bd_max [expr 0.617 + $connector_delay + $trace_tolerance]
set usb0_rx_ports [get_ports {usb0_rx_data[*] usb0_rx_datak[*] usb0_rx_valid usb0_rx_status[*] usb0_phy_status}]

set_input_delay \
	-clock usb0_rx_launch_clock \
	-max [expr $usb0_pclk_clks_max + $usb_rx_data_tco_max + $usb0_pclk_bd_max - $usb0_pclk_clkd_min] \
	$usb0_rx_ports
set_input_delay \
	-clock usb0_rx_launch_clock \
	-min [expr $usb0_pclk_clks_min + $usb_rx_data_tco_min + $usb0_pclk_bd_min - $usb0_pclk_clkd_max] \
	$usb0_rx_ports

#set usb0_txclk_clks_min 0.000
#set usb0_txclk_clks_max 0.000
#set usb0_txclk_clkd_min [expr 0.289 + $connector_delay - $trace_tolerance]
#set usb0_txclk_clkd_max [expr 0.289 + $connector_delay + $trace_tolerance]
#set usb0_txclk_bd_min [expr 0.288 + $connector_delay - $trace_tolerance]
#set usb0_txclk_bd_max [expr 0.625 + $connector_delay + $trace_tolerance]
#set usb0_tx_ports [get_ports {usb0_tx_data[*] usb0_tx_datak[*] usb0_tx_deemph[*] usb0_tx_detrx_lpbk usb0_tx_elecidle usb0_tx_margin[*] usb0_tx_swing usb0_rx_polarity usb0_power_down[*]}]
#
#set_output_delay \
#	-clock usb0_txclk_virt \
#	-max [expr $usb0_txclk_clks_max + $usb0_txclk_bd_max + $usb_tx_tsu - $usb0_txclk_clkd_min] \
#	$usb0_tx_ports
#set_output_delay \
#	-clock usb0_txclk_virt \
#	-min [expr $usb0_txclk_clks_min + $usb0_txclk_bd_min + $usb_tx_thold - $usb0_txclk_clkd_max] \
#	$usb0_tx_ports \
#	-add_delay

# PIPE: USB1

#set usb1_pclk_clks_min 0.000
#set usb1_pclk_clks_max 0.000
#set usb1_pclk_clkd_min [expr 0.368 + $connector_delay - $trace_tolerance]
#set usb1_pclk_clkd_max [expr 0.368 + $connector_delay + $trace_tolerance]
#set usb1_pclk_bd_min [expr 0.348 + $connector_delay - $trace_tolerance]
#set usb1_pclk_bd_max [expr 0.471 + $connector_delay + $trace_tolerance]
#set usb1_rx_ports [get_ports {usb1_rx_data[*] usb1_rx_datak[*] usb1_rx_valid usb1_rx_status[*] usb1_phy_status}]
#
#set_input_delay \
#	-clock usb1_pclk_virt \
#	-max [expr $usb1_pclk_clks_max + $usb_rx_data_tco_max + $usb1_pclk_bd_max - $usb1_pclk_clkd_min] \
#	$usb1_rx_ports
#set_input_delay \
#	-clock usb1_pclk_virt \
#	-min [expr $usb1_pclk_clks_min + $usb_rx_data_tco_min + $usb1_pclk_bd_min - $usb1_pclk_clkd_max] \
#	$usb1_rx_ports

#set usb1_txclk_clks_min 0.000
#set usb1_txclk_clks_max 0.000
#set usb1_txclk_clkd_min [expr 0.341 + $connector_delay - $trace_tolerance]
#set usb1_txclk_clkd_max [expr 0.341 + $connector_delay + $trace_tolerance]
#set usb1_txclk_bd_min [expr 0.325 + $connector_delay - $trace_tolerance]
#set usb1_txclk_bd_max [expr 0.732 + $connector_delay + $trace_tolerance]
#set usb1_tx_ports [get_ports {usb1_tx_data[*] usb1_tx_datak[*] usb1_tx_deemph[*] usb1_tx_detrx_lpbk usb1_tx_elecidle usb1_tx_margin[*] usb1_tx_swing usb1_rx_polarity usb1_power_down[*]}]
#
#set_output_delay \
#	-clock usb1_txclk_virt \
#	-max [expr $usb1_txclk_clks_max + $usb1_txclk_bd_max + $usb_tx_tsu - $usb1_txclk_clkd_min] \
#	$usb1_tx_ports
#set_output_delay \
#	-clock usb1_txclk_virt \
#	-min [expr $usb1_txclk_clks_min + $usb1_txclk_bd_min + $usb_tx_thold - $usb1_txclk_clkd_max] \
#	$usb1_tx_ports \
#	-add_delay

#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



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

