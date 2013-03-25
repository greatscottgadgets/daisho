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
Sheet 6 16
Title "Daisho Project Main Board"
Date "25 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	6400 9200 7600 9200
Wire Wire Line
	7600 3100 6400 3100
Wire Wire Line
	7600 7900 6400 7900
Wire Wire Line
	7600 4700 6400 4700
Wire Wire Line
	7600 8400 6400 8400
Wire Wire Line
	7600 9000 6400 9000
Wire Wire Line
	7600 8800 6400 8800
Wire Wire Line
	7600 8500 6400 8500
Connection ~ 9500 3000
Wire Wire Line
	9400 3000 9500 3000
Connection ~ 9500 2800
Wire Wire Line
	9400 2800 9500 2800
Wire Wire Line
	9400 2700 9700 2700
Wire Wire Line
	9400 3200 9500 3200
Wire Wire Line
	9500 3200 9500 2700
Connection ~ 9500 2700
Wire Wire Line
	9400 2900 9500 2900
Connection ~ 9500 2900
Wire Wire Line
	9400 3100 9500 3100
Connection ~ 9500 3100
Wire Wire Line
	7600 8700 6400 8700
Wire Wire Line
	7600 8900 6400 8900
Wire Wire Line
	7600 8600 6400 8600
Wire Wire Line
	7600 6700 6400 6700
Wire Wire Line
	7600 6800 6400 6800
Wire Wire Line
	7600 4400 6400 4400
Wire Wire Line
	7600 9100 6400 9100
Text HLabel 6400 9200 0    60   Input ~ 0
FPGA_CLK1
Text HLabel 5300 3700 0    60   Output ~ 0
SPI_MISO
Text HLabel 5300 3600 0    60   Input ~ 0
SPI_MOSI
Text HLabel 5300 3500 0    60   Input ~ 0
SPI_CS#
Text HLabel 5300 3400 0    60   Input ~ 0
SPI_SCLK
Text HLabel 5300 3200 0    60   BiDi ~ 0
I2C_SDA
Text HLabel 5300 3100 0    60   Output ~ 0
I2C_SCL
Text Label 6600 7900 0    60   ~ 0
VREF
Text Label 6600 6800 0    60   ~ 0
VREF
Text Label 6600 4400 0    60   ~ 0
VREF
Text Label 6600 3100 0    60   ~ 0
VREF
Text HLabel 6400 9100 0    60   Input ~ 0
FPGA_NCE
Text HLabel 6400 9000 0    60   Output ~ 0
FPGA_TDO
Text HLabel 6400 8900 0    60   Input ~ 0
FPGA_TMS
Text HLabel 6400 8800 0    60   Input ~ 0
FPGA_TCK
Text HLabel 6400 8700 0    60   Input ~ 0
FPGA_TDI
Text HLabel 6400 6700 0    60   BiDi ~ 0
FPGA_NSTATUS
Text HLabel 6400 8600 0    60   Input ~ 0
FPGA_NCONFIG
Text HLabel 6400 8400 0    60   Input ~ 0
FPGA_DCLK
Text HLabel 6400 8500 0    60   Input ~ 0
FPGA_DATA0
Text HLabel 9700 2700 2    60   Input ~ 0
VCCIO
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
