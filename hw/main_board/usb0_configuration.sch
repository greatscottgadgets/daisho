EESchema Schematic File Version 2  date Monday, March 18, 2013 05:10:50 PM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 10 15
Title "Daisho Project Main Board"
Date "19 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text Label 7300 9100 0    60   ~ 0
OUT_ENABLE
Text Label 7300 9000 0    60   ~ 0
RESET#
Text Label 7700 7800 0    60   ~ 0
XO
Text Label 7700 7700 0    60   ~ 0
XI
Text Label 7450 8100 0    60   ~ 0
VSSOSC
Connection ~ 7350 8100
Wire Wire Line
	7350 8100 7350 7150
Wire Wire Line
	7350 7150 7150 7150
Wire Wire Line
	6900 7400 6900 7600
Wire Wire Line
	6900 6800 6900 6700
Wire Wire Line
	6400 7600 6400 6700
Wire Wire Line
	6900 8000 6900 8100
Wire Bus Line
	6900 3300 6900 3100
Wire Bus Line
	6900 3100 6700 3100
Wire Wire Line
	6700 2700 8000 2700
Wire Wire Line
	6700 3000 8000 3000
Wire Wire Line
	6700 4100 8000 4100
Wire Wire Line
	6700 6100 8000 6100
Wire Wire Line
	6700 5800 8000 5800
Wire Wire Line
	6700 4700 8000 4700
Wire Bus Line
	6900 4900 6900 4800
Wire Bus Line
	6900 4800 6700 4800
Wire Wire Line
	8000 5400 7000 5400
Wire Wire Line
	8000 5200 7000 5200
Wire Wire Line
	8000 4900 7000 4900
Wire Wire Line
	8000 3700 7000 3700
Wire Wire Line
	8000 3400 7000 3400
Wire Wire Line
	8000 3200 7000 3200
Wire Wire Line
	8000 9300 7900 9300
Connection ~ 7100 9100
Wire Wire Line
	7100 9200 7100 9100
Connection ~ 6900 9000
Wire Wire Line
	6800 9000 8000 9000
Wire Wire Line
	6900 9200 6900 9000
Wire Wire Line
	6900 9800 6900 9700
Wire Wire Line
	8000 9100 6800 9100
Wire Wire Line
	7100 9700 7100 9800
Wire Wire Line
	7400 9300 7300 9300
Wire Wire Line
	7300 9300 7300 9500
Wire Wire Line
	7300 9500 7900 9500
Wire Wire Line
	7900 9500 7900 9400
Wire Wire Line
	7900 9400 8000 9400
Wire Wire Line
	8000 3300 7000 3300
Wire Wire Line
	8000 3600 7000 3600
Wire Wire Line
	8000 5000 7000 5000
Wire Wire Line
	8000 5300 7000 5300
Wire Bus Line
	6700 5100 6900 5100
Wire Bus Line
	6900 5100 6900 5300
Wire Wire Line
	6700 5600 8000 5600
Wire Wire Line
	6700 5900 8000 5900
Wire Wire Line
	6700 6300 8000 6300
Wire Wire Line
	6700 3900 8000 3900
Wire Wire Line
	6700 2800 8000 2800
Wire Wire Line
	6700 2500 8000 2500
Wire Bus Line
	6700 3500 6900 3500
Wire Bus Line
	6900 3500 6900 3600
Wire Wire Line
	8000 8100 6400 8100
Wire Wire Line
	6400 8100 6400 8000
Connection ~ 6900 8100
Wire Wire Line
	6400 6700 7600 6700
Wire Wire Line
	7600 6700 7600 7700
Wire Wire Line
	7600 7700 8000 7700
Connection ~ 6900 6700
Wire Wire Line
	8000 7800 7200 7800
Wire Wire Line
	7200 7800 7200 7500
Wire Wire Line
	7200 7500 6900 7500
Connection ~ 6900 7500
Wire Wire Line
	7150 7050 7250 7050
Wire Wire Line
	7250 7050 7250 7150
Connection ~ 7250 7150
$Comp
L QUARTZCMS4_GROUND X1
U 1 1 514782E6
P 6900 7100
F 0 "X1" H 6900 7300 60  0000 C CNN
F 1 "40M" H 6900 7400 60  0000 C CNN
F 4 "50ppm" H 6900 7100 60  0001 C CNN "Tolerance"
F 5 "20pF" H 6900 7100 60  0001 C CNN "Cload"
	1    6900 7100
	0    -1   -1   0   
$EndComp
Text Notes 6350 7200 2    60   ~ 0
Also support reference clock from Si535x with jumper?
Text Notes 6350 7050 2    60   ~ 0
18pF CL is OK, according to datasheet max/min specs.
Text Notes 7800 7050 0    60   ~ 0
Errata claims SSC and non-40MHz crystals are not compatible.\nUse 40MHz crystal if SSC is required.
$Comp
L C C171
U 1 1 514607C2
P 6900 7800
F 0 "C171" H 6950 7900 50  0000 L CNN
F 1 "C" H 6950 7700 50  0000 L CNN
	1    6900 7800
	1    0    0    -1  
$EndComp
$Comp
L C C170
U 1 1 514607BA
P 6400 7800
F 0 "C170" H 6450 7900 50  0000 L CNN
F 1 "C" H 6450 7700 50  0000 L CNN
	1    6400 7800
	1    0    0    -1  
$EndComp
NoConn ~ 9800 9400
NoConn ~ 9800 9300
NoConn ~ 9800 9200
NoConn ~ 9800 9100
NoConn ~ 9800 9000
NoConn ~ 9800 8900
NoConn ~ 9800 8800
NoConn ~ 8000 7900
Text Notes 7850 8400 2    60   ~ 0
Test points here?\nOr just wire to FPGA?\nA small waste of FPGA pins and routing,\nand an extra routing challenge.
Entry Wire Line
	6900 3600 7000 3700
Entry Wire Line
	6900 3500 7000 3600
Entry Wire Line
	6900 3300 7000 3400
Entry Wire Line
	6900 3200 7000 3300
Entry Wire Line
	6900 3100 7000 3200
Entry Wire Line
	6900 5300 7000 5400
Entry Wire Line
	6900 5200 7000 5300
Entry Wire Line
	6900 5100 7000 5200
Entry Wire Line
	6900 4900 7000 5000
Entry Wire Line
	6900 4800 7000 4900
Text HLabel 6700 6300 0    60   Input ~ 0
ELAS_BUF_MODE
Text HLabel 6700 6100 0    60   Input ~ 0
RATE
Text HLabel 6700 5900 0    60   Input ~ 0
RX_TERMINATION
Text HLabel 6700 5800 0    60   Input ~ 0
RX_POLARITY
Text HLabel 6700 5600 0    60   Input ~ 0
TX_SWING
Text HLabel 6700 5100 0    60   Input ~ 0
TX_MARGIN[2..0]
Text HLabel 6700 4800 0    60   Input ~ 0
TX_DEEMPH[1..0]
Text HLabel 6700 4700 0    60   Input ~ 0
TX_ONESZEROS
Text Label 7100 6300 0    60   ~ 0
ELAS_BUF_MODE
Text Label 7100 6100 0    60   ~ 0
RATE
Text Label 7100 5900 0    60   ~ 0
RX_TERMINATION
Text Label 7100 5800 0    60   ~ 0
RX_POLARITY
Text Label 7100 5600 0    60   ~ 0
TX_SWING
Text Label 7100 5400 0    60   ~ 0
TX_MARGIN0
Text Label 7100 5300 0    60   ~ 0
TX_MARGIN1
Text Label 7100 5200 0    60   ~ 0
TX_MARGIN2
Text Label 7100 5000 0    60   ~ 0
TX_DEEMPH0
Text Label 7100 4900 0    60   ~ 0
TX_DEEMPH1
Text Label 7100 4700 0    60   ~ 0
TX_ONESZEROS
Text Label 7100 4100 0    60   ~ 0
PWRPRESENT
Text Label 7100 3900 0    60   ~ 0
PHY_STATUS
Text Label 7100 3700 0    60   ~ 0
POWER_DOWN0
Text Label 7100 3600 0    60   ~ 0
POWER_DOWN1
Text Label 7100 3400 0    60   ~ 0
RX_STATUS0
Text Label 7100 3300 0    60   ~ 0
RX_STATUS1
Text Label 7100 3200 0    60   ~ 0
RX_STATUS2
Text Label 7100 3000 0    60   ~ 0
RX_ELECIDLE
Text Label 7100 2800 0    60   ~ 0
TX_ELECIDLE
Text Label 7100 2700 0    60   ~ 0
TX_DETRX_LPBK
Text Label 7100 2500 0    60   ~ 0
PHY_RESETN
Text HLabel 6700 4100 0    60   Output ~ 0
POWERPRESENT
Text HLabel 6700 3900 0    60   BiDi ~ 0
PHY_STATUS
Text HLabel 6700 3500 0    60   Input ~ 0
POWER_DOWN[1..0]
Text HLabel 6700 3100 0    60   Output ~ 0
RX_STATUS[2..0]
Text HLabel 6700 3000 0    60   BiDi ~ 0
RX_ELECIDLE
Text HLabel 6700 2800 0    60   Input ~ 0
TX_ELECIDLE
Text HLabel 6700 2700 0    60   Input ~ 0
TX_DETRX_LPBK
Text HLabel 6700 2500 0    60   Input ~ 0
PHY_RESET#
$Comp
L R R7
U 1 1 511486FB
P 7650 9300
F 0 "R7" V 7730 9300 50  0000 C CNN
F 1 "10K" V 7650 9300 50  0000 C CNN
F 4 "1%" V 7550 9300 60  0000 C CNN "Tolerance"
	1    7650 9300
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR032
U 1 1 511486B7
P 7100 9800
F 0 "#PWR032" H 7100 9800 30  0001 C CNN
F 1 "GND" H 7100 9730 30  0001 C CNN
	1    7100 9800
	1    0    0    -1  
$EndComp
$Comp
L R R6
U 1 1 511486B3
P 7100 9450
F 0 "R6" V 7180 9450 50  0000 C CNN
F 1 "10K" V 7100 9450 50  0000 C CNN
	1    7100 9450
	-1   0    0    1   
$EndComp
Text HLabel 6800 9100 0    60   Input ~ 0
OUT_ENABLE
$Comp
L GND #PWR033
U 1 1 51148639
P 6900 9800
F 0 "#PWR033" H 6900 9800 30  0001 C CNN
F 1 "GND" H 6900 9730 30  0001 C CNN
	1    6900 9800
	1    0    0    -1  
$EndComp
Text HLabel 6800 9000 0    60   Input ~ 0
RESET#
$Comp
L R R5
U 1 1 51148613
P 6900 9450
F 0 "R5" V 6980 9450 50  0000 C CNN
F 1 "10K" V 6900 9450 50  0000 C CNN
	1    6900 9450
	-1   0    0    1   
$EndComp
$Comp
L TUSB1310A U2
U 5 1 510A04CC
P 8900 7500
F 0 "U2" H 8400 7450 60  0000 C CNN
F 1 "TUSB1310A" H 9250 7450 60  0000 C CNN
	5    8900 7500
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 4 1 510A04CB
P 8900 4500
F 0 "U2" H 8400 4450 60  0000 C CNN
F 1 "TUSB1310A" H 9250 4450 60  0000 C CNN
	4    8900 4500
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 3 1 510A04CA
P 8900 2300
F 0 "U2" H 8400 2250 60  0000 C CNN
F 1 "TUSB1310A" H 9250 2250 60  0000 C CNN
	3    8900 2300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
