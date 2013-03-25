EESchema Schematic File Version 2  date Monday, March 25, 2013 04:30:54 PM
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
Sheet 4 16
Title "Daisho Project Main Board"
Date "25 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 2400 5850 0    60   Output ~ 0
USB0_OUT_ENABLE
Text HLabel 2400 5750 0    60   Output ~ 0
USB0_RESETN
Text Notes 9300 4450 0    60   ~ 0
Avoid use of VREF pins as I/O, as they have higher pin capacitance,\nand therefore are slow down both input and output signals.
NoConn ~ 7400 3800
NoConn ~ 7400 5500
NoConn ~ 7400 7200
NoConn ~ 7400 8800
Text HLabel 9500 2500 2    60   Input ~ 0
VCCIO
Connection ~ 9300 2900
Wire Wire Line
	9200 2900 9300 2900
Connection ~ 9300 2700
Wire Wire Line
	9200 2700 9300 2700
Connection ~ 9300 2500
Wire Wire Line
	9300 2500 9300 3000
Wire Wire Line
	9300 3000 9200 3000
Wire Bus Line
	2400 7050 2500 7050
Wire Bus Line
	2500 7050 2500 6550
Wire Bus Line
	2500 6550 2400 6550
Connection ~ 2600 6150
Wire Wire Line
	2400 6150 2600 6150
Connection ~ 2600 6350
Wire Wire Line
	2600 6350 2400 6350
Connection ~ 2600 6750
Wire Wire Line
	2400 6750 2600 6750
Connection ~ 2600 7250
Wire Wire Line
	2400 7250 2600 7250
Connection ~ 2600 7450
Wire Wire Line
	2600 7450 2400 7450
Wire Wire Line
	2400 7650 2600 7650
Wire Wire Line
	2600 7650 2600 6050
Wire Wire Line
	2600 6050 2400 6050
Connection ~ 5900 3000
Wire Wire Line
	5900 3000 7400 3000
Wire Wire Line
	5900 3200 5900 2800
Wire Wire Line
	5900 2800 7400 2800
Wire Wire Line
	7400 9000 6100 9000
Wire Wire Line
	7400 8200 6100 8200
Wire Wire Line
	7400 7600 6100 7600
Wire Wire Line
	7400 7100 6100 7100
Wire Wire Line
	7400 6600 6100 6600
Wire Wire Line
	7400 6200 6100 6200
Wire Wire Line
	7400 5600 6100 5600
Wire Wire Line
	7400 5100 6100 5100
Wire Wire Line
	7400 4800 6100 4800
Wire Wire Line
	7400 4400 6100 4400
Wire Wire Line
	7400 6000 6100 6000
Wire Wire Line
	7400 3500 6100 3500
Wire Wire Line
	7400 4100 6100 4100
Wire Wire Line
	6100 9300 7400 9300
Wire Wire Line
	6100 8900 7400 8900
Wire Wire Line
	6100 8600 7400 8600
Wire Wire Line
	6100 8400 7400 8400
Wire Wire Line
	6100 8100 7400 8100
Wire Wire Line
	6100 7800 7400 7800
Wire Wire Line
	6100 7500 7400 7500
Wire Wire Line
	6100 6900 7400 6900
Wire Wire Line
	6100 5300 7400 5300
Wire Wire Line
	7400 2600 6100 2600
Wire Wire Line
	7400 7400 6100 7400
Wire Wire Line
	7400 6700 6100 6700
Wire Wire Line
	7400 4900 6100 4900
Wire Wire Line
	7400 3900 6100 3900
Wire Wire Line
	7400 6300 6100 6300
Wire Wire Line
	7400 5800 6100 5800
Wire Wire Line
	7400 4700 6100 4700
Wire Wire Line
	7400 4200 6100 4200
Wire Wire Line
	7400 4500 6100 4500
Wire Wire Line
	7400 5700 6100 5700
Wire Wire Line
	7400 6100 6100 6100
Wire Wire Line
	7400 3200 6100 3200
Wire Wire Line
	7400 3700 6100 3700
Wire Wire Line
	7400 4300 6100 4300
Wire Wire Line
	7400 5200 6100 5200
Wire Wire Line
	7400 6500 6100 6500
Wire Wire Line
	7400 2700 5700 2700
Wire Wire Line
	7400 3600 6100 3600
Wire Wire Line
	6100 6800 7400 6800
Wire Wire Line
	7400 7300 6100 7300
Wire Wire Line
	6100 7700 7400 7700
Wire Wire Line
	6100 7900 7400 7900
Wire Wire Line
	6100 8300 7400 8300
Wire Wire Line
	6100 8500 7400 8500
Wire Wire Line
	6100 8700 7400 8700
Wire Wire Line
	6100 9100 7400 9100
Wire Wire Line
	6100 9400 7400 9400
Wire Wire Line
	7400 3400 6100 3400
Wire Wire Line
	7400 2500 6100 2500
Wire Wire Line
	7400 3300 6100 3300
Wire Wire Line
	7400 4000 6100 4000
Wire Wire Line
	7400 4600 6100 4600
Wire Wire Line
	7400 5000 6100 5000
Wire Wire Line
	7400 5400 6100 5400
Wire Wire Line
	7400 5900 6100 5900
Wire Wire Line
	7400 6400 6100 6400
Wire Wire Line
	7400 7000 6100 7000
Wire Wire Line
	7400 8000 6100 8000
Wire Wire Line
	7400 9200 6100 9200
Wire Wire Line
	7400 2900 5900 2900
Connection ~ 5900 2900
Wire Wire Line
	5900 3100 7400 3100
Connection ~ 5900 3100
Wire Wire Line
	2400 7550 2600 7550
Connection ~ 2600 7550
Wire Wire Line
	2400 7350 2600 7350
Connection ~ 2600 7350
Wire Wire Line
	2400 6950 2600 6950
Connection ~ 2600 6950
Wire Wire Line
	2400 6650 2600 6650
Connection ~ 2600 6650
Wire Wire Line
	2600 6250 2400 6250
Connection ~ 2600 6250
Wire Bus Line
	2400 6450 2700 6450
Wire Bus Line
	2700 6450 2700 7150
Wire Bus Line
	2700 7150 2400 7150
Wire Wire Line
	9500 2500 9200 2500
Wire Wire Line
	9200 2600 9300 2600
Connection ~ 9300 2600
Wire Wire Line
	9200 2800 9300 2800
Connection ~ 9300 2800
Text HLabel 2400 7650 0    60   Output ~ 0
USB0_ELAS_BUF_MODE
Text HLabel 2400 7550 0    60   Output ~ 0
USB0_RATE
Text HLabel 2400 7450 0    60   Output ~ 0
USB0_RX_TERMINATION
Text HLabel 2400 7350 0    60   Output ~ 0
USB0_RX_POLARITY
Text HLabel 2400 7250 0    60   Output ~ 0
USB0_TX_SWING
Text HLabel 2400 7150 0    60   Output ~ 0
USB0_TX_MARGIN[2..0]
Text HLabel 2400 7050 0    60   Output ~ 0
USB0_TX_DEEMPH[1..0]
Text HLabel 2400 6950 0    60   Output ~ 0
USB0_TX_ONESZEROS
Text HLabel 2400 6750 0    60   Input ~ 0
USB0_PWRPRESENT
Text HLabel 2400 6650 0    60   BiDi ~ 0
USB0_PHY_STATUS
Text HLabel 2400 6550 0    60   Output ~ 0
USB0_POWERDOWN[1..0]
Text HLabel 2400 6150 0    60   Output ~ 0
USB0_TX_DETRX_LPBK
Text HLabel 2400 6050 0    60   Output ~ 0
USB0_PHY_RESETN
Text Notes 5800 2950 2    60   ~ 0
Only PS and JTAG programming modes supported.\nPS uses standard power-on reset (POR) delay of 50 to 200 ms.\nPS interface voltage determined by Bank 1 VCCIO.
$Comp
L GND #PWR021
U 1 1 512AEDBF
P 5900 3200
F 0 "#PWR021" H 5900 3200 30  0001 C CNN
F 1 "GND" H 5900 3130 30  0001 C CNN
	1    5900 3200
	1    0    0    -1  
$EndComp
Text HLabel 2400 6250 0    60   Output ~ 0
USB0_TX_ELECIDLE
Text HLabel 2400 6350 0    60   BiDi ~ 0
USB0_RX_ELECIDLE
Text HLabel 2400 6450 0    60   Input ~ 0
USB0_RX_STATUS[2..0]
Text Label 6200 2500 0    60   ~ 0
USB0_PIPE_RX_VALID
Text Label 6200 6500 0    60   ~ 0
USB0_PIPE_TX_CLK
Text Label 6200 6700 0    60   ~ 0
USB0_PIPE_RX_DATA0
Text Label 6200 6800 0    60   ~ 0
USB0_PIPE_RX_DATA1
Text Label 6200 3600 0    60   ~ 0
USB0_PIPE_RX_DATA2
Text Label 6200 6900 0    60   ~ 0
USB0_PIPE_RX_DATA3
Text Label 6200 7500 0    60   ~ 0
USB0_PIPE_RX_DATA4
Text Label 6200 7300 0    60   ~ 0
USB0_PIPE_RX_DATA5
Text Label 6200 8700 0    60   ~ 0
USB0_PIPE_RX_DATA6
Text Label 6200 7700 0    60   ~ 0
USB0_PIPE_RX_DATA7
Text Label 6200 8300 0    60   ~ 0
USB0_PIPE_RX_DATA8
Text Label 6200 8900 0    60   ~ 0
USB0_PIPE_RX_DATA9
Text Label 6200 7800 0    60   ~ 0
USB0_PIPE_RX_DATA10
Text Label 6200 6000 0    60   ~ 0
USB0_PIPE_RX_DATA11
Text Label 6200 8600 0    60   ~ 0
USB0_PIPE_RX_DATAK0
Text Label 6200 9300 0    60   ~ 0
USB0_PIPE_RX_DATAK1
Text Label 6200 7900 0    60   ~ 0
USB0_PIPE_RX_DATA12
Text Label 6200 8100 0    60   ~ 0
USB0_PIPE_RX_DATA13
Text Label 6200 8500 0    60   ~ 0
USB0_PIPE_RX_DATA14
Text Label 6200 8400 0    60   ~ 0
USB0_PIPE_RX_DATA15
Text Notes 9300 3550 0    60   ~ 0
CRC_ERROR is open-drain during configuration, only if bitstream CRC error detection is enabled.
Text Notes 9300 3450 0    60   ~ 0
INIT_DONE is open-drain during configuration, only if INIT_DONE output is enabled in bitstream.
Text Notes 9300 4150 0    60   ~ 0
nCEO is open-drain during configuration.
Text Notes 9300 3200 0    60   ~ 0
nCEO, INIT_DONE, CRC_ERROR driven during configuration.
Text Label 6200 5200 0    60   ~ 0
USB0_PIPE_TX_DATAK1
Text Label 6200 6100 0    60   ~ 0
USB0_PIPE_TX_DATAK0
Text Label 6200 3700 0    60   ~ 0
USB0_PIPE_TX_DATA15
Text Label 6200 3200 0    60   ~ 0
USB0_PIPE_TX_DATA14
Text Label 6200 7400 0    60   ~ 0
USB0_PIPE_TX_DATA13
Text Label 6200 6300 0    60   ~ 0
USB0_PIPE_TX_DATA12
Text Label 6200 4900 0    60   ~ 0
USB0_PIPE_TX_DATA11
Text Label 6200 3300 0    60   ~ 0
USB0_PIPE_TX_DATA10
Text Label 6200 5700 0    60   ~ 0
USB0_PIPE_TX_DATA9
Text Label 6200 5800 0    60   ~ 0
USB0_PIPE_TX_DATA8
Text Label 6200 4100 0    60   ~ 0
USB0_PIPE_TX_DATA0
Text Label 6200 2600 0    60   ~ 0
USB0_PIPE_PCLK
Text Label 6200 2700 0    60   ~ 0
FPGA_CONF_DONE
Text Label 6200 3100 0    60   ~ 0
FPGA_MSEL3
Text Label 6200 3000 0    60   ~ 0
FPGA_MSEL2
Text Label 6200 2900 0    60   ~ 0
FPGA_MSEL1
Text Label 6200 2800 0    60   ~ 0
FPGA_MSEL0
Text HLabel 5700 2700 0    60   Output ~ 0
FPGA_CONF_DONE
Text Label 6200 3900 0    60   ~ 0
USB0_PIPE_TX_DATA7
Text Label 6200 4700 0    60   ~ 0
USB0_PIPE_TX_DATA6
Text Label 6200 4300 0    60   ~ 0
USB0_PIPE_TX_DATA5
Text Label 6200 4500 0    60   ~ 0
USB0_PIPE_TX_DATA4
Text Label 6200 3400 0    60   ~ 0
USB0_PIPE_TX_DATA3
Text Label 6200 3500 0    60   ~ 0
USB0_PIPE_TX_DATA2
Text Label 6200 4200 0    60   ~ 0
USB0_PIPE_TX_DATA1
Text HLabel 2400 5250 0    60   Input ~ 0
USB0_PIPE_RX_VALID
Text HLabel 2400 5150 0    60   Input ~ 0
USB0_PIPE_RX_DATAK[1..0]
Text HLabel 2400 5050 0    60   Input ~ 0
USB0_PIPE_RX_DATA[15..0]
Text HLabel 2400 4950 0    60   Input ~ 0
USB0_PIPE_PCLK
Text HLabel 2400 4750 0    60   Output ~ 0
USB0_PIPE_TX_DATAK[1..0]
Text HLabel 2400 4650 0    60   Output ~ 0
USB0_PIPE_TX_DATA[15..0]
Text HLabel 2400 4550 0    60   Output ~ 0
USB0_PIPE_TX_CLK
$Comp
L EP4CE30F29 U1
U 6 1 5129BD1C
P 8300 2200
F 0 "U1" H 8300 2250 60  0000 C CNN
F 1 "EP4CE30F29" H 8350 2150 60  0000 C CNN
	6    8300 2200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
