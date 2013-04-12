EESchema Schematic File Version 2  date Thu 11 Apr 2013 08:59:31 PM PDT
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
LIBS:tps2065c-2
LIBS:tps2113a
LIBS:tps54218
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 8 15
Title "Daisho Project Main Board"
Date "12 apr 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 7600 3100
NoConn ~ 7600 4400
NoConn ~ 7600 6800
NoConn ~ 7600 7900
Connection ~ 11800 3300
Wire Wire Line
	10200 3300 12200 3300
Wire Wire Line
	12200 3300 12200 3200
Connection ~ 11000 3300
Wire Wire Line
	11400 3300 11400 3200
Connection ~ 10200 3300
Wire Wire Line
	10600 3300 10600 3200
Connection ~ 12200 2700
Wire Wire Line
	12200 2800 12200 2700
Connection ~ 11400 2700
Wire Wire Line
	11400 2700 11400 2800
Connection ~ 10600 2700
Wire Wire Line
	10600 2700 10600 2800
Wire Wire Line
	7600 4500 6300 4500
Wire Wire Line
	7600 3700 6300 3700
Wire Wire Line
	7600 5400 6300 5400
Wire Wire Line
	7600 6200 6300 6200
Wire Wire Line
	7600 7500 6300 7500
Wire Wire Line
	7600 7300 6300 7300
Wire Wire Line
	7600 7000 6300 7000
Wire Wire Line
	7600 7200 6300 7200
Wire Wire Line
	7600 7800 6300 7800
Wire Wire Line
	7600 8100 6300 8100
Wire Wire Line
	7600 8300 6300 8300
Connection ~ 5300 10100
Wire Wire Line
	4700 10100 5600 10100
Wire Wire Line
	5600 10100 5600 10000
Connection ~ 5900 8900
Wire Wire Line
	5900 8300 5900 8900
Connection ~ 5600 7700
Wire Wire Line
	5900 7800 5900 7700
Wire Wire Line
	5900 7700 5000 7700
Connection ~ 5900 6700
Wire Wire Line
	5900 6600 5900 6700
Wire Wire Line
	5300 7800 5300 7700
Connection ~ 4700 10100
Wire Wire Line
	5000 10100 5000 10000
Wire Wire Line
	5300 9500 5300 9100
Wire Wire Line
	5300 9100 7600 9100
Wire Wire Line
	5000 9500 5000 8500
Wire Wire Line
	7600 4700 6300 4700
Wire Wire Line
	7600 9000 4400 9000
Wire Wire Line
	7600 8800 4400 8800
Wire Wire Line
	5000 8500 7600 8500
Connection ~ 9500 3000
Wire Wire Line
	9500 3000 9400 3000
Connection ~ 9500 2800
Wire Wire Line
	9500 2800 9400 2800
Wire Wire Line
	12500 2700 9400 2700
Wire Wire Line
	9400 3200 9500 3200
Wire Wire Line
	9500 3200 9500 2700
Connection ~ 9500 2700
Wire Wire Line
	9500 2900 9400 2900
Connection ~ 9500 2900
Wire Wire Line
	9500 3100 9400 3100
Connection ~ 9500 3100
Wire Wire Line
	7600 8700 4400 8700
Wire Wire Line
	7600 8900 4400 8900
Wire Wire Line
	7600 6700 4400 6700
Wire Wire Line
	7600 8400 4700 8400
Wire Wire Line
	4700 8400 4700 9500
Wire Wire Line
	7600 8600 5300 8600
Wire Wire Line
	5300 8600 5300 8300
Wire Wire Line
	4700 10000 4700 10200
Wire Wire Line
	5300 10000 5300 10100
Connection ~ 5000 10100
Wire Wire Line
	5600 6000 5900 6000
Wire Wire Line
	5900 6000 5900 6100
Wire Wire Line
	5600 7700 5600 7800
Connection ~ 5300 7700
Wire Wire Line
	5600 8300 5600 8700
Connection ~ 5600 8700
Wire Wire Line
	5600 9500 5600 8800
Connection ~ 5600 8800
Wire Wire Line
	7600 9200 6300 9200
Wire Wire Line
	7600 8200 6300 8200
Wire Wire Line
	7600 8000 6300 8000
Wire Wire Line
	7600 7700 6300 7700
Wire Wire Line
	7600 7600 6300 7600
Wire Wire Line
	7600 7400 6300 7400
Wire Wire Line
	7600 7100 6300 7100
Wire Wire Line
	7600 6100 6300 6100
Wire Wire Line
	7600 5300 6300 5300
Wire Wire Line
	7600 6600 6300 6600
Wire Wire Line
	7600 4600 6300 4600
Wire Wire Line
	10200 2700 10200 2800
Connection ~ 10200 2700
Wire Wire Line
	11000 2700 11000 2800
Connection ~ 11000 2700
Wire Wire Line
	11800 2700 11800 2800
Connection ~ 11800 2700
Wire Wire Line
	10200 3200 10200 3400
Wire Wire Line
	11000 3300 11000 3200
Connection ~ 10600 3300
Wire Wire Line
	11800 3300 11800 3200
Connection ~ 11400 3300
$Comp
L GND #PWR072
U 1 1 515A61E5
P 10200 3400
F 0 "#PWR072" H 10200 3400 30  0001 C CNN
F 1 "GND" H 10200 3330 30  0001 C CNN
	1    10200 3400
	1    0    0    -1  
$EndComp
$Comp
L C C156
U 1 1 515A61C9
P 12200 3000
F 0 "C156" H 12250 3100 50  0000 L CNN
F 1 "100N" H 12250 2900 50  0000 L CNN
	1    12200 3000
	1    0    0    -1  
$EndComp
$Comp
L C C155
U 1 1 515A61C6
P 11800 3000
F 0 "C155" H 11850 3100 50  0000 L CNN
F 1 "100N" H 11850 2900 50  0000 L CNN
	1    11800 3000
	1    0    0    -1  
$EndComp
$Comp
L C C154
U 1 1 515A61C4
P 11400 3000
F 0 "C154" H 11450 3100 50  0000 L CNN
F 1 "100N" H 11450 2900 50  0000 L CNN
	1    11400 3000
	1    0    0    -1  
$EndComp
$Comp
L C C153
U 1 1 515A61C1
P 11000 3000
F 0 "C153" H 11050 3100 50  0000 L CNN
F 1 "100N" H 11050 2900 50  0000 L CNN
	1    11000 3000
	1    0    0    -1  
$EndComp
$Comp
L C C152
U 1 1 515A61BE
P 10600 3000
F 0 "C152" H 10650 3100 50  0000 L CNN
F 1 "100N" H 10650 2900 50  0000 L CNN
	1    10600 3000
	1    0    0    -1  
$EndComp
$Comp
L C C151
U 1 1 515A61B2
P 10200 3000
F 0 "C151" H 10250 3100 50  0000 L CNN
F 1 "100N" H 10250 2900 50  0000 L CNN
	1    10200 3000
	1    0    0    -1  
$EndComp
Text Label 9700 2700 0    60   ~ 0
VCCIO
Text HLabel 3400 2700 0    60   Output ~ 0
PIPE_TX_ELECIDLE
Text HLabel 3400 2900 0    60   Output ~ 0
PIPE_PHY_RESETN
Text HLabel 3400 2300 0    60   Output ~ 0
PIPE_TX_DETRX_LPBK
Text HLabel 3400 2100 0    60   Output ~ 0
PIPE_OUT_ENABLE
Text Label 6500 4600 0    60   ~ 0
PIPE_OUT_ENABLE
Text Label 6500 7300 0    60   ~ 0
PIPE_PHY_RESETN
Text Label 6500 5300 0    60   ~ 0
PIPE_TX_DETRX_LPBK
Text Label 6500 7500 0    60   ~ 0
PIPE_TX_ELECIDLE
Text HLabel 3400 2600 0    60   Output ~ 0
PIPE_TX_ONESZEROS
Text HLabel 3400 2200 0    60   Output ~ 0
PIPE_TX_MARGIN[2..0]
Text HLabel 3400 2500 0    60   Output ~ 0
PIPE_TX_SWING
Text HLabel 3400 2800 0    60   Output ~ 0
PIPE_RATE
Text Label 6500 6100 0    60   ~ 0
PIPE_TX_SWING
Text Label 6500 7400 0    60   ~ 0
PIPE_RATE
Text Label 6500 7100 0    60   ~ 0
PIPE_TX_ONESZEROS
Text Label 6500 4500 0    60   ~ 0
PIPE_TX_MARGIN2
Text Label 6500 3700 0    60   ~ 0
PIPE_TX_MARGIN1
Text Label 6500 5400 0    60   ~ 0
PIPE_TX_MARGIN0
Text Label 6500 6200 0    60   ~ 0
ULPI_DIR
Text Label 6500 6600 0    60   ~ 0
ULPI_STP
Text Label 6500 7000 0    60   ~ 0
ULPI_NXT
Text Label 6500 7600 0    60   ~ 0
ULPI_DATA1
Text Label 6500 7200 0    60   ~ 0
ULPI_DATA0
Text Label 6500 7700 0    60   ~ 0
ULPI_DATA2
Text Label 6500 7800 0    60   ~ 0
ULPI_DATA3
Text Label 6500 8000 0    60   ~ 0
ULPI_DATA4
Text Label 6500 8100 0    60   ~ 0
ULPI_DATA5
Text Label 6500 8200 0    60   ~ 0
ULPI_DATA6
Text Label 6500 8300 0    60   ~ 0
ULPI_DATA7
Text Label 6500 9200 0    60   ~ 0
ULPI_CLK
Text Notes 6700 9800 0    60   ~ 0
Figure 8-24: If you only use JTAG configuration, connect the nCONFIG\npin to logic-high and the MSEL pins to GND. In addition, pull DCLK and\nDATA[0] to either high or low, whichever is convenient on your board.
$Comp
L R R49
U 1 1 5159F883
P 5600 9750
F 0 "R49" V 5680 9750 50  0000 C CNN
F 1 "1K" V 5600 9750 50  0000 C CNN
	1    5600 9750
	-1   0    0    -1  
$EndComp
$Comp
L R R45
U 1 1 5159F86C
P 5900 8050
F 0 "R45" V 5980 8050 50  0000 C CNN
F 1 "10K" V 5900 8050 50  0000 C CNN
	1    5900 8050
	-1   0    0    -1  
$EndComp
$Comp
L R R44
U 1 1 5159F867
P 5600 8050
F 0 "R44" V 5680 8050 50  0000 C CNN
F 1 "10K" V 5600 8050 50  0000 C CNN
	1    5600 8050
	-1   0    0    -1  
$EndComp
Text GLabel 5600 6000 0    60   Input ~ 0
V1P8
$Comp
L R R50
U 1 1 5159EFFC
P 5900 6350
F 0 "R50" V 5980 6350 50  0000 C CNN
F 1 "10K" V 5900 6350 50  0000 C CNN
	1    5900 6350
	-1   0    0    -1  
$EndComp
Text GLabel 5000 7700 0    60   Input ~ 0
V1P8
$Comp
L GND #PWR073
U 1 1 5159EEDD
P 4700 10200
F 0 "#PWR073" H 4700 10200 30  0001 C CNN
F 1 "GND" H 4700 10130 30  0001 C CNN
	1    4700 10200
	1    0    0    -1  
$EndComp
$Comp
L R R48
U 1 1 5159EECE
P 5300 9750
F 0 "R48" V 5380 9750 50  0000 C CNN
F 1 "10K" V 5300 9750 50  0000 C CNN
	1    5300 9750
	-1   0    0    -1  
$EndComp
$Comp
L R R43
U 1 1 5159EE10
P 5300 8050
F 0 "R43" V 5380 8050 50  0000 C CNN
F 1 "10K" V 5300 8050 50  0000 C CNN
	1    5300 8050
	-1   0    0    -1  
$EndComp
$Comp
L R R47
U 1 1 5159EE0A
P 5000 9750
F 0 "R47" V 5080 9750 50  0000 C CNN
F 1 "10K" V 5000 9750 50  0000 C CNN
	1    5000 9750
	-1   0    0    -1  
$EndComp
$Comp
L R R46
U 1 1 5159EDF9
P 4700 9750
F 0 "R46" V 4780 9750 50  0000 C CNN
F 1 "10K" V 4700 9750 50  0000 C CNN
	1    4700 9750
	-1   0    0    -1  
$EndComp
Text Label 6500 9100 0    60   ~ 0
NCE
Text Label 6500 8400 0    60   ~ 0
DCLK
Text Label 6500 8500 0    60   ~ 0
DATA0
Text Label 6500 8600 0    60   ~ 0
NCONFIG
Text GLabel 12500 2700 2    60   Input ~ 0
V1P8
Text HLabel 3400 1600 0    60   BiDi ~ 0
ULPI_DATA[7..0]
Text HLabel 3400 1900 0    60   Input ~ 0
ULPI_NXT
Text HLabel 3400 1700 0    60   Input ~ 0
ULPI_DIR
Text HLabel 3400 1800 0    60   Output ~ 0
ULPI_STP
Text HLabel 3400 1500 0    60   Input ~ 0
ULPI_CLK
Text HLabel 3400 3900 0    60   Output ~ 0
SPI_MISO
Text HLabel 3400 3800 0    60   Input ~ 0
SPI_MOSI
Text HLabel 3400 3700 0    60   Input ~ 0
SPI_CS#
Text HLabel 3400 3600 0    60   Input ~ 0
SPI_SCLK
Text HLabel 3400 3300 0    60   BiDi ~ 0
I2C_SDA
Text HLabel 3400 3200 0    60   Output ~ 0
I2C_SCL
Text HLabel 4400 9000 0    60   Output ~ 0
FPGA_TDO
Text HLabel 4400 8900 0    60   Input ~ 0
FPGA_TMS
Text HLabel 4400 8800 0    60   Input ~ 0
FPGA_TCK
Text HLabel 4400 8700 0    60   Input ~ 0
FPGA_TDI
Text HLabel 4400 6700 0    60   BiDi ~ 0
FPGA_NSTATUS
$Comp
L EP4CE30F29 U1
U 1 1 5129C259
P 8500 2400
F 0 "U1" H 8500 2450 60  0000 C CNN
F 1 "EP4CE30F29" H 8550 2350 60  0000 C CNN
	1    8500 2400
	1    0    0    -1  
$EndComp
$EndSCHEMATC
