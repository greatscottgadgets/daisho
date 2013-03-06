EESchema Schematic File Version 2  date Tuesday, March 05, 2013 06:23:51 PM
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
Sheet 5 11
Title "Daisho Project Main Board"
Date "6 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 5800 2950 2    60   ~ 0
Only PS and JTAG programming modes supported.\nPS uses standard power-on reset (POR) delay of 50 to 200 ms.\nPS interface voltage determined by Bank 1 VCCIO.
Connection ~ 5900 3100
Wire Wire Line
	5900 3100 7400 3100
Connection ~ 5900 2900
Wire Wire Line
	7400 2900 5900 2900
Wire Wire Line
	7400 9200 6100 9200
Wire Wire Line
	7400 8800 6100 8800
Wire Wire Line
	7400 8000 6100 8000
Wire Wire Line
	7400 7200 6100 7200
Wire Wire Line
	7400 7000 6100 7000
Wire Wire Line
	7400 6400 6100 6400
Wire Wire Line
	7400 5900 6100 5900
Wire Wire Line
	7400 5400 6100 5400
Wire Wire Line
	7400 5000 6100 5000
Wire Wire Line
	7400 4600 6100 4600
Wire Wire Line
	7400 4000 6100 4000
Wire Wire Line
	7400 3300 6100 3300
Wire Wire Line
	7400 2500 6100 2500
Wire Wire Line
	7400 3400 6100 3400
Wire Wire Line
	6100 9400 7400 9400
Wire Wire Line
	6100 9100 7400 9100
Wire Wire Line
	6100 8700 7400 8700
Wire Wire Line
	6100 8500 7400 8500
Wire Wire Line
	6100 8300 7400 8300
Wire Wire Line
	6100 7900 7400 7900
Wire Wire Line
	6100 7700 7400 7700
Wire Wire Line
	7400 7300 6100 7300
Wire Wire Line
	6100 6800 7400 6800
Wire Wire Line
	7400 3600 6100 3600
Wire Wire Line
	7400 2700 5700 2700
Wire Wire Line
	7400 6500 6100 6500
Wire Wire Line
	7400 5500 6100 5500
Wire Wire Line
	7400 5200 6100 5200
Wire Wire Line
	7400 4300 6100 4300
Wire Wire Line
	7400 3700 6100 3700
Wire Wire Line
	7400 3200 6100 3200
Wire Wire Line
	7400 6100 6100 6100
Wire Wire Line
	7400 5700 6100 5700
Wire Wire Line
	7400 4500 6100 4500
Wire Wire Line
	7400 4200 6100 4200
Wire Wire Line
	7400 4700 6100 4700
Wire Wire Line
	7400 5800 6100 5800
Wire Wire Line
	7400 6300 6100 6300
Wire Wire Line
	7400 3900 6100 3900
Wire Wire Line
	7400 4900 6100 4900
Wire Wire Line
	7400 6700 6100 6700
Wire Wire Line
	7400 7400 6100 7400
Wire Wire Line
	7400 2600 6100 2600
Wire Wire Line
	6100 5300 7400 5300
Wire Wire Line
	6100 6900 7400 6900
Wire Wire Line
	6100 7500 7400 7500
Wire Wire Line
	6100 7800 7400 7800
Wire Wire Line
	6100 8100 7400 8100
Wire Wire Line
	6100 8400 7400 8400
Wire Wire Line
	6100 8600 7400 8600
Wire Wire Line
	6100 8900 7400 8900
Wire Wire Line
	6100 9300 7400 9300
Wire Wire Line
	7400 4100 6100 4100
Wire Wire Line
	7400 3500 6100 3500
Wire Wire Line
	7400 6000 6100 6000
Wire Wire Line
	7400 3800 6100 3800
Wire Wire Line
	7400 4400 6100 4400
Wire Wire Line
	7400 4800 6100 4800
Wire Wire Line
	7400 5100 6100 5100
Wire Wire Line
	7400 5600 6100 5600
Wire Wire Line
	7400 6200 6100 6200
Wire Wire Line
	7400 6600 6100 6600
Wire Wire Line
	7400 7100 6100 7100
Wire Wire Line
	7400 7600 6100 7600
Wire Wire Line
	7400 8200 6100 8200
Wire Wire Line
	7400 9000 6100 9000
Wire Wire Line
	7400 2800 5900 2800
Wire Wire Line
	5900 2800 5900 3200
Wire Wire Line
	5900 3000 7400 3000
Connection ~ 5900 3000
$Comp
L GND #PWR03
U 1 1 512AEDBF
P 5900 3200
F 0 "#PWR03" H 5900 3200 30  0001 C CNN
F 1 "GND" H 5900 3130 30  0001 C CNN
	1    5900 3200
	1    0    0    -1  
$EndComp
Text HLabel 2400 6250 0    60   Output ~ 0
USB0_TX_ELECIDLE
Text HLabel 2400 6350 0    60   BiDi ~ 0
USB0_RX_ELECIDLE
Text Label 4500 6700 0    60   ~ 0
USB0_RX_STATUS0
Text Label 4500 6600 0    60   ~ 0
USB0_RX_STATUS1
Text Label 4500 6500 0    60   ~ 0
USB0_RX_STATUS2
Text HLabel 2400 6450 0    60   Input ~ 0
USB0_RX_STATUS[2..0]
Text Label 4500 5000 0    60   ~ 0
USB0_ULPI_NXT
Text Label 4500 4900 0    60   ~ 0
USB0_ULPI_STP
Text Label 4500 4800 0    60   ~ 0
USB0_ULPI_DIR
Text Label 4500 4700 0    60   ~ 0
USB0_ULPI_DATA0
Text Label 4500 4600 0    60   ~ 0
USB0_ULPI_DATA1
Text Label 4500 4500 0    60   ~ 0
USB0_ULPI_DATA2
Text Label 4500 4400 0    60   ~ 0
USB0_ULPI_DATA3
Text Label 4500 4300 0    60   ~ 0
USB0_ULPI_DATA4
Text Label 4500 4200 0    60   ~ 0
USB0_ULPI_DATA5
Text Label 4500 4100 0    60   ~ 0
USB0_ULPI_DATA6
Text Label 4500 4000 0    60   ~ 0
USB0_ULPI_DATA7
Text Label 6200 2500 0    60   ~ 0
USB0_ULPI_CLK
Text Label 6200 6800 0    60   ~ 0
USB0_PIPE_RX_VALID
Text Label 6200 4900 0    60   ~ 0
USB0_PIPE_TX_CLK
Text Label 6200 6900 0    60   ~ 0
USB0_PIPE_RX_DATA0
Text Label 6200 5300 0    60   ~ 0
USB0_PIPE_RX_DATA1
Text Label 6200 6700 0    60   ~ 0
USB0_PIPE_RX_DATA2
Text Label 6200 7500 0    60   ~ 0
USB0_PIPE_RX_DATA3
Text Label 6200 7300 0    60   ~ 0
USB0_PIPE_RX_DATA4
Text Label 6200 8700 0    60   ~ 0
USB0_PIPE_RX_DATA5
Text Label 6200 6000 0    60   ~ 0
USB0_PIPE_RX_DATA6
Text Label 6200 8300 0    60   ~ 0
USB0_PIPE_RX_DATA7
Text Label 6200 9300 0    60   ~ 0
USB0_PIPE_RX_DATA8
Text Label 6200 8900 0    60   ~ 0
USB0_PIPE_RX_DATA9
Text Label 6200 8600 0    60   ~ 0
USB0_PIPE_RX_DATA10
Text Label 6200 9400 0    60   ~ 0
USB0_PIPE_RX_DATA11
Text Label 6200 7800 0    60   ~ 0
USB0_PIPE_RX_DATAK0
Text Label 6200 7700 0    60   ~ 0
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
Text Label 6200 6500 0    60   ~ 0
USB0_PIPE_TX_DATAK0
Text Label 6200 3200 0    60   ~ 0
USB0_PIPE_TX_DATA15
Text Label 6200 3700 0    60   ~ 0
USB0_PIPE_TX_DATA14
Text Label 6200 7400 0    60   ~ 0
USB0_PIPE_TX_DATA13
Text Label 6200 5500 0    60   ~ 0
USB0_PIPE_TX_DATA12
Text Label 6200 3400 0    60   ~ 0
USB0_PIPE_TX_DATA11
Text Label 6200 3900 0    60   ~ 0
USB0_PIPE_TX_DATA10
Text Label 6200 3500 0    60   ~ 0
USB0_PIPE_TX_DATA9
Text Label 6200 4300 0    60   ~ 0
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
Text Label 6200 6300 0    60   ~ 0
USB0_PIPE_TX_DATA7
Text Label 6200 5800 0    60   ~ 0
USB0_PIPE_TX_DATA6
Text Label 6200 6100 0    60   ~ 0
USB0_PIPE_TX_DATA5
Text Label 6200 5700 0    60   ~ 0
USB0_PIPE_TX_DATA4
Text Label 6200 4700 0    60   ~ 0
USB0_PIPE_TX_DATA3
Text Label 6200 4500 0    60   ~ 0
USB0_PIPE_TX_DATA2
Text Label 6200 4200 0    60   ~ 0
USB0_PIPE_TX_DATA1
Text HLabel 2400 5850 0    60   Input ~ 0
USB0_ULPI_NXT
Text HLabel 2400 5750 0    60   Output ~ 0
USB0_ULPI_STP
Text HLabel 2400 5650 0    60   Input ~ 0
USB0_ULPI_DIR
Text HLabel 2400 5550 0    60   BiDi ~ 0
USB0_ULPI_DATA[7..0]
Text HLabel 2400 5450 0    60   Input ~ 0
USB0_ULPI_CLK
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
