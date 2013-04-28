#
# usb3 device controller
#
# i/o constraints
#

# usb2 ulpi 60mhz
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
create_clock -name usb_ulpi_clk -period 16.666 [get_ports usb_ulpi_clk]

# cribbed from timequest example
# specify the maximum external clock delay to the FPGA
set CLKs_max 0.200
# specify the minimum external clock delay to the FPGA
set CLKs_min 0.100
# specify the maximum external clock delay to the external device
set CLKd_max 0.200
# specify the minimum external clock delay to the external device
set CLKd_min 0.100
# specify the maximum setup time of the external device
set tSU 0.125
# specify the minimum setup time of the external device
set tH 0.100
# specify the maximum board delay
set BD_max 0.800
# specify the minimum board delay
set BD_min 0.060

# create the associated virtual input clock
create_clock -period 16.666 -name virt_usb_clk

set_output_delay -clock virt_usb_clk -max [expr $CLKs_max + $BD_max + $tSU - $CLKd_min] [get_ports {usb_ulpi_d[*] usb_ulpi_stp}]
set_output_delay -clock virt_usb_clk -min [expr $CLKs_min + $BD_min - $tH - $CLKd_max] [get_ports {usb_ulpi_d[*] usb_ulpi_stp}]

set_input_delay -clock virt_usb_clk -max [expr $CLKs_max + $BD_max + $tSU - $CLKd_min] [get_ports {usb_ulpi_d[*] usb_ulpi_nxt usb_ulpi_dir}]
set_input_delay -clock virt_usb_clk -min [expr $CLKs_min + $BD_min - $tH - $CLKd_max] [get_ports {usb_ulpi_d[*] usb_ulpi_nxt usb_ulpi_dir}]

set_clock_groups -asynchronous \
-group { clk_50 } \
-group { usb_ulpi_clk } 

derive_pll_clocks
derive_clock_uncertainty