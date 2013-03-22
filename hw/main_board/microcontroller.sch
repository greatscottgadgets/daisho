EESchema Schematic File Version 2  date Thursday, March 21, 2013 06:04:59 PM
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:contrib
LIBS:ddr2_sdram_sodimm
LIBS:ep4ce30f29
LIBS:tusb1310a
LIBS:samtec_qth-090-d
LIBS:mic5207-bm5
LIBS:quartzcms4_ground
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 2 15
Title "Daisho Project Main Board"
Date "22 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 2700 2600 0    60   Input ~ 0
FPGA_TDO
Text HLabel 2700 2500 0    60   Output ~ 0
FPGA_TMS
Text HLabel 2700 2400 0    60   Output ~ 0
FPGA_TCK
Text HLabel 2700 2300 0    60   Output ~ 0
FPGA_TDI
Text Notes 3700 1100 0    60   ~ 0
CONF_DONE and nSTATUS power from pull-up,\ncan be higher than Bank 6 VCCIO (1V8).
Connection ~ 3200 800 
Wire Wire Line
	3500 800  3500 900 
Wire Wire Line
	2700 800  3200 800 
Wire Wire Line
	3200 800  3500 800 
Wire Wire Line
	3500 1400 3500 1600
Wire Wire Line
	3500 1600 2700 1600
Wire Wire Line
	2700 1500 3200 1500
Wire Wire Line
	3200 1500 3200 1400
Wire Wire Line
	3200 800  3200 900 
$Comp
L R R?
U 1 1 5148D9B7
P 3500 1150
F 0 "R?" V 3580 1150 50  0000 C CNN
F 1 "10K" V 3500 1150 50  0000 C CNN
	1    3500 1150
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 5148D9B2
P 3200 1150
F 0 "R?" V 3280 1150 50  0000 C CNN
F 1 "10K" V 3200 1150 50  0000 C CNN
	1    3200 1150
	1    0    0    -1  
$EndComp
Text HLabel 2700 800  0    60   Input ~ 0
VCC
Text HLabel 2700 2000 0    60   Output ~ 0
FPGA_NCONFIG
Text HLabel 2700 1800 0    60   Output ~ 0
FPGA_DCLK
Text HLabel 2700 1900 0    60   Output ~ 0
FPGA_DATA0
Text HLabel 2700 1600 0    60   Input ~ 0
FPGA_NSTATUS
Text HLabel 2700 1500 0    60   Input ~ 0
FPGA_CONF_DONE
$EndSCHEMATC
