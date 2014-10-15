EESchema Schematic File Version 2  date Wed 23 Jan 2013 04:24:48 PM EST
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
LIBS:ksz9021gq
LIBS:fdt434p
LIBS:fbead
LIBS:mic5207-25YM5
LIBS:belfuse-0826-1x1t-m1-f
LIBS:terasic-hsmc
LIBS:gig-e-cache
EELAYER 27 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 3
Title ""
Date "23 jan 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 700  750  2350 1700
U 50EDF97F
F0 "GigE Phy0" 50
F1 "gig-e-phy0.sch" 50
$EndSheet
$Comp
L TERASIC-HSMC JP101
U 1 1 50F0CF77
P 7850 6600
F 0 "JP101" H 7500 11700 60  0000 C CNN
F 1 "TERASIC-HSMC" H 7550 11800 60  0000 C CNN
	1    7850 6600
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR01
U 1 1 50F0D654
P 9850 5500
F 0 "#PWR01" H 9850 5500 30  0001 C CNN
F 1 "GND" H 9850 5430 30  0001 C CNN
	1    9850 5500
	-1   0    0    1   
$EndComp
Wire Wire Line
	9850 5500 9850 5700
Wire Wire Line
	9950 5700 9950 5600
Wire Wire Line
	9850 5600 10150 5600
Connection ~ 9850 5600
Wire Wire Line
	10050 5600 10050 5700
Connection ~ 9950 5600
Wire Wire Line
	10150 5600 10150 5700
Connection ~ 10050 5600
$Comp
L GND #PWR02
U 1 1 50F0D670
P 9850 7650
F 0 "#PWR02" H 9850 7650 30  0001 C CNN
F 1 "GND" H 9850 7580 30  0001 C CNN
	1    9850 7650
	1    0    0    -1  
$EndComp
Wire Wire Line
	9850 7500 9850 7650
Wire Wire Line
	9950 7500 9950 7600
Wire Wire Line
	9850 7600 10150 7600
Connection ~ 9850 7600
Wire Wire Line
	10050 7600 10050 7500
Connection ~ 9950 7600
Wire Wire Line
	10150 7600 10150 7500
Connection ~ 10050 7600
$Comp
L GND #PWR03
U 1 1 50F0D8DE
P 6050 5500
F 0 "#PWR03" H 6050 5500 30  0001 C CNN
F 1 "GND" H 6050 5430 30  0001 C CNN
	1    6050 5500
	-1   0    0    1   
$EndComp
Wire Wire Line
	6050 5500 6050 5700
Wire Wire Line
	6150 5700 6150 5600
Wire Wire Line
	6050 5600 6350 5600
Connection ~ 6050 5600
Wire Wire Line
	6250 5600 6250 5700
Connection ~ 6150 5600
Wire Wire Line
	6350 5600 6350 5700
Connection ~ 6250 5600
$Comp
L +3.3V #PWR04
U 1 1 50F0DB6E
P 6350 7800
F 0 "#PWR04" H 6350 7760 30  0001 C CNN
F 1 "+3.3V" H 6350 7910 30  0000 C CNN
	1    6350 7800
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6350 7800 13350 7800
Wire Wire Line
	6850 7800 6850 7500
Wire Wire Line
	7150 7800 7150 7500
Connection ~ 6850 7800
Wire Wire Line
	7450 7800 7450 7500
Connection ~ 7150 7800
Wire Wire Line
	7750 7800 7750 7500
Connection ~ 7450 7800
Wire Wire Line
	8050 7800 8050 7500
Connection ~ 7750 7800
Wire Wire Line
	8350 7800 8350 7500
Connection ~ 8050 7800
Wire Wire Line
	8650 7800 8650 7500
Connection ~ 8350 7800
Wire Wire Line
	8950 7800 8950 7500
Connection ~ 8650 7800
Wire Wire Line
	9250 7800 9250 7500
Connection ~ 8950 7800
Wire Wire Line
	9550 7800 9550 7500
Connection ~ 9250 7800
Wire Wire Line
	10650 7800 10650 7500
Connection ~ 9550 7800
Wire Wire Line
	10950 7800 10950 7500
Connection ~ 10650 7800
Wire Wire Line
	11250 7800 11250 7500
Connection ~ 10950 7800
Wire Wire Line
	11550 7800 11550 7500
Connection ~ 11250 7800
Wire Wire Line
	11850 7800 11850 7500
Connection ~ 11550 7800
Wire Wire Line
	12150 7800 12150 7500
Connection ~ 11850 7800
Wire Wire Line
	12450 7800 12450 7500
Connection ~ 12150 7800
Wire Wire Line
	12750 7800 12750 7500
Connection ~ 12450 7800
Wire Wire Line
	13050 7800 13050 7500
Connection ~ 12750 7800
Wire Wire Line
	13350 7800 13350 7500
Connection ~ 13050 7800
NoConn ~ 13350 5700
NoConn ~ 13050 5700
NoConn ~ 12750 5700
NoConn ~ 12450 5700
NoConn ~ 12150 5700
NoConn ~ 11850 5700
NoConn ~ 11550 5700
NoConn ~ 11250 5700
NoConn ~ 10950 5700
NoConn ~ 10650 5700
NoConn ~ 9550 5700
NoConn ~ 9250 5700
NoConn ~ 8950 5700
NoConn ~ 8650 5700
NoConn ~ 8350 5700
NoConn ~ 8050 5700
NoConn ~ 7750 5700
NoConn ~ 7450 5700
NoConn ~ 7150 5700
NoConn ~ 6850 5700
NoConn ~ 5100 5700
NoConn ~ 5000 5700
NoConn ~ 4800 5700
NoConn ~ 4700 5700
NoConn ~ 4500 5700
NoConn ~ 4400 5700
NoConn ~ 4200 5700
NoConn ~ 4100 5700
NoConn ~ 3900 5700
NoConn ~ 3800 5700
NoConn ~ 3600 5700
NoConn ~ 3500 5700
NoConn ~ 3300 5700
NoConn ~ 3200 5700
NoConn ~ 3000 5700
NoConn ~ 2900 5700
NoConn ~ 2900 7500
NoConn ~ 3000 7500
NoConn ~ 3200 7500
NoConn ~ 3300 7500
NoConn ~ 3500 7500
NoConn ~ 3600 7500
NoConn ~ 3800 7500
NoConn ~ 3900 7500
NoConn ~ 4100 7500
NoConn ~ 4200 7500
NoConn ~ 4400 7500
NoConn ~ 4500 7500
NoConn ~ 4700 7500
NoConn ~ 4800 7500
NoConn ~ 5000 7500
NoConn ~ 5100 7500
NoConn ~ 9350 7500
NoConn ~ 9450 7500
NoConn ~ 9350 5700
NoConn ~ 9450 5700
NoConn ~ 13150 5700
NoConn ~ 13250 5700
NoConn ~ 13250 7500
NoConn ~ 13150 7500
NoConn ~ 5300 7500
NoConn ~ 5400 7500
NoConn ~ 5600 7500
NoConn ~ 5700 7500
NoConn ~ 5700 5700
NoConn ~ 5600 5700
NoConn ~ 5400 5700
NoConn ~ 5300 5700
$Sheet
S 3500 750  2450 1700
U 50F2029A
F0 "GigE Phy1" 50
F1 "gig-e-phy1.sch" 50
$EndSheet
Text GLabel 12050 7950 3    39   Input ~ 0
PHY0_GM_MDC
Text GLabel 12250 7950 3    39   Input ~ 0
PHY0_GM_MIO
Text GLabel 11950 7950 3    39   Input ~ 0
PHY0_GM_RX_CLK
Text GLabel 11750 7950 3    39   Input ~ 0
PHY0_GM_RX_ERR
Text GLabel 12850 5250 1    39   Input ~ 0
PHY0_GM_RXDV
Text GLabel 11450 5250 1    39   Input ~ 0
PHY0_GM_RXD7
Text GLabel 11650 5250 1    39   Input ~ 0
PHY0_GM_RXD6
Text GLabel 11750 5250 1    39   Input ~ 0
PHY0_GM_RXD5
Text GLabel 11950 5250 1    39   Input ~ 0
PHY0_GM_RXD4
Text GLabel 12050 5250 1    39   Input ~ 0
PHY0_GM_RXD3
Text GLabel 12250 5250 1    39   Input ~ 0
PHY0_GM_RXD2
Text GLabel 12350 5250 1    39   Input ~ 0
PHY0_GM_RXD1
Text GLabel 12550 5250 1    39   Input ~ 0
PHY0_GM_RXD0
Text GLabel 11350 5250 1    39   Input ~ 0
PHY0_GM_TX_EN
Text GLabel 11650 7950 3    39   Input ~ 0
PHY0_GM_GTK_CLK
Text GLabel 11150 5250 1    39   Input ~ 0
PHY0_GM_TX_ER
Text GLabel 11450 7950 3    39   Input ~ 0
PHY0_GM_TXD7
Text GLabel 11350 7950 3    39   Input ~ 0
PHY0_GM_TXD6
Text GLabel 11150 7950 3    39   Input ~ 0
PHY0_GM_TXD5
Text GLabel 11050 7950 3    39   Input ~ 0
PHY0_GM_TXD4
Text GLabel 10850 7950 3    39   Input ~ 0
PHY0_GM_TXD3
Text GLabel 10750 7950 3    39   Input ~ 0
PHY0_GM_TXD2
Text GLabel 10550 7950 3    39   Input ~ 0
PHY0_GM_TXD1
Text GLabel 10450 7950 3    39   Input ~ 0
PHY0_GM_TXD0
Text GLabel 12350 7950 3    39   Input ~ 0
PHY0_CLK125_NDO
Text GLabel 11050 5250 1    39   Input ~ 0
PHY0_PHYADDR0
Text GLabel 10850 5250 1    39   Input ~ 0
PHY0_PHYADDR1
Text GLabel 10750 5250 1    39   Input ~ 0
PHY0_PHYADDR2
Text GLabel 10550 5250 1    39   Input ~ 0
PHY0_PHYADDR3
Text GLabel 10450 5250 1    39   Input ~ 0
PHY0_PHYADDR4
Text GLabel 12950 5250 1    39   Input ~ 0
PHY0_TX_CLK
Text GLabel 12950 7950 3    39   Input ~ 0
PHY0_HW_RST
Text GLabel 8450 7900 3    39   Input ~ 0
PHY1_GM_MDC
Text GLabel 8550 7900 3    39   Input ~ 0
PHY1_GM_MIO
Text GLabel 8150 7900 3    39   Input ~ 0
PHY1_GM_RX_CLK
Text GLabel 7950 7900 3    39   Input ~ 0
PHY1_GM_RX_ERR
Text GLabel 7850 7900 3    39   Input ~ 0
PHY1_GM_RXDV
Text GLabel 7550 5300 1    39   Input ~ 0
PHY1_GM_RXD7
Text GLabel 7650 5300 1    39   Input ~ 0
PHY1_GM_RXD6
Text GLabel 7850 5300 1    39   Input ~ 0
PHY1_GM_RXD5
Text GLabel 7950 5300 1    39   Input ~ 0
PHY1_GM_RXD4
Text GLabel 8150 5300 1    39   Input ~ 0
PHY1_GM_RXD3
Text GLabel 8250 5300 1    39   Input ~ 0
PHY1_GM_RXD2
Text GLabel 8450 5300 1    39   Input ~ 0
PHY1_GM_RXD1
Text GLabel 8550 5300 1    39   Input ~ 0
PHY1_GM_RXD0
Text GLabel 9150 5300 1    39   Input ~ 0
PHY1_GM_TX_EN
Text GLabel 9050 5300 1    39   Input ~ 0
PHY1_GM_GTK_CLK
Text GLabel 7350 5300 1    39   Input ~ 0
PHY1_GM_TX_ER
Text GLabel 7650 7900 3    39   Input ~ 0
PHY1_GM_TXD7
Text GLabel 7550 7900 3    39   Input ~ 0
PHY1_GM_TXD6
Text GLabel 7350 7900 3    39   Input ~ 0
PHY1_GM_TXD5
Text GLabel 7250 7900 3    39   Input ~ 0
PHY1_GM_TXD4
Text GLabel 7050 7900 3    39   Input ~ 0
PHY1_GM_TXD3
Text GLabel 6950 7900 3    39   Input ~ 0
PHY1_GM_TXD2
Text GLabel 6750 7900 3    39   Input ~ 0
PHY1_GM_TXD1
Text GLabel 6650 7900 3    39   Input ~ 0
PHY1_GM_TXD0
Text GLabel 8750 5300 1    39   Input ~ 0
PHY1_CLK125_NDO
Text GLabel 7250 5300 1    39   Input ~ 0
PHY1_PHYADDR0
Text GLabel 7050 5300 1    39   Input ~ 0
PHY1_PHYADDR1
Text GLabel 6950 5300 1    39   Input ~ 0
PHY1_PHYADDR2
Text GLabel 6750 5300 1    39   Input ~ 0
PHY1_PHYADDR3
Text GLabel 6650 5300 1    39   Input ~ 0
PHY1_PHYADDR4
Text GLabel 8850 7900 3    39   Input ~ 0
PHY1_TX_CLK
Text GLabel 8850 5300 1    39   Input ~ 0
PHY1_HW_RST
Wire Wire Line
	10450 5700 10450 5250
Wire Wire Line
	10550 5700 10550 5250
Wire Wire Line
	10750 5250 10750 5700
Wire Wire Line
	10850 5700 10850 5250
Wire Wire Line
	11050 5250 11050 5700
Wire Wire Line
	11150 5700 11150 5250
Wire Wire Line
	11350 5250 11350 5700
Wire Wire Line
	11450 5700 11450 5250
Wire Wire Line
	11650 5250 11650 5700
Wire Wire Line
	11750 5700 11750 5250
Wire Wire Line
	11950 5250 11950 5700
Wire Wire Line
	12050 5700 12050 5250
Wire Wire Line
	12250 5250 12250 5700
Wire Wire Line
	12350 5700 12350 5250
Wire Wire Line
	12550 5250 12550 5700
Wire Wire Line
	12650 5700 12650 5250
Wire Wire Line
	12850 5250 12850 5700
Wire Wire Line
	12950 5700 12950 5250
Wire Wire Line
	10450 7500 10450 7950
Wire Wire Line
	10550 7950 10550 7500
Wire Wire Line
	10750 7500 10750 7950
Wire Wire Line
	10850 7950 10850 7500
Wire Wire Line
	11050 7500 11050 7950
Wire Wire Line
	11150 7950 11150 7500
Wire Wire Line
	11350 7500 11350 7950
Wire Wire Line
	11450 7950 11450 7500
Wire Wire Line
	11650 7500 11650 7950
Wire Wire Line
	11750 7950 11750 7500
Wire Wire Line
	11950 7500 11950 7950
Wire Wire Line
	12050 7950 12050 7500
Wire Wire Line
	12250 7500 12250 7950
Wire Wire Line
	12350 7950 12350 7500
Wire Wire Line
	12650 7950 12650 7500
Wire Wire Line
	8850 5300 8850 5700
Wire Wire Line
	8750 5700 8750 5300
Wire Wire Line
	8550 5300 8550 5700
Wire Wire Line
	8450 5700 8450 5300
Wire Wire Line
	8250 5300 8250 5700
Wire Wire Line
	8150 5700 8150 5300
Wire Wire Line
	7950 5300 7950 5700
Wire Wire Line
	7850 5700 7850 5300
Wire Wire Line
	7650 5300 7650 5700
Wire Wire Line
	7550 5700 7550 5300
Wire Wire Line
	7350 5300 7350 5700
Wire Wire Line
	7250 5700 7250 5300
Wire Wire Line
	7050 5300 7050 5700
Wire Wire Line
	6950 5700 6950 5300
Wire Wire Line
	6750 5300 6750 5700
Wire Wire Line
	6650 5700 6650 5300
Wire Wire Line
	9050 7500 9050 7900
Wire Wire Line
	8850 7900 8850 7500
Wire Wire Line
	8750 7500 8750 7900
Wire Wire Line
	8550 7900 8550 7500
Wire Wire Line
	8450 7500 8450 7900
Wire Wire Line
	8250 7900 8250 7500
Wire Wire Line
	8150 7500 8150 7900
Wire Wire Line
	7950 7900 7950 7500
Wire Wire Line
	7850 7500 7850 7900
Wire Wire Line
	7650 7900 7650 7500
Wire Wire Line
	7550 7500 7550 7900
Wire Wire Line
	7350 7900 7350 7500
Wire Wire Line
	7250 7500 7250 7900
Wire Wire Line
	7050 7900 7050 7500
Wire Wire Line
	6950 7500 6950 7900
Wire Wire Line
	6750 7900 6750 7500
Wire Wire Line
	6650 7500 6650 7900
Text GLabel 12650 7950 3    39   Input ~ 0
PHY0_COL
Text GLabel 8750 7900 3    39   Input ~ 0
PHY1_COL
Text GLabel 8250 7900 3    39   Input ~ 0
PHY1_CRS
Wire Wire Line
	9050 5300 9050 5700
Text GLabel 12650 5250 1    39   Input ~ 0
PHY0_CRS
Wire Wire Line
	12850 7950 12850 7500
Wire Wire Line
	9150 5300 9150 5700
Text GLabel 9050 7900 3    39   Input ~ 0
PHY1_INT_N
Text GLabel 12850 7950 3    39   Input ~ 0
PHY0_INT_N
NoConn ~ 12550 7500
Wire Wire Line
	12950 7500 12950 7950
NoConn ~ 9150 7500
$EndSCHEMATC
