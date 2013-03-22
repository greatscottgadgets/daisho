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
Sheet 5 15
Title "Daisho Project Main Board"
Date "22 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7400 9800 7400 9900
Wire Wire Line
	7600 9100 6400 9100
Wire Wire Line
	7600 4400 6400 4400
Wire Wire Line
	7600 6800 6400 6800
Wire Wire Line
	7600 6700 6400 6700
Wire Wire Line
	7600 8600 6400 8600
Wire Wire Line
	7600 8900 6400 8900
Wire Wire Line
	7600 8700 6400 8700
Connection ~ 9500 3100
Wire Wire Line
	9400 3100 9500 3100
Connection ~ 9500 2900
Wire Wire Line
	9400 2900 9500 2900
Connection ~ 9500 2700
Wire Wire Line
	9500 2700 9500 3200
Wire Wire Line
	9500 3200 9400 3200
Wire Wire Line
	9400 2700 9700 2700
Wire Wire Line
	9400 2800 9500 2800
Connection ~ 9500 2800
Wire Wire Line
	9400 3000 9500 3000
Connection ~ 9500 3000
Wire Wire Line
	7600 8500 6400 8500
Wire Wire Line
	7600 8800 6400 8800
Wire Wire Line
	7600 9000 6400 9000
Wire Wire Line
	7600 8400 6400 8400
Wire Wire Line
	7600 4700 6400 4700
Wire Wire Line
	7600 7900 6400 7900
Wire Wire Line
	7600 3100 6400 3100
Wire Wire Line
	7400 9100 7400 9300
Connection ~ 7400 9100
$Comp
L GND #PWR?
U 1 1 5148E4DC
P 7400 9900
F 0 "#PWR?" H 7400 9900 30  0001 C CNN
F 1 "GND" H 7400 9830 30  0001 C CNN
	1    7400 9900
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 5148E4CC
P 7400 9550
F 0 "R?" V 7480 9550 50  0000 C CNN
F 1 "R" V 7400 9550 50  0000 C CNN
	1    7400 9550
	1    0    0    -1  
$EndComp
Text HLabel 6400 9100 0    60   Input ~ 0
FPGA_NCE
Text HLabel 6400 9000 0    60   Output ~ 0
FPGA_TDO
Text HLabel 6400 8900 0    60   Input ~ 0
FPGA_TMS
Text HLabel 6400 8800 0    60   Input ~ 0
FPGA_TCK
Text HLabel 6400 8700 0    60   Input ~ 0
FPGA_TDI
Text HLabel 6400 6700 0    60   BiDi ~ 0
FPGA_NSTATUS
Text HLabel 6400 8600 0    60   Input ~ 0
FPGA_NCONFIG
Text HLabel 6400 8400 0    60   Input ~ 0
FPGA_DCLK
Text HLabel 6400 8500 0    60   Input ~ 0
FPGA_DATA0
Text HLabel 3900 3100 0    60   Output ~ 0
FE_VCC_EN
Text HLabel 3900 2900 0    60   Output ~ 0
FE_EN
Text HLabel 3900 2700 0    60   BiDi ~ 0
FE_SDA
Text HLabel 3900 2600 0    60   Output ~ 0
FE_SCL
Text HLabel 9700 2700 2    60   Input ~ 0
VCCIO
$Comp
L EP4CE30F29 U1
U 1 1 5129C259
P 8500 2400
F 0 "U1" H 8500 2450 60  0000 C CNN
F 1 "EP4CE30F29" H 8550 2350 60  0000 C CNN
	1    8500 2400
	1    0    0    -1  
$EndComp
$EndSCHEMATC
