EESchema Schematic File Version 2  date Sunday, March 10, 2013 08:24:38 PM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 3 15
Title "Daisho Project Main Board"
Date "11 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text Label 5550 7900 0    60   ~ 0
VCCIO
Wire Wire Line
	5400 7900 6100 7900
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
$Comp
L GND #PWR010
U 1 1 513CF83E
P 6100 9400
F 0 "#PWR010" H 6100 9400 30  0001 C CNN
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
Text HLabel 2200 1500 0    60   Input ~ 0
VREF
Text HLabel 2200 1300 0    60   BiDi ~ 0
D[39..0]
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
