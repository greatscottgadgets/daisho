EESchema Schematic File Version 2  date Tuesday, March 26, 2013 09:41:35 PM
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
Sheet 14 16
Title "Daisho Project Main Board"
Date "26 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 10700 2500 2    60   Input ~ 0
VCCIO
Connection ~ 10400 2500
Wire Wire Line
	10700 2500 10400 2500
Wire Wire Line
	10400 2500 10000 2500
Wire Wire Line
	10000 2500 9600 2500
Wire Wire Line
	9600 2500 9200 2500
Wire Wire Line
	9200 2500 8800 2500
Wire Wire Line
	8800 2500 8400 2500
Wire Wire Line
	8400 2500 7800 2500
Wire Wire Line
	7800 2500 7700 2500
Connection ~ 8400 2500
Connection ~ 10000 2500
Wire Wire Line
	10400 2500 10400 2600
Connection ~ 9200 2500
Wire Wire Line
	9600 2500 9600 2600
Connection ~ 8800 2500
Wire Wire Line
	8800 2500 8800 2600
Connection ~ 10000 3100
Wire Wire Line
	8400 3100 8800 3100
Wire Wire Line
	8800 3100 9200 3100
Wire Wire Line
	9200 3100 9600 3100
Wire Wire Line
	9600 3100 10000 3100
Wire Wire Line
	10000 3100 10400 3100
Wire Wire Line
	10400 3100 10400 3000
Connection ~ 9200 3100
Wire Wire Line
	9600 3100 9600 3000
Connection ~ 8400 3100
Wire Wire Line
	8800 3100 8800 3000
Wire Wire Line
	5900 2600 5100 2600
Wire Wire Line
	4000 9300 4000 9400
Connection ~ 4400 8700
Wire Wire Line
	3600 8700 4000 8700
Wire Wire Line
	4000 8700 4400 8700
Wire Wire Line
	4400 8800 4400 8700
Wire Wire Line
	4400 8700 4400 8500
Connection ~ 7800 2900
Wire Wire Line
	7800 2900 7700 2900
Connection ~ 7800 2700
Wire Wire Line
	7800 2700 7700 2700
Connection ~ 7800 2500
Wire Wire Line
	7800 2500 7800 2600
Wire Wire Line
	7800 2600 7800 2700
Wire Wire Line
	7800 2700 7800 2800
Wire Wire Line
	7800 2800 7800 2900
Wire Wire Line
	7800 2900 7800 3000
Wire Wire Line
	7800 3000 7700 3000
Wire Wire Line
	3600 7900 4400 7900
Wire Wire Line
	4400 7900 4800 7900
Wire Wire Line
	4800 7900 4800 8000
Wire Wire Line
	4800 8800 4800 8700
Wire Wire Line
	4800 8700 5900 8700
Wire Wire Line
	5100 9200 5900 9200
Wire Wire Line
	5100 6000 5900 6000
Wire Wire Line
	5900 3700 5100 3700
Wire Wire Line
	5100 7800 5900 7800
Wire Wire Line
	5900 8600 4800 8600
Wire Wire Line
	4800 8600 4800 8500
Wire Wire Line
	4800 9300 4800 9400
Wire Wire Line
	7800 2600 7700 2600
Connection ~ 7800 2600
Wire Wire Line
	7800 2800 7700 2800
Connection ~ 7800 2800
Wire Wire Line
	4400 9300 4400 9400
Wire Wire Line
	4400 8000 4400 7900
Connection ~ 4400 7900
Wire Wire Line
	4000 8900 4000 8700
Connection ~ 4000 8700
Wire Wire Line
	5900 2500 5100 2500
Wire Wire Line
	8400 3000 8400 3100
Wire Wire Line
	8400 3100 8400 3200
Wire Wire Line
	9200 3100 9200 3000
Connection ~ 8800 3100
Wire Wire Line
	10000 3100 10000 3000
Connection ~ 9600 3100
Wire Wire Line
	8400 2500 8400 2600
Wire Wire Line
	9200 2500 9200 2600
Wire Wire Line
	10000 2500 10000 2600
Connection ~ 9600 2500
$Comp
L GND #PWR?
U 1 1 514F7BF4
P 8400 3200
F 0 "#PWR?" H 8400 3200 30  0001 C CNN
F 1 "GND" H 8400 3130 30  0001 C CNN
	1    8400 3200
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 514F7BE2
P 10400 2800
F 0 "C?" H 10450 2900 50  0000 L CNN
F 1 "C" H 10450 2700 50  0000 L CNN
	1    10400 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 514F7BDC
P 10000 2800
F 0 "C?" H 10050 2900 50  0000 L CNN
F 1 "C" H 10050 2700 50  0000 L CNN
	1    10000 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 514F7BD9
P 9600 2800
F 0 "C?" H 9650 2900 50  0000 L CNN
F 1 "C" H 9650 2700 50  0000 L CNN
	1    9600 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 514F7BD8
P 9200 2800
F 0 "C?" H 9250 2900 50  0000 L CNN
F 1 "C" H 9250 2700 50  0000 L CNN
	1    9200 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 514F7BD5
P 8800 2800
F 0 "C?" H 8850 2900 50  0000 L CNN
F 1 "C" H 8850 2700 50  0000 L CNN
	1    8800 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 514F7BCB
P 8400 2800
F 0 "C?" H 8450 2900 50  0000 L CNN
F 1 "C" H 8450 2700 50  0000 L CNN
	1    8400 2800
	1    0    0    -1  
$EndComp
Text Label 5300 2600 0    60   ~ 0
D39
Text Label 5300 2500 0    60   ~ 0
D37
$Comp
L GND #PWR045
U 1 1 514BA518
P 4000 9400
F 0 "#PWR045" H 4000 9400 30  0001 C CNN
F 1 "GND" H 4000 9330 30  0001 C CNN
	1    4000 9400
	1    0    0    -1  
$EndComp
$Comp
L C C21
U 1 1 514BA511
P 4000 9100
F 0 "C21" H 4050 9200 50  0000 L CNN
F 1 "C" H 4050 9000 50  0000 L CNN
	1    4000 9100
	1    0    0    -1  
$EndComp
Text Notes 700  9100 0    60   ~ 0
AN592: "The VREF pin is used mainly for voltage bias and\ndoes not source or sink much current. You can create the\nvoltage with a regulator or resistor divider network."
Text Label 3700 8700 0    60   ~ 0
VREF
$Comp
L GND #PWR046
U 1 1 514BA28E
P 4400 9400
F 0 "#PWR046" H 4400 9400 30  0001 C CNN
F 1 "GND" H 4400 9330 30  0001 C CNN
	1    4400 9400
	1    0    0    -1  
$EndComp
$Comp
L R R24
U 1 1 514BA28B
P 4400 9050
F 0 "R24" V 4480 9050 50  0000 C CNN
F 1 "1K0" V 4400 9050 50  0000 C CNN
F 4 "1%" V 4300 9050 60  0000 C CNN "Tolerance"
	1    4400 9050
	-1   0    0    1   
$EndComp
$Comp
L R R23
U 1 1 514BA27F
P 4400 8250
F 0 "R23" V 4480 8250 50  0000 C CNN
F 1 "1K0" V 4400 8250 50  0000 C CNN
F 4 "1%" V 4300 8250 60  0000 C CNN "Tolerance"
	1    4400 8250
	-1   0    0    1   
$EndComp
Text Label 3800 7900 0    60   ~ 0
VCCIO
$Comp
L GND #PWR047
U 1 1 513CF83E
P 4800 9400
F 0 "#PWR047" H 4800 9400 30  0001 C CNN
F 1 "GND" H 4800 9330 30  0001 C CNN
	1    4800 9400
	1    0    0    -1  
$EndComp
$Comp
L R R22
U 1 1 513CF80F
P 4800 9050
F 0 "R22" V 4880 9050 50  0000 C CNN
F 1 "50R" V 4800 9050 50  0000 C CNN
F 4 "1%" V 4700 9050 60  0000 C CNN "Tolerance"
	1    4800 9050
	-1   0    0    1   
$EndComp
$Comp
L R R21
U 1 1 513CF7DE
P 4800 8250
F 0 "R21" V 4880 8250 50  0000 C CNN
F 1 "50R" V 4800 8250 50  0000 C CNN
F 4 "1%" V 4700 8250 60  0000 C CNN "Tolerance"
	1    4800 8250
	-1   0    0    1   
$EndComp
Text Label 5300 6000 0    60   ~ 0
VREF
Text Label 5300 7800 0    60   ~ 0
VREF
Text Label 5300 9200 0    60   ~ 0
VREF
Text Label 5300 3700 0    60   ~ 0
VREF
Text HLabel 2200 1300 0    60   BiDi ~ 0
D[41..0]
$Comp
L EP4CE30F29 U1
U 2 1 5139434C
P 6800 2200
F 0 "U1" H 6800 2250 60  0000 C CNN
F 1 "EP4CE30F29" H 6850 2150 60  0000 C CNN
	2    6800 2200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
