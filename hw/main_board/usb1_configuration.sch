EESchema Schematic File Version 2  date Saturday, February 09, 2013 11:10:56 AM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 8 10
Title "Daisho Project Main Board"
Date "9 feb 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	8000 8600 7900 8600
Wire Wire Line
	7900 8600 7900 8700
Wire Wire Line
	7900 8700 7300 8700
Wire Wire Line
	7300 8700 7300 8500
Wire Wire Line
	7300 8500 7400 8500
Wire Wire Line
	7100 8900 7100 9000
Wire Wire Line
	8000 8300 6800 8300
Wire Wire Line
	6900 9000 6900 8900
Wire Wire Line
	6900 8400 6900 8200
Wire Wire Line
	6800 8200 8000 8200
Connection ~ 6900 8200
Wire Wire Line
	8000 6900 6800 6900
Wire Wire Line
	7100 8400 7100 8300
Connection ~ 7100 8300
Wire Wire Line
	8000 8500 7900 8500
Wire Wire Line
	8000 2500 6800 2500
Text HLabel 6800 2500 0    60   Input ~ 0
PHY_RESET#
$Comp
L R R7
U 1 1 511486FB
P 7650 8500
F 0 "R7" V 7730 8500 50  0000 C CNN
F 1 "10K" V 7650 8500 50  0000 C CNN
F 4 "1%" V 7800 8500 60  0000 C CNN "Tolerance"
	1    7650 8500
	0    1    1    0   
$EndComp
$Comp
L GND #PWR014
U 1 1 511486B7
P 7100 9000
F 0 "#PWR014" H 7100 9000 30  0001 C CNN
F 1 "GND" H 7100 8930 30  0001 C CNN
	1    7100 9000
	1    0    0    -1  
$EndComp
$Comp
L R R6
U 1 1 511486B3
P 7100 8650
F 0 "R6" V 7180 8650 50  0000 C CNN
F 1 "R" V 7100 8650 50  0000 C CNN
	1    7100 8650
	1    0    0    -1  
$EndComp
Text HLabel 6800 8300 0    60   Input ~ 0
OUT_ENABLE
Text HLabel 6800 6900 0    60   Input ~ 0
XI
$Comp
L GND #PWR015
U 1 1 51148639
P 6900 9000
F 0 "#PWR015" H 6900 9000 30  0001 C CNN
F 1 "GND" H 6900 8930 30  0001 C CNN
	1    6900 9000
	1    0    0    -1  
$EndComp
Text HLabel 6800 8200 0    60   Input ~ 0
RESET#
$Comp
L R R5
U 1 1 51148613
P 6900 8650
F 0 "R5" V 6980 8650 50  0000 C CNN
F 1 "R" V 6900 8650 50  0000 C CNN
	1    6900 8650
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 5 1 510A04CC
P 8900 6700
F 0 "U2" H 8400 6650 60  0000 C CNN
F 1 "TUSB1310A" H 9250 6650 60  0000 C CNN
	5    8900 6700
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 4 1 510A04CB
P 8900 4500
F 0 "U2" H 8400 4450 60  0000 C CNN
F 1 "TUSB1310A" H 9250 4450 60  0000 C CNN
	4    8900 4500
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 3 1 510A04CA
P 8900 2300
F 0 "U2" H 8400 2250 60  0000 C CNN
F 1 "TUSB1310A" H 9250 2250 60  0000 C CNN
	3    8900 2300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
