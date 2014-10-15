EESchema Schematic File Version 2  date Tue 15 Oct 2013 05:45:56 PM EDT
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
LIBS:samtec_qsh_090-d
LIBS:hole
LIBS:gige_fe-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
Title "Daisho Project RS232 Front-End Board"
Date "15 oct 2013"
Rev "1.0"
Comp ""
Comment1 "Copyright © 2013 Benjamin Vernoux"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L SAMTEC_QSH-090-D J9991
U 1 1 51D6425B
P 3050 2600
F 0 "J9991" H 3050 2650 60  0000 C CNN
F 1 "SAMTEC_QSH-090-D" H 3100 2550 60  0000 C CNN
F 3 "https://www.samtec.com/technical-specifications/Default.aspx?SeriesMaster=QSH" H 3050 2600 60  0001 C CNN
F 4 "QSH-090-01-F-D-A" H 3050 2600 60  0001 C CNN "ManufacturerPartNumber"
F 5 "http://www.digikey.com/product-detail/en/QSH-090-01-F-D-A/QSH-090-01-F-D-A-ND/2664439" H 3050 2600 60  0001 C CNN "DigiKey"
F 6 "http://components.arrow.com/part/detail/29558048S6264918N1004" H 3050 2600 60  0001 C CNN "Arrow"
	1    3050 2600
	1    0    0    -1  
$EndComp
$Comp
L SAMTEC_QSH-090-D J9991
U 2 1 51D64261
P 6250 2600
F 0 "J9991" H 6250 2650 60  0000 C CNN
F 1 "SAMTEC_QSH-090-D" H 6300 2550 60  0000 C CNN
	2    6250 2600
	1    0    0    -1  
$EndComp
$Comp
L SAMTEC_QSH-090-D J9991
U 3 1 51D64267
P 9350 2600
F 0 "J9991" H 9350 2650 60  0000 C CNN
F 1 "SAMTEC_QSH-090-D" H 9400 2550 60  0000 C CNN
	3    9350 2600
	1    0    0    -1  
$EndComp
$Comp
L 24C16 U9991
U 1 1 51DE64DC
P 2600 1550
F 0 "U9991" H 2750 1900 60  0000 C CNN
F 1 "24C08" H 2800 1200 60  0000 C CNN
F 2 "SO8" H 2600 1550 60  0000 C CNN
F 3 "http://www.onsemi.com/pub_link/Collateral/CAT24C08-D.PDF" H 2600 1550 60  0001 C CNN
F 4 "http://www.digikey.com/product-detail/en/CAT24C08WI-GT3/CAT24C08WI-GT3CT-ND" H 2600 1550 60  0001 C CNN "Field7"
	1    2600 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR01
U 1 1 51DE6697
P 2900 6450
F 0 "#PWR01" H 2900 6450 30  0001 C CNN
F 1 "GND" H 2900 6380 30  0001 C CNN
	1    2900 6450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 51DE6A1A
P 1800 1700
F 0 "#PWR02" H 1800 1700 30  0001 C CNN
F 1 "GND" H 1800 1630 30  0001 C CNN
	1    1800 1700
	1    0    0    -1  
$EndComp
$Comp
L R R9991
U 1 1 51DDE1CA
P 5100 1250
F 0 "R9991" V 5180 1250 50  0000 C CNN
F 1 "10k" V 5100 1250 50  0000 C CNN
F 4 "Stackpole" H 5100 1250 60  0001 C CNN "Manufacturer"
F 5 "RES 10K OHM 1/10W 5% 0603 SMD" H 5100 1250 60  0001 C CNN "Description"
F 6 "RMCF0603JT10K0" H 5100 1250 60  0001 C CNN "Part Number"
F 7 "~" V 5200 1050 60  0000 C CNN "Note"
	1    5100 1250
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR03
U 1 1 51DDE55A
P 6100 6450
F 0 "#PWR03" H 6100 6450 30  0001 C CNN
F 1 "GND" H 6100 6380 30  0001 C CNN
	1    6100 6450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 51DDE568
P 9200 6450
F 0 "#PWR04" H 9200 6450 30  0001 C CNN
F 1 "GND" H 9200 6380 30  0001 C CNN
	1    9200 6450
	1    0    0    -1  
$EndComp
Text Label 3450 1650 0    60   ~ 0
FE_I2C_SCL
Text Label 3450 1750 0    60   ~ 0
FE_I2C_SDA
Text Label 2250 2900 2    60   ~ 0
FE_I2C_SDA
Text Label 2250 3000 2    60   ~ 0
FE_I2C_SCL
$Comp
L GND #PWR05
U 1 1 51DDF418
P 2600 2000
F 0 "#PWR05" H 2600 2000 30  0001 C CNN
F 1 "GND" H 2600 1930 30  0001 C CNN
	1    2600 2000
	1    0    0    -1  
$EndComp
Text GLabel 1800 4100 0    39   Input ~ 0
CD-A-TTL
Text GLabel 1800 4900 0    39   Input ~ 0
DSR-A-TTL
Text GLabel 1800 4800 0    39   Input ~ 0
RXD-A-TTL
Text GLabel 1800 4700 0    39   Input ~ 0
CTS-A-TTL
Text GLabel 1800 4500 0    39   Input ~ 0
RI-A-TTL
Text GLabel 1850 3600 0    39   Input ~ 0
!INVALID-A-TTL
Text GLabel 1850 3800 0    39   Input ~ 0
FORCEON-A-TTL
Text GLabel 1850 3700 0    39   Input ~ 0
!FORCEOFF-A-TTL
Text GLabel 1800 4400 0    39   Input ~ 0
RTS-A-TTL
Text GLabel 1800 4300 0    39   Input ~ 0
TXD-A-TTL
Text GLabel 1800 4200 0    39   Input ~ 0
DTR-A-TTL
Text GLabel 4300 4100 2    39   Input ~ 0
CD-B-TTL
Text GLabel 4300 4900 2    39   Input ~ 0
DSR-B-TTL
Text GLabel 4300 4800 2    39   Input ~ 0
RXD-B-TTL
Text GLabel 4300 4700 2    39   Input ~ 0
CTS-B-TTL
Text GLabel 4300 4500 2    39   Input ~ 0
RI-B-TTL
Text GLabel 4300 4400 2    39   Input ~ 0
RTS-B-TTL
Text GLabel 4300 4300 2    39   Input ~ 0
TXD-B-TTL
Text GLabel 4300 4200 2    39   Input ~ 0
DTR-B-TTL
Text GLabel 4250 3700 2    39   Input ~ 0
MBAUD-B-TTL
Text GLabel 4250 3600 2    39   Input ~ 0
!EN-B-TTL
Text GLabel 4250 3500 2    39   Input ~ 0
!SHDN-B-TTL
Text Label 3900 2900 0    60   ~ 0
VALT_FE
Text Label 3900 3100 0    60   ~ 0
FE_CLKSRC
Text Label 3900 3200 0    60   ~ 0
FE_CLK_P1
Text Label 3900 3300 0    60   ~ 0
FE_CLK_N1
Text Label 3900 3400 0    60   ~ 0
VRAW_SW
Text Label 3900 3500 0    60   ~ 0
FE_A1
Text Label 3900 3600 0    60   ~ 0
FE_A3
Text Label 3900 3700 0    60   ~ 0
FE_A5
Text Label 2200 3800 2    60   ~ 0
FE_A6
Text Label 2200 3700 2    60   ~ 0
FE_A4
Text Label 2200 3600 2    60   ~ 0
FE_A2
Text Label 2200 3500 2    60   ~ 0
FE_A0
Text Label 2200 4500 2    60   ~ 0
FE_A18
Text Label 2200 4400 2    60   ~ 0
FE_A16
Text Label 2200 4300 2    60   ~ 0
FE_A14
Text Label 2200 4200 2    60   ~ 0
FE_A12
Text Label 2200 4100 2    60   ~ 0
FE_A10
Text Label 3900 4100 0    60   ~ 0
FE_A11
Text Label 3900 4200 0    60   ~ 0
FE_A13
Text Label 3900 4300 0    60   ~ 0
FE_A15
Text Label 3900 4400 0    60   ~ 0
FE_A17
Text Label 3900 4500 0    60   ~ 0
FE_A19
Text Label 3900 4700 0    60   ~ 0
FE_A21
Text Label 3900 4800 0    60   ~ 0
FE_A23
Text Label 3900 4900 0    60   ~ 0
FE_A25
Text Label 2200 4900 2    60   ~ 0
FE_A24
Text Label 2200 4800 2    60   ~ 0
FE_A22
Text Label 2200 4700 2    60   ~ 0
FE_A20
Text Label 2200 3300 2    60   ~ 0
FE_CLK_N0
Text Label 2200 3200 2    60   ~ 0
FE_CLK_P0
Text Notes 1950 700  0    60   ~ 0
Identification EEPROM:\nRead by main board MCU, \nto identify type of Front End ...
Text GLabel 5550 950  0    60   Input ~ 0
FE_I2C_VCC
NoConn ~ 3650 3100
NoConn ~ 3650 3200
NoConn ~ 3650 3300
NoConn ~ 2450 3300
NoConn ~ 2450 3200
Text GLabel 1550 2950 0    60   Input ~ 0
FE_I2C_VCC
Text GLabel 2550 1000 0    60   Input ~ 0
FE_I2C_VCC
Text GLabel 1550 3250 0    60   Input ~ 0
3V3A
Text Label 1550 3400 2    60   ~ 0
FE_VCCIO_A
Text Label 1550 3100 2    60   ~ 0
V3P3D
Text Notes 4950 800  0    60   ~ 0
I2C EEPROM Write Protect\nEnabled by default
$Comp
L CONN_2 P9991
U 1 1 51E2E274
P 5450 1550
F 0 "P9991" V 5400 1550 40  0000 C CNN
F 1 "CONN_2" V 5500 1550 40  0000 C CNN
	1    5450 1550
	1    0    0    -1  
$EndComp
$Comp
L R R9992
U 1 1 51E2ED78
P 4450 1450
F 0 "R9992" V 4530 1450 50  0000 C CNN
F 1 "10k" V 4450 1450 50  0000 C CNN
F 4 "Stackpole" H 4450 1450 60  0001 C CNN "Manufacturer"
F 5 "RES 10K OHM 1/10W 5% 0603 SMD" H 4450 1450 60  0001 C CNN "Description"
F 6 "RMCF0603JT10K0" H 4450 1450 60  0001 C CNN "Part Number"
F 7 "~" V 4550 1250 60  0000 C CNN "Note"
	1    4450 1450
	0    -1   1    0   
$EndComp
Text Notes 5700 1550 0    60   ~ 0
No Jumper by default\n(Write Protect mode)
Wire Wire Line
	2450 2900 2250 2900
Wire Wire Line
	2450 3000 2250 3000
Wire Wire Line
	2900 6200 2900 6450
Wire Wire Line
	3000 6200 3000 6350
Wire Wire Line
	2900 6350 3200 6350
Connection ~ 2900 6350
Wire Wire Line
	3100 6350 3100 6200
Connection ~ 3000 6350
Wire Wire Line
	3200 6350 3200 6200
Connection ~ 3100 6350
Wire Wire Line
	1900 1350 1800 1350
Wire Wire Line
	1800 1350 1800 1700
Wire Wire Line
	1900 1450 1800 1450
Connection ~ 1800 1450
Wire Wire Line
	1900 1550 1800 1550
Connection ~ 1800 1550
Wire Wire Line
	6100 6200 6100 6450
Wire Wire Line
	6200 6200 6200 6350
Wire Wire Line
	6100 6350 6400 6350
Connection ~ 6100 6350
Wire Wire Line
	6300 6350 6300 6200
Connection ~ 6200 6350
Wire Wire Line
	6400 6350 6400 6200
Connection ~ 6300 6350
Wire Wire Line
	9200 6200 9200 6450
Wire Wire Line
	9300 6200 9300 6350
Wire Wire Line
	9200 6350 9500 6350
Connection ~ 9200 6350
Wire Wire Line
	9400 6350 9400 6200
Connection ~ 9300 6350
Wire Wire Line
	9500 6350 9500 6200
Connection ~ 9400 6350
Wire Wire Line
	3300 1650 3450 1650
Wire Wire Line
	3300 1750 3450 1750
Wire Wire Line
	2600 1850 2600 2000
Wire Wire Line
	1550 3100 2450 3100
Wire Wire Line
	3650 2900 3900 2900
Wire Wire Line
	3650 3400 3900 3400
Wire Wire Line
	3650 3500 4250 3500
Wire Wire Line
	3650 3600 4250 3600
Wire Wire Line
	3650 3700 4250 3700
Wire Wire Line
	3650 4100 4300 4100
Wire Wire Line
	3650 4200 4300 4200
Wire Wire Line
	3650 4300 4300 4300
Wire Wire Line
	3650 4400 4300 4400
Wire Wire Line
	3650 4500 4300 4500
Wire Wire Line
	3650 4700 4300 4700
Wire Wire Line
	3650 4800 4300 4800
Wire Wire Line
	3650 4900 4300 4900
Wire Wire Line
	1550 3400 2450 3400
Wire Wire Line
	1850 3500 2450 3500
Wire Wire Line
	1850 3600 2450 3600
Wire Wire Line
	1850 3700 2450 3700
Wire Wire Line
	1800 4100 2450 4100
Wire Wire Line
	1800 4200 2450 4200
Wire Wire Line
	1800 4300 2450 4300
Wire Wire Line
	1800 4400 2450 4400
Wire Wire Line
	1800 4500 2450 4500
Wire Wire Line
	1800 4700 2450 4700
Wire Wire Line
	1800 4800 2450 4800
Wire Wire Line
	1800 4900 2450 4900
Wire Wire Line
	3650 3000 3750 3000
Wire Wire Line
	3750 3000 3750 2900
Connection ~ 3750 2900
Wire Wire Line
	3750 3400 3750 5200
Connection ~ 3750 4000
Connection ~ 3750 3400
Wire Wire Line
	3750 4000 3650 4000
Connection ~ 3750 4600
Wire Wire Line
	3750 4600 3650 4600
Wire Wire Line
	3750 5200 3650 5200
Wire Wire Line
	2450 4000 2350 4000
Wire Wire Line
	2350 3400 2350 5200
Connection ~ 2350 3400
Wire Wire Line
	2350 4600 2450 4600
Connection ~ 2350 4000
Wire Wire Line
	2350 5200 2450 5200
Connection ~ 2350 4600
Wire Wire Line
	1550 2950 1650 2950
Wire Wire Line
	1650 2950 1650 3100
Connection ~ 1650 3100
Wire Wire Line
	2550 1000 2600 1000
Wire Wire Line
	2600 1000 2600 1250
Wire Wire Line
	1550 3250 1650 3250
Wire Wire Line
	1650 3250 1650 3400
Connection ~ 1650 3400
Wire Wire Line
	2450 3800 1850 3800
Wire Wire Line
	5350 1250 5650 1250
Wire Wire Line
	5650 1250 5650 950 
Wire Wire Line
	5650 950  5550 950 
Wire Wire Line
	4850 1250 4800 1250
Wire Wire Line
	4800 1250 4800 1450
Connection ~ 4800 1450
$Comp
L GND #PWR06
U 1 1 51E2F31D
P 5050 1850
F 0 "#PWR06" H 5050 1850 30  0001 C CNN
F 1 "GND" H 5050 1780 30  0001 C CNN
	1    5050 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 1650 5050 1650
Wire Wire Line
	5050 1650 5050 1850
Text GLabel 3850 950  2    60   Input ~ 0
FE_I2C_EEPROM_WP
Wire Wire Line
	3300 1450 4200 1450
Wire Wire Line
	3850 950  3700 950 
Wire Wire Line
	3700 950  3700 1450
Connection ~ 3700 1450
Wire Wire Line
	4700 1450 5100 1450
Text GLabel 1850 3500 0    60   Input ~ 0
FE_I2C_EEPROM_WP
NoConn ~ 5650 2900
NoConn ~ 5650 3000
NoConn ~ 5650 3100
NoConn ~ 5650 3200
NoConn ~ 5650 3300
NoConn ~ 5650 3500
NoConn ~ 5650 3600
NoConn ~ 5650 3700
NoConn ~ 5650 3800
NoConn ~ 5650 3900
NoConn ~ 5650 4100
NoConn ~ 5650 4200
NoConn ~ 5650 4300
NoConn ~ 5650 4400
NoConn ~ 5650 4500
NoConn ~ 5650 4700
NoConn ~ 5650 4800
NoConn ~ 5650 4900
NoConn ~ 5650 5000
NoConn ~ 5650 5100
NoConn ~ 5650 5300
NoConn ~ 5650 5400
NoConn ~ 5650 5500
NoConn ~ 5650 5600
NoConn ~ 5650 5700
NoConn ~ 5650 5800
NoConn ~ 6850 2900
NoConn ~ 6850 3000
NoConn ~ 6850 3100
NoConn ~ 6850 3200
NoConn ~ 6850 3300
NoConn ~ 6850 3500
NoConn ~ 6850 3600
NoConn ~ 6850 3700
NoConn ~ 6850 3800
NoConn ~ 6850 3900
NoConn ~ 6850 4100
NoConn ~ 6850 4200
NoConn ~ 6850 4300
NoConn ~ 6850 4400
NoConn ~ 6850 4500
NoConn ~ 6850 4900
NoConn ~ 6850 4800
NoConn ~ 6850 4700
NoConn ~ 6850 5000
NoConn ~ 6850 5100
NoConn ~ 6850 5300
NoConn ~ 6850 5400
NoConn ~ 6850 5500
NoConn ~ 6850 5600
NoConn ~ 6850 5700
NoConn ~ 6850 5800
Text GLabel 10550 3800 2    39   Input ~ 0
MBAUD-D-TTL
Text GLabel 10550 3700 2    39   Input ~ 0
!EN-D-TTL
Text GLabel 10550 3600 2    39   Input ~ 0
!SHDN-D-TTL
Text Label 10200 3600 0    60   ~ 0
FE_C13
Text Label 10200 3700 0    60   ~ 0
FE_C15
Text Label 10200 3800 0    60   ~ 0
FE_C17
Text Label 10200 4100 0    60   ~ 0
FE_C21
Text Label 10200 4200 0    60   ~ 0
FE_C23
Text Label 10200 4300 0    60   ~ 0
FE_C25
Text Label 10200 4400 0    60   ~ 0
FE_C27
Text Label 10200 4500 0    60   ~ 0
FE_C29
Text Label 10200 4700 0    60   ~ 0
FE_C31
Text Label 10200 4800 0    60   ~ 0
FE_C33
Text Label 10200 4900 0    60   ~ 0
FE_C35
Wire Wire Line
	9950 3600 10550 3600
Wire Wire Line
	9950 3700 10550 3700
Wire Wire Line
	9950 3800 10550 3800
Wire Wire Line
	9950 4100 10600 4100
Wire Wire Line
	9950 4200 10600 4200
Wire Wire Line
	9950 4300 10600 4300
Wire Wire Line
	9950 4400 10600 4400
Wire Wire Line
	9950 4500 10600 4500
Wire Wire Line
	9950 4700 10600 4700
Wire Wire Line
	9950 4800 10600 4800
Wire Wire Line
	9950 4900 10600 4900
Text GLabel 8150 3600 0    39   Input ~ 0
!INVALID-C-TTL
Text GLabel 8150 3800 0    39   Input ~ 0
FORCEON-C-TTL
Text GLabel 8150 3700 0    39   Input ~ 0
!FORCEOFF-C-TTL
Text Label 8500 3800 2    60   ~ 0
FE_C16
Text Label 8500 3700 2    60   ~ 0
FE_C14
Text Label 8500 3600 2    60   ~ 0
FE_C12
Text Label 8500 4400 2    60   ~ 0
FE_C26
Text Label 8500 4300 2    60   ~ 0
FE_C24
Text Label 8500 4200 2    60   ~ 0
FE_C22
Text Label 8500 4100 2    60   ~ 0
FE_C20
Text Label 8500 4900 2    60   ~ 0
FE_C34
Text Label 8500 4800 2    60   ~ 0
FE_C32
Text Label 8500 4700 2    60   ~ 0
FE_C30
Wire Wire Line
	8150 3600 8750 3600
Wire Wire Line
	8150 3700 8750 3700
NoConn ~ 9950 2900
NoConn ~ 9950 3000
NoConn ~ 9950 3100
NoConn ~ 9950 3200
NoConn ~ 9950 3300
NoConn ~ 8750 2900
NoConn ~ 8750 3000
NoConn ~ 8750 3100
NoConn ~ 8750 3200
NoConn ~ 8750 3300
NoConn ~ 8750 3500
NoConn ~ 9950 5500
NoConn ~ 9950 5600
NoConn ~ 9950 5700
NoConn ~ 9950 5800
NoConn ~ 9950 5400
NoConn ~ 8750 5800
NoConn ~ 8750 5700
NoConn ~ 8750 5600
NoConn ~ 8750 5500
NoConn ~ 8750 5400
NoConn ~ 8750 5300
NoConn ~ 8750 5100
NoConn ~ 8750 5000
NoConn ~ 3650 3800
NoConn ~ 3650 3900
NoConn ~ 2450 3900
NoConn ~ 2450 5000
NoConn ~ 2450 5100
NoConn ~ 2450 5300
NoConn ~ 2450 5400
NoConn ~ 2450 5500
NoConn ~ 2450 5600
NoConn ~ 2450 5700
NoConn ~ 2450 5800
NoConn ~ 3650 5000
NoConn ~ 3650 5100
NoConn ~ 3650 5300
NoConn ~ 3650 5400
NoConn ~ 3650 5500
NoConn ~ 3650 5600
NoConn ~ 3650 5700
NoConn ~ 3650 5800
NoConn ~ 9950 5100
NoConn ~ 9950 3900
NoConn ~ 8750 3900
Wire Wire Line
	8150 3800 8750 3800
Text GLabel 8300 3250 0    60   Input ~ 0
3V3C
Text Label 8300 3400 2    60   ~ 0
FE_VCCIO_C
Wire Wire Line
	8300 3250 8400 3250
Wire Wire Line
	8400 3250 8400 3400
Connection ~ 8400 3400
Wire Wire Line
	8650 5200 8750 5200
Wire Wire Line
	8650 3400 8650 5200
Wire Wire Line
	8650 4600 8750 4600
Wire Wire Line
	8750 4000 8650 4000
Connection ~ 8650 4600
Connection ~ 8650 3400
Connection ~ 8650 4000
Text GLabel 10600 4100 2    39   Input ~ 0
CD-D-TTL
Text GLabel 10600 4500 2    39   Input ~ 0
RI-D-TTL
Text GLabel 10600 4400 2    39   Input ~ 0
RTS-D-TTL
Text GLabel 10600 4300 2    39   Input ~ 0
TXD-D-TTL
Text GLabel 10600 4200 2    39   Input ~ 0
DTR-D-TTL
Text GLabel 10600 4900 2    39   Input ~ 0
DSR-D-TTL
Text GLabel 10600 4800 2    39   Input ~ 0
RXD-D-TTL
Text GLabel 10600 4700 2    39   Input ~ 0
CTS-D-TTL
Text GLabel 8100 4100 0    39   Input ~ 0
CD-C-TTL
Text GLabel 8100 4900 0    39   Input ~ 0
DSR-C-TTL
Text GLabel 8100 4800 0    39   Input ~ 0
RXD-C-TTL
Text GLabel 8100 4700 0    39   Input ~ 0
CTS-C-TTL
Text GLabel 8100 4500 0    39   Input ~ 0
RI-C-TTL
Text GLabel 8100 4400 0    39   Input ~ 0
RTS-C-TTL
Text GLabel 8100 4300 0    39   Input ~ 0
TXD-C-TTL
Text GLabel 8100 4200 0    39   Input ~ 0
DTR-C-TTL
Wire Wire Line
	8100 4100 8750 4100
Wire Wire Line
	8100 4200 8750 4200
Wire Wire Line
	8100 4300 8750 4300
Wire Wire Line
	8100 4400 8750 4400
Wire Wire Line
	8100 4500 8750 4500
Wire Wire Line
	8100 4700 8750 4700
Wire Wire Line
	8100 4800 8750 4800
Wire Wire Line
	8100 4900 8750 4900
Text Label 10100 3400 0    60   ~ 0
FE_VCCIO_C
Wire Wire Line
	9950 3400 10950 3400
Wire Wire Line
	10050 5200 9950 5200
Wire Wire Line
	10050 3400 10050 5200
Wire Wire Line
	10050 4000 9950 4000
Connection ~ 10050 3400
Connection ~ 10050 4000
NoConn ~ 9950 5300
Text GLabel 10700 3250 2    60   Input ~ 0
3V3C
Wire Wire Line
	10700 3250 10650 3250
Wire Wire Line
	10650 3250 10650 3400
Connection ~ 10650 3400
NoConn ~ 9950 3500
Text Label 8500 4500 2    60   ~ 0
FE_C28
Wire Wire Line
	9950 4600 10050 4600
Connection ~ 10050 4600
NoConn ~ 9950 5000
Text GLabel 5350 3250 0    60   Input ~ 0
3V3B
Text Label 5350 3400 2    60   ~ 0
FE_VCCIO_B
Wire Wire Line
	5350 3250 5450 3250
Wire Wire Line
	5450 3250 5450 3400
Connection ~ 5450 3400
Wire Wire Line
	5350 3400 5650 3400
Wire Wire Line
	5550 5200 5650 5200
Wire Wire Line
	5550 3400 5550 5200
Wire Wire Line
	5550 4600 5650 4600
Wire Wire Line
	5550 4000 5650 4000
Connection ~ 5550 4600
Connection ~ 5550 3400
Connection ~ 5550 4000
Text GLabel 7150 3250 2    60   Input ~ 0
3V3B
Text Label 7150 3400 0    60   ~ 0
FE_VCCIO_B
Wire Wire Line
	7150 3250 7050 3250
Wire Wire Line
	7050 3250 7050 3400
Connection ~ 7050 3400
Wire Wire Line
	7150 3400 6850 3400
Wire Wire Line
	8300 3400 8750 3400
Wire Wire Line
	6850 4000 6950 4000
Wire Wire Line
	6950 3400 6950 5200
Connection ~ 6950 3400
Wire Wire Line
	6950 4600 6850 4600
Connection ~ 6950 4000
Wire Wire Line
	6950 5200 6850 5200
Connection ~ 6950 4600
$Comp
L CONN_2 P9992
U 1 1 51E459D6
P 7100 2350
F 0 "P9992" V 7050 2350 40  0000 C CNN
F 1 "CONN_2" V 7150 2350 40  0000 C CNN
	1    7100 2350
	0    1    1    0   
$EndComp
Text GLabel 6850 1850 0    60   Input ~ 0
3V3B
$Comp
L GND #PWR07
U 1 1 51E459DD
P 7450 1900
F 0 "#PWR07" H 7450 1900 30  0001 C CNN
F 1 "GND" H 7450 1830 30  0001 C CNN
	1    7450 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 1850 7000 1850
Wire Wire Line
	7000 1850 7000 2000
Wire Wire Line
	7200 2000 7200 1850
Wire Wire Line
	7200 1850 7450 1850
Wire Wire Line
	7450 1850 7450 1900
$EndSCHEMATC
