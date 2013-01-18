EESchema Schematic File Version 2  date Mon 07 Jan 2013 07:07:13 PM EST
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:adm3307e
LIBS:adm3310e
LIBS:ftdi4232h
LIBS:gsg-microusb
LIBS:tc1262
LIBS:rs232-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
Title ""
Date "8 jan 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 750  750  0    60   ~ 0
PORT A: DB9 M - DTE, connect to target\nPORT B: DB9 F - DCE, replicates target\nPORT C: DTE\nPORT D: DCE
$Sheet
S 1350 1550 1700 950 
U 50CFE713
F0 "Pair A-B" 50
F1 "Pair-AB.sch" 50
$EndSheet
$Sheet
S 3600 1550 1800 950 
U 50D0908B
F0 "Pair C-D" 50
F1 "Pair-CD.sch" 50
$EndSheet
$Comp
L CONN_20X2 P8
U 1 1 50D6892C
P 4900 3850
F 0 "P8" H 4900 4900 60  0000 C CNN
F 1 "CONN_20X2" V 4900 3850 50  0000 C CNN
F 4 "TE Connectivity" H 4900 3850 60  0001 C CNN "Manufacturer"
F 5 "103308-8" H 4900 3850 60  0001 C CNN "Part#"
F 6 "CONN HEADER LOPRO STR 40POS GOLD" H 4900 3850 60  0001 C CNN "Description"
F 7 "http://www.digikey.com/product-detail/en/103308-8/A26279-ND/289259" H 4900 3850 60  0001 C CNN "Field7"
	1    4900 3850
	0    -1   -1   0   
$EndComp
Text GLabel 4250 3350 1    39   Input ~ 0
RXD-A-TTL
Text GLabel 4050 3350 1    39   Input ~ 0
TXD-A-TTL
Text GLabel 4050 4350 3    39   Input ~ 0
RTS-A-TTL
Text GLabel 3950 4350 3    39   Input ~ 0
DTR-A-TTL
Text GLabel 4250 4350 3    39   Input ~ 0
DSR-A-TTL
Text GLabel 4150 4350 3    39   Input ~ 0
CTS-A-TTL
Text GLabel 4150 3350 1    39   Input ~ 0
RI-A-TTL
Text GLabel 3950 3350 1    39   Input ~ 0
CD-A-TTL
Text GLabel 4350 4350 3    39   Input ~ 0
RXD-B-TTL
Text GLabel 4650 4350 3    39   Input ~ 0
TXD-B-TTL
Text GLabel 4650 3350 1    39   Input ~ 0
RTS-B-TTL
Text GLabel 4750 3350 1    39   Input ~ 0
DTR-B-TTL
Text GLabel 4350 3350 1    39   Input ~ 0
DSR-B-TTL
Text GLabel 4550 3350 1    39   Input ~ 0
CTS-B-TTL
Text GLabel 4550 4350 3    39   Input ~ 0
RI-B-TTL
Text GLabel 4750 4350 3    39   Input ~ 0
CD-B-TTL
Text GLabel 5850 4350 3    39   Input ~ 0
RXD-C-TTL
Text GLabel 5650 4350 3    39   Input ~ 0
TXD-C-TTL
Text GLabel 5650 3350 1    39   Input ~ 0
RTS-C-TTL
Text GLabel 5550 3350 1    39   Input ~ 0
DTR-C-TTL
Text GLabel 5850 3350 1    39   Input ~ 0
DSR-C-TTL
Text GLabel 5750 3350 1    39   Input ~ 0
CTS-C-TTL
Text GLabel 5750 4350 3    39   Input ~ 0
RI-C-TTL
Text GLabel 5550 4350 3    39   Input ~ 0
CD-C-TTL
Text GLabel 5050 3350 1    39   Input ~ 0
RXD-D-TTL
Text GLabel 5250 3350 1    39   Input ~ 0
TXD-D-TTL
Text GLabel 5250 4350 3    39   Input ~ 0
RTS-D-TTL
Text GLabel 5450 4350 3    39   Input ~ 0
DTR-D-TTL
Text GLabel 5050 4350 3    39   Input ~ 0
DSR-D-TTL
Text GLabel 5150 4350 3    39   Input ~ 0
CTS-D-TTL
Text GLabel 5150 3350 1    39   Input ~ 0
RI-D-TTL
Text GLabel 5450 3350 1    39   Input ~ 0
CD-D-TTL
$Comp
L +3.3V #PWR01
U 1 1 50D68B07
P 5350 4350
F 0 "#PWR01" H 5350 4310 30  0001 C CNN
F 1 "+3.3V" H 5350 4460 30  0000 C CNN
	1    5350 4350
	-1   0    0    1   
$EndComp
$Comp
L +5V #PWR02
U 1 1 50D68B16
P 4450 4350
F 0 "#PWR02" H 4450 4440 20  0001 C CNN
F 1 "+5V" H 4450 4440 30  0000 C CNN
	1    4450 4350
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR03
U 1 1 50D68B2F
P 5350 3350
F 0 "#PWR03" H 5350 3350 30  0001 C CNN
F 1 "GND" H 5350 3280 30  0001 C CNN
	1    5350 3350
	-1   0    0    1   
$EndComp
Text GLabel 6450 3550 1    39   Input ~ 0
SD-ALL-TTL
$Comp
L +3.3V #PWR04
U 1 1 50D75DDE
P 6450 4150
F 0 "#PWR04" H 6450 4110 30  0001 C CNN
F 1 "+3.3V" H 6450 4300 30  0000 C CNN
	1    6450 4150
	-1   0    0    1   
$EndComp
$Comp
L R R3
U 1 1 50D75DE6
P 6450 3850
F 0 "R3" V 6530 3850 50  0000 C CNN
F 1 "10K" V 6450 3850 50  0000 C CNN
	1    6450 3850
	1    0    0    -1  
$EndComp
Text GLabel 4850 3350 1    39   Input ~ 0
SD-ALL-TTL
Text Notes 6600 4200 1    39   ~ 0
Pull SD high to default-disable
$Comp
L GND #PWR05
U 1 1 50D763E1
P 4450 3350
F 0 "#PWR05" H 4450 3350 30  0001 C CNN
F 1 "GND" H 4450 3280 30  0001 C CNN
	1    4450 3350
	-1   0    0    1   
$EndComp
Wire Wire Line
	6450 4100 6450 4150
Wire Wire Line
	6450 3600 6450 3550
Wire Wire Line
	4450 4250 4450 4350
Wire Wire Line
	5350 4250 5350 4350
Wire Wire Line
	5350 3350 5350 3450
Wire Wire Line
	4450 3350 4450 3450
Wire Wire Line
	3950 3350 3950 3450
Wire Wire Line
	3950 4250 3950 4350
Wire Wire Line
	4050 3350 4050 3450
Wire Wire Line
	4050 4250 4050 4350
Wire Wire Line
	4150 3350 4150 3450
Wire Wire Line
	4150 4250 4150 4350
Wire Wire Line
	4250 4250 4250 4350
Wire Wire Line
	4250 3450 4250 3350
Wire Wire Line
	4350 3350 4350 3450
Wire Wire Line
	4350 4250 4350 4350
Wire Wire Line
	4550 4250 4550 4350
Wire Wire Line
	4550 3350 4550 3450
Wire Wire Line
	4650 3350 4650 3450
Wire Wire Line
	4650 4250 4650 4350
Wire Wire Line
	4750 4250 4750 4350
Wire Wire Line
	4750 3350 4750 3450
Wire Wire Line
	4850 3350 4850 3450
Wire Wire Line
	5150 3350 5150 3450
Wire Wire Line
	5250 3350 5250 3450
Wire Wire Line
	5250 4250 5250 4350
Wire Wire Line
	5150 4250 5150 4350
Wire Wire Line
	5050 3350 5050 3450
Wire Wire Line
	5050 4250 5050 4350
Wire Wire Line
	5450 4250 5450 4350
Wire Wire Line
	5550 4250 5550 4350
Wire Wire Line
	5650 4250 5650 4350
Wire Wire Line
	5750 4250 5750 4350
Wire Wire Line
	5850 4250 5850 4350
Wire Wire Line
	5850 3350 5850 3450
Wire Wire Line
	5750 3350 5750 3450
Wire Wire Line
	5650 3350 5650 3450
Wire Wire Line
	5550 3350 5550 3450
Wire Wire Line
	5450 3350 5450 3450
NoConn ~ 4850 4250
NoConn ~ 4950 4250
NoConn ~ 4950 3450
$EndSCHEMATC
