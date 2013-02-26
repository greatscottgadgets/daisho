EESchema Schematic File Version 2  date Tuesday, February 26, 2013 02:12:30 PM
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
Sheet 8 11
Title ""
Date "26 feb 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 7200 4150
Wire Wire Line
	7200 3850 7200 4350
Wire Wire Line
	7200 4350 7450 4350
Wire Wire Line
	4500 3100 4500 3350
Wire Wire Line
	4500 3350 4750 3350
Connection ~ 7200 3950
Wire Wire Line
	7450 3950 7200 3950
Wire Wire Line
	7200 4150 7450 4150
Wire Wire Line
	7450 4850 7200 4850
Wire Wire Line
	7200 4850 7200 4650
Wire Wire Line
	7450 3350 7200 3350
Wire Wire Line
	7200 3350 7200 3150
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
L +1.2V #PWR013
U 1 1 510B222D
P 4500 3100
F 0 "#PWR013" H 4500 3240 20  0001 C CNN
F 1 "+1.2V" H 4500 3210 30  0000 C CNN
	1    4500 3100
	1    0    0    -1  
$EndComp
Text HLabel 7450 4850 2    60   Output ~ 0
USB_3V3A
$Comp
L +3.3V #PWR014
U 1 1 510B220A
P 7200 4650
F 0 "#PWR014" H 7200 4610 30  0001 C CNN
F 1 "+3.3V" H 7200 4760 30  0000 C CNN
	1    7200 4650
	1    0    0    -1  
$EndComp
Text HLabel 7450 4150 2    60   Output ~ 0
USB_1V8D
Text HLabel 7450 3950 2    60   Output ~ 0
USB_1V8A
$Comp
L +1.8V #PWR015
U 1 1 510B21CA
P 7200 3850
F 0 "#PWR015" H 7200 3990 20  0001 C CNN
F 1 "+1.8V" H 7200 3960 30  0000 C CNN
	1    7200 3850
	1    0    0    -1  
$EndComp
$EndSCHEMATC
