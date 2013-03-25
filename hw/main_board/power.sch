EESchema Schematic File Version 2  date Monday, March 25, 2013 04:30:54 PM
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
LIBS:lpc11u1x
LIBS:gsg-microusb
LIBS:pnp_sot23
LIBS:si5351c-b
LIBS:tps62410
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 2 16
Title "Daisho Project Main Board"
Date "25 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 8300 5200 0    60   ~ 0
V3P3 always on, required for microcontroller,\nwhich brings up all other hardware.
Text HLabel 6400 2200 2    60   Output ~ 0
VRAW
Text HLabel 4300 5200 0    60   Input ~ 0
SMPS_MODE
Wire Wire Line
	4300 5200 6400 5200
Wire Wire Line
	5900 6100 5900 6000
Wire Wire Line
	5300 4100 8100 4100
Connection ~ 5300 5300
Wire Wire Line
	5300 4100 5300 5300
Connection ~ 9300 5400
Wire Wire Line
	10000 5400 7700 5400
Wire Wire Line
	5000 5800 5000 5900
Wire Wire Line
	5000 5400 5000 5300
Connection ~ 8900 4300
Wire Wire Line
	7300 4300 10000 4300
Wire Wire Line
	7700 5300 7900 5300
Wire Wire Line
	8900 5800 8900 5700
Connection ~ 8500 6300
Wire Wire Line
	8900 6200 8900 6300
Wire Wire Line
	6200 6300 6200 5500
Wire Wire Line
	6200 5500 6400 5500
Wire Wire Line
	5600 4300 5500 4300
Wire Wire Line
	7050 5950 7050 6050
Connection ~ 6700 4300
Wire Wire Line
	6700 4300 6700 4600
Wire Wire Line
	6700 4600 6850 4600
Connection ~ 7400 4300
Wire Wire Line
	7400 4300 7400 4600
Wire Wire Line
	7400 4600 7250 4600
Wire Wire Line
	8900 4800 8900 4900
Connection ~ 8500 4300
Wire Wire Line
	8900 4300 8900 4400
Wire Wire Line
	7900 4300 7900 4400
Wire Wire Line
	8500 4300 8500 4400
Connection ~ 7900 4300
Wire Wire Line
	8500 4800 8500 4900
Wire Wire Line
	7700 5100 7900 5100
Wire Wire Line
	7900 5100 7900 5000
Wire Wire Line
	6400 5100 6200 5100
Wire Wire Line
	6200 5100 6200 4300
Wire Wire Line
	7700 5500 7900 5500
Wire Wire Line
	7900 5500 7900 5600
Wire Wire Line
	6800 4300 6100 4300
Connection ~ 6200 4300
Wire Wire Line
	5500 6300 5600 6300
Wire Wire Line
	6100 6300 6800 6300
Connection ~ 6200 6300
Wire Wire Line
	8500 6300 8500 6200
Connection ~ 7900 6300
Wire Wire Line
	8500 5800 8500 5700
Wire Wire Line
	9300 6000 9300 6100
Wire Wire Line
	7300 6300 10000 6300
Connection ~ 8900 6300
Wire Wire Line
	6400 5300 4300 5300
Connection ~ 5000 5300
Wire Wire Line
	7900 6200 7900 6600
Wire Wire Line
	7900 6600 5300 6600
Wire Wire Line
	5300 6600 5300 5400
Wire Wire Line
	5300 5400 6400 5400
Wire Wire Line
	9300 5400 9300 5500
Wire Wire Line
	7700 5200 8100 5200
Wire Wire Line
	8100 5200 8100 4100
Wire Wire Line
	5900 5500 5900 5200
Connection ~ 5900 5200
$Comp
L GND #PWR?
U 1 1 5150DCE3
P 5900 6100
F 0 "#PWR?" H 5900 6100 30  0001 C CNN
F 1 "GND" H 5900 6030 30  0001 C CNN
	1    5900 6100
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 5150DCD4
P 5900 5750
F 0 "R?" V 5980 5750 50  0000 C CNN
F 1 "10K" V 5900 5750 50  0000 C CNN
	1    5900 5750
	-1   0    0    1   
$EndComp
Text HLabel 4700 2200 0    60   Input ~ 0
VRAW_EXT
Text HLabel 4700 1800 0    60   Input ~ 0
VRAW_FE
Text HLabel 4700 2000 0    60   Input ~ 0
VRAW_USB
Text HLabel 10000 5400 2    60   Input ~ 0
V1P8_ENABLE
$Comp
L GND #PWR?
U 1 1 5150D289
P 5000 5900
F 0 "#PWR?" H 5000 5900 30  0001 C CNN
F 1 "GND" H 5000 5830 30  0001 C CNN
	1    5000 5900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D153
P 5500 6300
F 0 "#PWR?" H 5500 6300 30  0001 C CNN
F 1 "GND" H 5500 6230 30  0001 C CNN
	1    5500 6300
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D14E
P 5500 4300
F 0 "#PWR?" H 5500 4300 30  0001 C CNN
F 1 "GND" H 5500 4230 30  0001 C CNN
	1    5500 4300
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 5150D148
P 5850 4300
F 0 "R?" V 5930 4300 50  0000 C CNN
F 1 "162K" V 5850 4300 50  0000 C CNN
F 4 "1%" V 5750 4300 60  0000 C CNN "Tolerance"
	1    5850 4300
	0    -1   -1   0   
$EndComp
$Comp
L R R?
U 1 1 5150D142
P 5850 6300
F 0 "R?" V 5930 6300 50  0000 C CNN
F 1 "162K" V 5850 6300 50  0000 C CNN
F 4 "1%" V 5750 6300 60  0000 C CNN "Tolerance"
	1    5850 6300
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D107
P 8900 4900
F 0 "#PWR?" H 8900 4900 30  0001 C CNN
F 1 "GND" H 8900 4830 30  0001 C CNN
	1    8900 4900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D104
P 8500 4900
F 0 "#PWR?" H 8500 4900 30  0001 C CNN
F 1 "GND" H 8500 4830 30  0001 C CNN
	1    8500 4900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D101
P 8900 5700
F 0 "#PWR?" H 8900 5700 30  0001 C CNN
F 1 "GND" H 8900 5630 30  0001 C CNN
	1    8900 5700
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D0FF
P 8500 5700
F 0 "#PWR?" H 8500 5700 30  0001 C CNN
F 1 "GND" H 8500 5630 30  0001 C CNN
	1    8500 5700
	-1   0    0    1   
$EndComp
$Comp
L C C?
U 1 1 5150D0D4
P 5000 5600
F 0 "C?" H 5050 5700 50  0000 L CNN
F 1 "10U" H 5050 5500 50  0000 L CNN
	1    5000 5600
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D0CC
P 7050 6050
F 0 "#PWR?" H 7050 6050 30  0001 C CNN
F 1 "GND" H 7050 5980 30  0001 C CNN
	1    7050 6050
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 5150D0C5
P 7050 6300
F 0 "R?" V 7130 6300 50  0000 C CNN
F 1 "330K" V 7050 6300 50  0000 C CNN
F 4 "1%" V 6950 6300 60  0000 C CNN "Tolerance"
	1    7050 6300
	0    -1   -1   0   
$EndComp
$Comp
L C C?
U 1 1 5150D0BC
P 7050 4600
F 0 "C?" H 7100 4700 50  0000 L CNN
F 1 "33P" H 7100 4500 50  0000 L CNN
	1    7050 4600
	0    -1   1    0   
$EndComp
$Comp
L R R?
U 1 1 5150D0B0
P 7050 4300
F 0 "R?" V 7130 4300 50  0000 C CNN
F 1 "715K" V 7050 4300 50  0000 C CNN
F 4 "1%" V 6950 4300 60  0000 C CNN "Tolerance"
	1    7050 4300
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D07E
P 9300 6100
F 0 "#PWR?" H 9300 6100 30  0001 C CNN
F 1 "GND" H 9300 6030 30  0001 C CNN
	1    9300 6100
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 5150D073
P 9300 5750
F 0 "R?" V 9380 5750 50  0000 C CNN
F 1 "10K" V 9300 5750 50  0000 C CNN
	1    9300 5750
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR?
U 1 1 5150D068
P 7900 5300
F 0 "#PWR?" H 7900 5300 30  0001 C CNN
F 1 "GND" H 7900 5230 30  0001 C CNN
	1    7900 5300
	0    -1   -1   0   
$EndComp
$Comp
L C C?
U 1 1 5150D045
P 8900 6000
F 0 "C?" H 8950 6100 50  0000 L CNN
F 1 "10U" H 8950 5900 50  0000 L CNN
	1    8900 6000
	-1   0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 5150D040
P 8500 6000
F 0 "C?" H 8550 6100 50  0000 L CNN
F 1 "10U" H 8550 5900 50  0000 L CNN
	1    8500 6000
	-1   0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 5150D035
P 8900 4600
F 0 "C?" H 8950 4700 50  0000 L CNN
F 1 "10U" H 8950 4500 50  0000 L CNN
	1    8900 4600
	-1   0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 5150D032
P 8500 4600
F 0 "C?" H 8550 4700 50  0000 L CNN
F 1 "10U" H 8550 4500 50  0000 L CNN
	1    8500 4600
	-1   0    0    -1  
$EndComp
$Comp
L INDUCTOR L?
U 1 1 5150CE03
P 7900 5900
F 0 "L?" V 7850 5900 40  0000 C CNN
F 1 "4U7" V 8000 5900 40  0000 C CNN
	1    7900 5900
	1    0    0    1   
$EndComp
$Comp
L INDUCTOR L?
U 1 1 5150CDF9
P 7900 4700
F 0 "L?" V 7850 4700 40  0000 C CNN
F 1 "4U7" V 8000 4700 40  0000 C CNN
	1    7900 4700
	1    0    0    1   
$EndComp
Text Notes 5300 3700 0    60   ~ 0
SW2 provides more output current in other variants. Prefer\nSW2 for supply rail more likely to be heavily loaded (3V3,\nI suspect).
$Comp
L TPS62410 U?
U 1 1 5150CCD6
P 7050 5300
F 0 "U?" H 7050 5250 60  0000 C CNN
F 1 "TPS62420" H 7050 5600 60  0000 C CNN
	1    7050 5300
	1    0    0    -1  
$EndComp
Text HLabel 9650 7700 2    60   Output ~ 0
V2P5
Text HLabel 4300 5300 0    60   Output ~ 0
VRAW
Text HLabel 9650 8300 2    60   Output ~ 0
V1P1
Text HLabel 9650 8100 2    60   Output ~ 0
V1P2
Text HLabel 10000 4300 2    60   Output ~ 0
V3P3
Text HLabel 10000 6300 2    60   Output ~ 0
V1P8
$EndSCHEMATC
