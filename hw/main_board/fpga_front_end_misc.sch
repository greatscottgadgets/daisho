EESchema Schematic File Version 2  date Sun 07 Apr 2013 12:55:56 PM PDT
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
LIBS:usb3_micro_ab
LIBS:usb3_esd_son50-10
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 8 15
Title "Daisho Project Main Board"
Date "7 apr 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 8400 2500
Connection ~ 9200 2500
Connection ~ 10000 2500
Connection ~ 10800 2500
Wire Wire Line
	11200 2500 11200 2600
Connection ~ 4400 2700
Wire Wire Line
	4400 2600 4400 2700
Connection ~ 10800 3200
Wire Wire Line
	8800 2500 8800 2600
Wire Wire Line
	9600 2500 9600 2600
Wire Wire Line
	10400 2500 10400 2600
Wire Wire Line
	4200 2700 5900 2700
Connection ~ 4400 3100
Wire Wire Line
	4400 3100 5900 3100
Connection ~ 4400 2900
Wire Wire Line
	5900 2900 4400 2900
Wire Wire Line
	5900 2800 4400 2800
Wire Wire Line
	4400 2800 4400 3200
Wire Wire Line
	4400 3000 5900 3000
Connection ~ 4400 3000
Connection ~ 10000 3100
Wire Wire Line
	8400 3100 10400 3100
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
	11200 3750 11200 3900
Wire Wire Line
	10800 3100 10800 3300
Connection ~ 7800 2900
Wire Wire Line
	7800 2900 7700 2900
Connection ~ 7800 2700
Wire Wire Line
	7800 2700 7700 2700
Wire Wire Line
	7800 2500 7800 3000
Wire Wire Line
	7800 3000 7700 3000
Wire Wire Line
	5100 8800 5900 8800
Wire Wire Line
	5100 5500 5900 5500
Wire Wire Line
	5900 3800 5100 3800
Wire Wire Line
	5100 7200 5900 7200
Wire Wire Line
	7800 2600 7700 2600
Connection ~ 7800 2600
Wire Wire Line
	7800 2800 7700 2800
Connection ~ 7800 2800
Wire Wire Line
	10800 3800 10800 3900
Wire Wire Line
	10800 2500 10800 2600
Wire Wire Line
	5900 2500 5100 2500
Wire Wire Line
	8400 3000 8400 3200
Wire Wire Line
	9200 3100 9200 3000
Connection ~ 8800 3100
Wire Wire Line
	10000 3000 10000 3100
Connection ~ 9600 3100
Wire Wire Line
	10000 2500 10000 2600
Wire Wire Line
	9200 2500 9200 2600
Wire Wire Line
	8400 2500 8400 2600
Wire Wire Line
	11850 3200 10800 3200
Connection ~ 11200 3200
Wire Wire Line
	4100 2000 4400 2000
Wire Wire Line
	4400 2000 4400 2100
Wire Wire Line
	11200 3000 11200 3350
Connection ~ 11200 2500
Connection ~ 10400 2500
Connection ~ 9600 2500
Connection ~ 8800 2500
Wire Wire Line
	7700 2500 11850 2500
Connection ~ 7800 2500
$Comp
L C C18
U 1 1 5161CD48
P 11200 2800
F 0 "C18" H 11250 2900 50  0000 L CNN
F 1 "C" H 11250 2700 50  0000 L CNN
	1    11200 2800
	-1   0    0    -1  
$EndComp
Text GLabel 4100 2000 0    60   Input ~ 0
V1P8
$Comp
L R R51
U 1 1 5159FA13
P 4400 2350
F 0 "R51" V 4480 2350 50  0000 C CNN
F 1 "10K" V 4400 2350 50  0000 C CNN
	1    4400 2350
	-1   0    0    -1  
$EndComp
Text Notes 8300 5150 0    60   ~ 0
nCEO, INIT_DONE, CRC_ERROR driven during configuration.
Text Notes 8300 6100 0    60   ~ 0
nCEO is open-drain during configuration.
Text Notes 8300 5400 0    60   ~ 0
INIT_DONE is open-drain during configuration, only if INIT_DONE output is enabled in bitstream.
Text Notes 8300 5500 0    60   ~ 0
CRC_ERROR is open-drain during configuration, only if bitstream CRC error detection is enabled.
Text Notes 8300 6400 0    60   ~ 0
Avoid use of VREF pins as I/O, as they have higher pin capacitance,\nand therefore are slow down both input and output signals.
Text HLabel 4200 2700 0    60   Output ~ 0
FPGA_CONF_DONE
Text Label 4700 2800 0    60   ~ 0
FPGA_MSEL0
Text Label 4700 2900 0    60   ~ 0
FPGA_MSEL1
Text Label 4700 3000 0    60   ~ 0
FPGA_MSEL2
Text Label 4700 3100 0    60   ~ 0
FPGA_MSEL3
$Comp
L GND #PWR031
U 1 1 51576C91
P 4400 3200
F 0 "#PWR031" H 4400 3200 30  0001 C CNN
F 1 "GND" H 4400 3130 30  0001 C CNN
	1    4400 3200
	1    0    0    -1  
$EndComp
Text Notes 4300 2950 2    60   ~ 0
Only PS and JTAG programming modes supported.\nPS uses standard power-on reset (POR) delay of 50 to 200 ms.\nPS interface voltage determined by Bank 1 VCCIO.
Text HLabel 11850 2500 2    60   Input ~ 0
VCCIO
$Comp
L GND #PWR032
U 1 1 514F7BF4
P 8400 3200
F 0 "#PWR032" H 8400 3200 30  0001 C CNN
F 1 "GND" H 8400 3130 30  0001 C CNN
	1    8400 3200
	1    0    0    -1  
$EndComp
$Comp
L C C95
U 1 1 514F7BE2
P 10400 2800
F 0 "C95" H 10450 2900 50  0000 L CNN
F 1 "C" H 10450 2700 50  0000 L CNN
	1    10400 2800
	1    0    0    -1  
$EndComp
$Comp
L C C94
U 1 1 514F7BDC
P 10000 2800
F 0 "C94" H 10050 2900 50  0000 L CNN
F 1 "C" H 10050 2700 50  0000 L CNN
	1    10000 2800
	1    0    0    -1  
$EndComp
$Comp
L C C93
U 1 1 514F7BD9
P 9600 2800
F 0 "C93" H 9650 2900 50  0000 L CNN
F 1 "C" H 9650 2700 50  0000 L CNN
	1    9600 2800
	1    0    0    -1  
$EndComp
$Comp
L C C92
U 1 1 514F7BD8
P 9200 2800
F 0 "C92" H 9250 2900 50  0000 L CNN
F 1 "C" H 9250 2700 50  0000 L CNN
	1    9200 2800
	1    0    0    -1  
$EndComp
$Comp
L C C91
U 1 1 514F7BD5
P 8800 2800
F 0 "C91" H 8850 2900 50  0000 L CNN
F 1 "C" H 8850 2700 50  0000 L CNN
	1    8800 2800
	1    0    0    -1  
$EndComp
$Comp
L C C90
U 1 1 514F7BCB
P 8400 2800
F 0 "C90" H 8450 2900 50  0000 L CNN
F 1 "C" H 8450 2700 50  0000 L CNN
	1    8400 2800
	1    0    0    -1  
$EndComp
Text Label 5300 2600 0    60   ~ 0
D39
Text Label 5300 2500 0    60   ~ 0
D37
$Comp
L GND #PWR033
U 1 1 514BA518
P 11200 3900
F 0 "#PWR033" H 11200 3900 30  0001 C CNN
F 1 "GND" H 11200 3830 30  0001 C CNN
	1    11200 3900
	1    0    0    -1  
$EndComp
$Comp
L C C21
U 1 1 514BA511
P 11200 3550
F 0 "C21" H 11250 3650 50  0000 L CNN
F 1 "C" H 11250 3450 50  0000 L CNN
	1    11200 3550
	-1   0    0    -1  
$EndComp
Text Notes 11650 3550 0    60   ~ 0
AN592: "The VREF pin is used mainly for voltage bias and\ndoes not source or sink much current. You can create the\nvoltage with a regulator or resistor divider network."
Text Label 11350 3200 0    60   ~ 0
VREF
$Comp
L GND #PWR034
U 1 1 514BA28E
P 10800 3900
F 0 "#PWR034" H 10800 3900 30  0001 C CNN
F 1 "GND" H 10800 3830 30  0001 C CNN
	1    10800 3900
	1    0    0    -1  
$EndComp
$Comp
L R R24
U 1 1 514BA28B
P 10800 3550
F 0 "R24" V 10880 3550 50  0000 C CNN
F 1 "1K0" V 10800 3550 50  0000 C CNN
F 4 "1%" V 10700 3550 60  0000 C CNN "Tolerance"
	1    10800 3550
	-1   0    0    1   
$EndComp
$Comp
L R R23
U 1 1 514BA27F
P 10800 2850
F 0 "R23" V 10880 2850 50  0000 C CNN
F 1 "1K0" V 10800 2850 50  0000 C CNN
F 4 "1%" V 10700 2850 60  0000 C CNN "Tolerance"
	1    10800 2850
	-1   0    0    1   
$EndComp
Text Label 5300 5500 0    60   ~ 0
VREF
Text Label 5300 7200 0    60   ~ 0
VREF
Text Label 5300 8800 0    60   ~ 0
VREF
Text Label 5300 3800 0    60   ~ 0
VREF
Text HLabel 2200 1300 0    60   BiDi ~ 0
D[41..0]
$Comp
L EP4CE30F29 U1
U 6 1 5139434C
P 6800 2200
F 0 "U1" H 6800 2250 60  0000 C CNN
F 1 "EP4CE30F29" H 6850 2150 60  0000 C CNN
	6    6800 2200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
