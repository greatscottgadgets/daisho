EESchema Schematic File Version 2  date Sunday, March 10, 2013 11:24:02 PM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 11 15
Title "Daisho Project Main Board"
Date "11 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 9700 2650 2    60   Input ~ 0
VCCIO
Connection ~ 9500 3050
Wire Wire Line
	9400 3050 9500 3050
Connection ~ 9500 2850
Wire Wire Line
	9400 2850 9500 2850
Connection ~ 9500 2650
Wire Wire Line
	9500 2650 9500 3150
Wire Wire Line
	9500 3150 9400 3150
Wire Wire Line
	9400 2650 9700 2650
Wire Wire Line
	9400 2750 9500 2750
Connection ~ 9500 2750
Wire Wire Line
	9400 2950 9500 2950
Connection ~ 9500 2950
$Comp
L EP4CE30F29 U1
U 1 1 5129C259
P 8500 2350
F 0 "U1" H 8500 2400 60  0000 C CNN
F 1 "EP4CE30F29" H 8550 2300 60  0000 C CNN
	1    8500 2350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
