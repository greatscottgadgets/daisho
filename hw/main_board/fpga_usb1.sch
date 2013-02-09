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
Sheet 6 10
Title ""
Date "9 feb 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	1900 1700 8900 1700
Wire Bus Line
	1900 1500 9100 1500
Wire Bus Line
	1900 1300 9300 1300
Wire Bus Line
	1900 1900 8700 1900
Text HLabel 1900 1900 0    60   Output ~ 0
USB1_TX_DATAK[1..0]
Text HLabel 1900 1700 0    60   Output ~ 0
USB1_TX_DATA[15..0]
Text HLabel 1900 1500 0    60   Input ~ 0
USB1_RX_DATAK[1..0]
Text HLabel 1900 1300 0    60   Input ~ 0
USB1_RX_DATA[15..0]
$Comp
L EP4CE30F29 U1
U 2 1 510AF156
P 11300 2300
F 0 "U1" H 11300 2350 60  0000 C CNN
F 1 "EP4CE30F29" H 11350 2250 60  0000 C CNN
	2    11300 2300
	1    0    0    -1  
$EndComp
$Comp
L EP4CE30F29 U1
U 1 1 510AF152
P 5900 2300
F 0 "U1" H 5900 2350 60  0000 C CNN
F 1 "EP4CE30F29" H 5950 2250 60  0000 C CNN
	1    5900 2300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
