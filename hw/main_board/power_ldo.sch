EESchema Schematic File Version 2  date Monday, March 18, 2013 02:32:12 PM
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
Sheet 15 15
Title "Daisho Project Main Board"
Date "18 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7200 4350 7450 4350
Wire Wire Line
	4500 3100 4500 3350
Wire Wire Line
	4500 3350 4750 3350
Wire Wire Line
	7450 3950 7200 3950
Wire Wire Line
	7200 4150 7450 4150
Wire Wire Line
	7450 4850 7200 4850
Wire Wire Line
	7450 3350 7200 3350
Wire Wire Line
	7200 3150 7450 3150
Text HLabel 7450 4350 2    60   Output ~ 0
DDR2_1V8
Text HLabel 7450 3350 2    60   Output ~ 0
USB_1V1D
Text HLabel 7450 3150 2    60   Output ~ 0
USB_1V1A
Text HLabel 4750 3350 2    60   Output ~ 0
FPGA_1V2D
$Comp
L +1.2V #PWR052
U 1 1 510B222D
P 4500 3100
F 0 "#PWR052" H 4500 3240 20  0001 C CNN
F 1 "+1.2V" H 4500 3210 30  0000 C CNN
	1    4500 3100
	1    0    0    -1  
$EndComp
Text HLabel 7450 4850 2    60   Output ~ 0
USB_3V3A
Text HLabel 7450 4150 2    60   Output ~ 0
USB_1V8D
Text HLabel 7450 3950 2    60   Output ~ 0
USB_1V8A
$EndSCHEMATC
