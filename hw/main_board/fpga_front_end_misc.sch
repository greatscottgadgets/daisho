EESchema Schematic File Version 2  date Saturday, March 23, 2013 10:44:52 PM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 13 16
Title "Daisho Project Main Board"
Date "24 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text Label 6600 2600 0    60   ~ 0
D39
Text Label 6600 2500 0    60   ~ 0
D37
Wire Wire Line
	7200 2600 6400 2600
Wire Wire Line
	5300 9300 5300 9400
Connection ~ 5700 8700
Wire Wire Line
	4900 8700 5700 8700
Wire Wire Line
	5700 8800 5700 8500
Connection ~ 9100 2900
Wire Wire Line
	9100 2900 9000 2900
Connection ~ 9100 2700
Wire Wire Line
	9100 2700 9000 2700
Connection ~ 9100 2500
Wire Wire Line
	9100 2500 9100 3000
Wire Wire Line
	9100 3000 9000 3000
Wire Wire Line
	4900 7900 6100 7900
Wire Wire Line
	6100 7900 6100 8000
Wire Wire Line
	6100 8800 6100 8700
Wire Wire Line
	6100 8700 7200 8700
Wire Wire Line
	6400 9200 7200 9200
Wire Wire Line
	6400 6000 7200 6000
Wire Wire Line
	7200 3700 6400 3700
Wire Wire Line
	6400 7800 7200 7800
Wire Wire Line
	7200 8600 6100 8600
Wire Wire Line
	6100 8600 6100 8500
Wire Wire Line
	6100 9300 6100 9400
Wire Wire Line
	9700 2500 9000 2500
Wire Wire Line
	9100 2600 9000 2600
Connection ~ 9100 2600
Wire Wire Line
	9100 2800 9000 2800
Connection ~ 9100 2800
Wire Wire Line
	5700 9300 5700 9400
Wire Wire Line
	5700 8000 5700 7900
Connection ~ 5700 7900
Wire Wire Line
	5300 8700 5300 8900
Connection ~ 5300 8700
Wire Wire Line
	7200 2500 6400 2500
$Comp
L GND #PWR045
U 1 1 514BA518
P 5300 9400
F 0 "#PWR045" H 5300 9400 30  0001 C CNN
F 1 "GND" H 5300 9330 30  0001 C CNN
	1    5300 9400
	1    0    0    -1  
$EndComp
$Comp
L C C21
U 1 1 514BA511
P 5300 9100
F 0 "C21" H 5350 9200 50  0000 L CNN
F 1 "C" H 5350 9000 50  0000 L CNN
	1    5300 9100
	1    0    0    -1  
$EndComp
Text Notes 2000 9100 0    60   ~ 0
AN592: "The VREF pin is used mainly for voltage bias and\ndoes not source or sink much current. You can create the\nvoltage with a regulator or resistor divider network."
Text Label 5000 8700 0    60   ~ 0
VREF
$Comp
L GND #PWR046
U 1 1 514BA28E
P 5700 9400
F 0 "#PWR046" H 5700 9400 30  0001 C CNN
F 1 "GND" H 5700 9330 30  0001 C CNN
	1    5700 9400
	1    0    0    -1  
$EndComp
$Comp
L R R24
U 1 1 514BA28B
P 5700 9050
F 0 "R24" V 5780 9050 50  0000 C CNN
F 1 "1K0" V 5700 9050 50  0000 C CNN
F 4 "1%" V 5600 9050 60  0000 C CNN "Tolerance"
	1    5700 9050
	-1   0    0    1   
$EndComp
$Comp
L R R23
U 1 1 514BA27F
P 5700 8250
F 0 "R23" V 5780 8250 50  0000 C CNN
F 1 "1K0" V 5700 8250 50  0000 C CNN
F 4 "1%" V 5600 8250 60  0000 C CNN "Tolerance"
	1    5700 8250
	-1   0    0    1   
$EndComp
Text Label 9250 2500 0    60   ~ 0
VCCIO
Text HLabel 2200 1700 0    60   Input ~ 0
VCCIO
Text Label 5100 7900 0    60   ~ 0
VCCIO
$Comp
L GND #PWR047
U 1 1 513CF83E
P 6100 9400
F 0 "#PWR047" H 6100 9400 30  0001 C CNN
F 1 "GND" H 6100 9330 30  0001 C CNN
	1    6100 9400
	1    0    0    -1  
$EndComp
$Comp
L R R22
U 1 1 513CF80F
P 6100 9050
F 0 "R22" V 6180 9050 50  0000 C CNN
F 1 "50R" V 6100 9050 50  0000 C CNN
F 4 "1%" V 6000 9050 60  0000 C CNN "Tolerance"
	1    6100 9050
	-1   0    0    1   
$EndComp
$Comp
L R R21
U 1 1 513CF7DE
P 6100 8250
F 0 "R21" V 6180 8250 50  0000 C CNN
F 1 "50R" V 6100 8250 50  0000 C CNN
F 4 "1%" V 6000 8250 60  0000 C CNN "Tolerance"
	1    6100 8250
	-1   0    0    1   
$EndComp
Text Label 6600 6000 0    60   ~ 0
VREF
Text Label 6600 7800 0    60   ~ 0
VREF
Text Label 6600 9200 0    60   ~ 0
VREF
Text Label 6600 3700 0    60   ~ 0
VREF
Text HLabel 2200 1300 0    60   BiDi ~ 0
D[41..0]
$Comp
L EP4CE30F29 U1
U 2 1 5139434C
P 8100 2200
F 0 "U1" H 8100 2250 60  0000 C CNN
F 1 "EP4CE30F29" H 8150 2150 60  0000 C CNN
	2    8100 2200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
