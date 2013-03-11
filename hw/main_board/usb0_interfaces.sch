EESchema Schematic File Version 2  date Sunday, March 10, 2013 08:24:38 PM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 6 15
Title "Daisho Project Main Board"
Date "11 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 8000 8000 0    60   ~ 0
TODO:\nShorted together\nto ID nets on PCB
Connection ~ 7900 8300
Wire Wire Line
	7900 8400 7900 7700
Wire Wire Line
	7900 8400 7800 8400
Connection ~ 7900 8000
Wire Wire Line
	7900 8100 7800 8100
Wire Wire Line
	7900 7800 7800 7800
Wire Wire Line
	7900 7700 7800 7700
Connection ~ 9100 8600
Wire Wire Line
	9100 8500 9100 8700
Wire Wire Line
	9000 4800 8400 4800
Wire Wire Line
	8400 4800 8400 4700
Wire Wire Line
	7800 2700 8700 2700
Wire Wire Line
	7800 2900 8700 2900
Wire Wire Line
	7800 3100 8700 3100
Wire Wire Line
	7800 3300 8700 3300
Wire Wire Line
	7800 3500 8700 3500
Wire Wire Line
	7800 3700 8700 3700
Wire Wire Line
	7800 3900 8700 3900
Wire Wire Line
	7800 4100 8700 4100
Wire Bus Line
	9000 4600 8600 4600
Wire Bus Line
	8600 4600 8600 4500
Wire Wire Line
	7800 4400 8500 4400
Wire Wire Line
	7800 2500 9000 2500
Wire Bus Line
	4800 4600 5200 4600
Wire Bus Line
	5200 4600 5200 4500
Wire Wire Line
	6000 2500 4800 2500
Wire Wire Line
	6000 2800 5100 2800
Wire Wire Line
	6000 3000 5100 3000
Wire Wire Line
	6000 3200 5100 3200
Wire Wire Line
	6000 3400 5100 3400
Wire Wire Line
	6000 3600 5100 3600
Wire Wire Line
	6000 3800 5100 3800
Wire Wire Line
	6000 4000 5100 4000
Wire Wire Line
	6000 4200 5100 4200
Wire Wire Line
	6000 4500 5300 4500
Wire Wire Line
	7800 6400 8500 6400
Wire Bus Line
	5000 5600 5200 5600
Wire Bus Line
	5200 5600 5200 6300
Wire Wire Line
	6000 6400 5300 6400
Wire Wire Line
	6000 6200 5300 6200
Wire Wire Line
	6000 6000 5300 6000
Wire Wire Line
	6000 5800 5300 5800
Wire Wire Line
	6000 5700 5300 5700
Wire Wire Line
	6000 5900 5300 5900
Wire Wire Line
	6000 6100 5300 6100
Wire Wire Line
	6000 6300 5300 6300
Wire Wire Line
	6000 6600 5000 6600
Wire Wire Line
	7800 5700 8500 5700
Wire Wire Line
	7800 6600 8500 6600
Wire Wire Line
	6000 4400 5300 4400
Wire Wire Line
	6000 4100 5100 4100
Wire Wire Line
	6000 3900 5100 3900
Wire Wire Line
	6000 3700 5100 3700
Wire Wire Line
	6000 3500 5100 3500
Wire Wire Line
	6000 3300 5100 3300
Wire Wire Line
	6000 3100 5100 3100
Wire Wire Line
	6000 2900 5100 2900
Wire Wire Line
	6000 2700 5100 2700
Wire Bus Line
	5000 2800 5000 4300
Wire Bus Line
	5000 4300 4800 4300
Wire Wire Line
	8400 4700 7800 4700
Wire Wire Line
	7800 4500 8500 4500
Wire Wire Line
	7800 4200 8700 4200
Wire Wire Line
	7800 4000 8700 4000
Wire Wire Line
	7800 3800 8700 3800
Wire Wire Line
	7800 3600 8700 3600
Wire Wire Line
	7800 3400 8700 3400
Wire Wire Line
	7800 3200 8700 3200
Wire Wire Line
	7800 3000 8700 3000
Wire Wire Line
	7800 2800 8700 2800
Wire Bus Line
	8800 2800 8800 4300
Wire Bus Line
	8800 4300 9000 4300
Wire Wire Line
	9100 8600 7800 8600
Wire Wire Line
	9100 9200 9100 9300
Wire Wire Line
	7900 8000 7800 8000
Connection ~ 7900 7800
Wire Wire Line
	7900 8300 7800 8300
Connection ~ 7900 8100
$Comp
L GND #PWR014
U 1 1 5114892E
P 9100 9300
F 0 "#PWR014" H 9100 9300 30  0001 C CNN
F 1 "GND" H 9100 9230 30  0001 C CNN
	1    9100 9300
	1    0    0    -1  
$EndComp
$Comp
L R R9
U 1 1 511488CA
P 9100 8950
F 0 "R9" V 9180 8950 50  0000 C CNN
F 1 "10K" V 9100 8950 50  0000 C CNN
F 4 "1%" V 9000 8950 60  0000 C CNN "Tolerance"
	1    9100 8950
	-1   0    0    1   
$EndComp
$Comp
L R R8
U 1 1 511488C6
P 9100 8250
F 0 "R8" V 9180 8250 50  0000 C CNN
F 1 "90K9" V 9100 8250 50  0000 C CNN
F 4 "1%" V 9000 8250 60  0000 C CNN "Tolerance"
	1    9100 8250
	-1   0    0    1   
$EndComp
Text HLabel 9000 4800 2    60   Output ~ 0
RX_VALID
Text Label 5400 6600 0    60   ~ 0
ULPI_STP
Text Label 7900 4700 0    60   ~ 0
RX_VALID
Text Label 7900 4200 0    60   ~ 0
RX_DATA0
Text Label 7900 4100 0    60   ~ 0
RX_DATA1
Text Label 7900 4000 0    60   ~ 0
RX_DATA2
Text Label 7900 3900 0    60   ~ 0
RX_DATA3
Text Label 7900 3800 0    60   ~ 0
RX_DATA4
Text Label 7900 3700 0    60   ~ 0
RX_DATA5
Text Label 7900 3600 0    60   ~ 0
RX_DATA6
Text Label 7900 3500 0    60   ~ 0
RX_DATA7
Text Label 7900 3400 0    60   ~ 0
RX_DATA8
Text Label 7900 3300 0    60   ~ 0
RX_DATA9
Text Label 7900 3200 0    60   ~ 0
RX_DATA10
Text Label 7900 3100 0    60   ~ 0
RX_DATA11
Text Label 7900 3000 0    60   ~ 0
RX_DATA12
Text Label 7900 2900 0    60   ~ 0
RX_DATA13
Text Label 7900 2800 0    60   ~ 0
RX_DATA14
Text Label 7900 2700 0    60   ~ 0
RX_DATA15
Text Label 7900 2500 0    60   ~ 0
PCLK
Text HLabel 9000 4600 2    60   Output ~ 0
RX_DATAK[1..0]
Text HLabel 9000 4300 2    60   Output ~ 0
RX_DATA[15..0]
Entry Wire Line
	8700 4200 8800 4300
Entry Wire Line
	8700 4100 8800 4200
Entry Wire Line
	8700 4000 8800 4100
Entry Wire Line
	8700 3900 8800 4000
Entry Wire Line
	8700 3800 8800 3900
Entry Wire Line
	8700 3700 8800 3800
Entry Wire Line
	8700 3600 8800 3700
Entry Wire Line
	8700 3500 8800 3600
Entry Wire Line
	8700 3400 8800 3500
Entry Wire Line
	8700 3300 8800 3400
Entry Wire Line
	8700 3200 8800 3300
Entry Wire Line
	8700 3100 8800 3200
Entry Wire Line
	8700 3000 8800 3100
Entry Wire Line
	8700 2900 8800 3000
Entry Wire Line
	8700 2800 8800 2900
Entry Wire Line
	8700 2700 8800 2800
Text HLabel 9000 2500 2    60   Output ~ 0
PCLK
Text Label 7900 4500 0    60   ~ 0
RX_DATAK0
Text Label 7900 4400 0    60   ~ 0
RX_DATAK1
Entry Wire Line
	8500 4400 8600 4500
Entry Wire Line
	8500 4500 8600 4600
Text HLabel 4800 2500 0    60   Input ~ 0
TX_CLK
Text HLabel 4800 4300 0    60   Input ~ 0
TX_DATA[15..0]
Entry Wire Line
	5000 2800 5100 2700
Entry Wire Line
	5000 2900 5100 2800
Entry Wire Line
	5000 3000 5100 2900
Entry Wire Line
	5000 3100 5100 3000
Entry Wire Line
	5000 3200 5100 3100
Entry Wire Line
	5000 3300 5100 3200
Entry Wire Line
	5000 3400 5100 3300
Entry Wire Line
	5000 3500 5100 3400
Entry Wire Line
	5000 3600 5100 3500
Entry Wire Line
	5000 3700 5100 3600
Entry Wire Line
	5000 3800 5100 3700
Entry Wire Line
	5000 3900 5100 3800
Entry Wire Line
	5000 4000 5100 3900
Entry Wire Line
	5000 4100 5100 4000
Entry Wire Line
	5000 4200 5100 4100
Entry Wire Line
	5000 4300 5100 4200
Text HLabel 4800 4600 0    60   Input ~ 0
TX_DATAK[1..0]
Text Label 5400 2500 0    60   ~ 0
TX_CLK
Entry Wire Line
	5200 4600 5300 4500
Entry Wire Line
	5200 4500 5300 4400
Text Label 5400 4500 0    60   ~ 0
TX_DATAK0
Text Label 5400 4400 0    60   ~ 0
TX_DATAK1
Text Label 5400 4200 0    60   ~ 0
TX_DATA0
Text Label 5400 4100 0    60   ~ 0
TX_DATA1
Text Label 5400 4000 0    60   ~ 0
TX_DATA2
Text Label 5400 3900 0    60   ~ 0
TX_DATA3
Text Label 5400 3800 0    60   ~ 0
TX_DATA4
Text Label 5400 3700 0    60   ~ 0
TX_DATA5
Text Label 5400 3600 0    60   ~ 0
TX_DATA6
Text Label 5400 3500 0    60   ~ 0
TX_DATA7
Text Label 5400 3400 0    60   ~ 0
TX_DATA8
Text Label 5400 3300 0    60   ~ 0
TX_DATA9
Text Label 5400 3200 0    60   ~ 0
TX_DATA10
Text Label 5400 3100 0    60   ~ 0
TX_DATA11
Text Label 5400 3000 0    60   ~ 0
TX_DATA12
Text Label 5400 2900 0    60   ~ 0
TX_DATA13
Text Label 5400 2800 0    60   ~ 0
TX_DATA14
Text Label 5400 2700 0    60   ~ 0
TX_DATA15
Text Label 7900 6600 0    60   ~ 0
ULPI_NXT
Text Label 7900 6400 0    60   ~ 0
ULPI_DIR
Text Label 7900 5700 0    60   ~ 0
ULPI_CLK
Text HLabel 8500 6600 2    60   Output ~ 0
ULPI_NXT
Text HLabel 8500 6400 2    60   Output ~ 0
ULPI_DIR
Text HLabel 8500 5700 2    60   Output ~ 0
ULPI_CLK
Text HLabel 5000 6600 0    60   Input ~ 0
ULPI_STP
Text HLabel 5000 5600 0    60   BiDi ~ 0
ULPI_DATA[7..0]
Text Label 5400 6400 0    60   ~ 0
ULPI_DATA0
Text Label 5400 6300 0    60   ~ 0
ULPI_DATA1
Text Label 5400 6200 0    60   ~ 0
ULPI_DATA2
Text Label 5400 6100 0    60   ~ 0
ULPI_DATA3
Text Label 5400 6000 0    60   ~ 0
ULPI_DATA4
Text Label 5400 5900 0    60   ~ 0
ULPI_DATA5
Text Label 5400 5800 0    60   ~ 0
ULPI_DATA6
Text Label 5400 5700 0    60   ~ 0
ULPI_DATA7
Entry Wire Line
	5200 6300 5300 6400
Entry Wire Line
	5200 6200 5300 6300
Entry Wire Line
	5200 6100 5300 6200
Entry Wire Line
	5200 6000 5300 6100
Entry Wire Line
	5200 5900 5300 6000
Entry Wire Line
	5200 5800 5300 5900
Entry Wire Line
	5200 5700 5300 5800
Entry Wire Line
	5200 5600 5300 5700
$Comp
L TUSB1310A U2
U 6 1 5109FB8E
P 6900 7500
F 0 "U2" H 6400 7450 60  0000 C CNN
F 1 "TUSB1310A" H 7250 7450 60  0000 C CNN
	6    6900 7500
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 2 1 5109FB5E
P 6900 5500
F 0 "U2" H 6400 5450 60  0000 C CNN
F 1 "TUSB1310A" H 7250 5450 60  0000 C CNN
	2    6900 5500
	1    0    0    -1  
$EndComp
$Comp
L TUSB1310A U2
U 1 1 5109FB59
P 6900 2300
F 0 "U2" H 6400 2250 60  0000 C CNN
F 1 "TUSB1310A" H 7250 2250 60  0000 C CNN
	1    6900 2300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
