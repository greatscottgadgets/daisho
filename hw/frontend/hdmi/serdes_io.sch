EESchema Schematic File Version 2
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
LIBS:ptn3360dbs
LIBS:tbd12s521
LIBS:tbd12s520
LIBS:hdmi
LIBS:stdve001aqtr
LIBS:tlk3134-multi
LIBS:si5338
LIBS:tps54218
LIBS:samtec_qsh-090-d
LIBS:fan4860
LIBS:on_cat24c256
LIBS:hole
LIBS:hdmi-cache
EELAYER 24 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 9
Title ""
Date "18 oct 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L TLK3134-MULTI U401
U 3 1 513568CC
P 2000 3300
F 0 "U401" H 2600 3450 60  0000 C CNN
F 1 "TLK3134-MULTI" H 1750 3450 60  0000 C CNN
F 2 "daisho:PBGA-289" H 2000 3300 60  0001 C CNN
F 3 "" H 2000 3300 60  0001 C CNN
	3    2000 3300
	0    -1   -1   0   
$EndComp
Text GLabel 7350 2200 1    39   Input ~ 0
SERDES_HDMI_IN0_M
Text GLabel 7250 2200 1    39   Input ~ 0
SERDES_HDMI_IN0_P
Text GLabel 7150 2200 1    39   Input ~ 0
SERDES_HDMI_IN1_M
Text GLabel 7050 2200 1    39   Input ~ 0
SERDES_HDMI_IN1_P
Text GLabel 6950 2200 1    39   Input ~ 0
SERDES_HDMI_IN2_M
Text GLabel 6850 2200 1    39   Input ~ 0
SERDES_HDMI_IN2_P
Text GLabel 7350 5650 3    39   Input ~ 0
SERDES_HDMI_OUT0_M
Text GLabel 7250 5650 3    39   Input ~ 0
SERDES_HDMI_OUT0_P
Text GLabel 7150 5650 3    39   Input ~ 0
SERDES_HDMI_OUT1_M
Text GLabel 7050 5650 3    39   Input ~ 0
SERDES_HDMI_OUT1_P
Text GLabel 6950 5650 3    39   Input ~ 0
SERDES_HDMI_OUT2_M
Text GLabel 6850 5650 3    39   Input ~ 0
SERDES_HDMI_OUT2_P
Text GLabel 7950 4400 3    39   Input ~ 0
SERDES_REFCLK_M
Text GLabel 7850 4400 3    39   Input ~ 0
SERDES_REFCLK_P
Wire Wire Line
	7350 2200 7350 2300
Wire Wire Line
	7250 2200 7250 2300
Wire Wire Line
	7150 2200 7150 2300
Wire Wire Line
	7050 2200 7050 2300
Wire Wire Line
	6950 2200 6950 2300
Wire Wire Line
	6850 2200 6850 2300
Wire Wire Line
	7350 5350 7350 5650
Wire Wire Line
	7250 4800 7250 5650
Wire Wire Line
	7150 5350 7150 5650
Wire Wire Line
	7050 4800 7050 5650
Wire Wire Line
	6950 5350 6950 5650
Wire Wire Line
	6850 4400 6850 4300
Wire Wire Line
	7950 4300 7950 4400
Wire Wire Line
	7850 4300 7850 4400
Wire Wire Line
	5600 2200 5600 2300
Wire Wire Line
	5500 2200 5500 2300
Wire Wire Line
	5400 2200 5400 2300
Wire Wire Line
	5300 2200 5300 2300
Wire Wire Line
	5200 2200 5200 2300
Wire Wire Line
	5100 2200 5100 2300
Wire Wire Line
	5000 2200 5000 2300
Wire Wire Line
	4900 2200 4900 2300
Wire Wire Line
	4800 2200 4800 2300
Wire Wire Line
	4700 2200 4700 2300
Wire Wire Line
	4600 2200 4600 2300
Wire Wire Line
	4500 2200 4500 2300
Wire Wire Line
	4400 2200 4400 2300
Wire Wire Line
	4300 2200 4300 2300
Wire Wire Line
	4200 2200 4200 2300
Wire Wire Line
	4100 2200 4100 2300
Wire Wire Line
	4000 2200 4000 2300
Wire Wire Line
	3900 2200 3900 2300
Wire Wire Line
	3800 2200 3800 2300
Wire Wire Line
	3700 2200 3700 2300
Wire Wire Line
	3600 2200 3600 2300
Wire Wire Line
	3500 2200 3500 2300
Wire Wire Line
	3400 2200 3400 2300
Wire Wire Line
	3300 2200 3300 2300
NoConn ~ 3200 4300
NoConn ~ 3100 4300
NoConn ~ 3000 4300
NoConn ~ 2900 4300
NoConn ~ 2800 4300
NoConn ~ 2700 4300
NoConn ~ 2600 4300
NoConn ~ 2500 4300
NoConn ~ 3200 2300
NoConn ~ 3100 2300
NoConn ~ 3000 2300
NoConn ~ 2900 2300
NoConn ~ 2800 2300
NoConn ~ 2700 2300
NoConn ~ 2600 2300
NoConn ~ 2500 2300
Text GLabel 5600 2200 1    39   Input ~ 0
SD_CH0_RX0
Text GLabel 5500 2200 1    39   Input ~ 0
SD_CH0_RX1
Text GLabel 5400 2200 1    39   Input ~ 0
SD_CH0_RX2
Text GLabel 5300 2200 1    39   Input ~ 0
SD_CH0_RX3
Text GLabel 5200 2200 1    39   Input ~ 0
SD_CH0_RX4
Text GLabel 5100 2200 1    39   Input ~ 0
SD_CH0_RX5
Text GLabel 5000 2200 1    39   Input ~ 0
SD_CH0_RX6
Text GLabel 4900 2200 1    39   Input ~ 0
SD_CH0_RX7
Text GLabel 6500 2200 1    39   Input ~ 0
SD_CH0_RX8
Text GLabel 6100 2200 1    39   Input ~ 0
SD_CH0_RX9
Text GLabel 4800 2200 1    39   Input ~ 0
SD_CH1_RX0
Text GLabel 4700 2200 1    39   Input ~ 0
SD_CH1_RX1
Text GLabel 6000 2200 1    39   Input ~ 0
SD_CH1_RX9
Text GLabel 6400 2200 1    39   Input ~ 0
SD_CH1_RX8
Text GLabel 4100 2200 1    39   Input ~ 0
SD_CH1_RX7
Text GLabel 4200 2200 1    39   Input ~ 0
SD_CH1_RX6
Text GLabel 4300 2200 1    39   Input ~ 0
SD_CH1_RX5
Text GLabel 4400 2200 1    39   Input ~ 0
SD_CH1_RX4
Text GLabel 4500 2200 1    39   Input ~ 0
SD_CH1_RX3
Text GLabel 4600 2200 1    39   Input ~ 0
SD_CH1_RX2
Text GLabel 3800 2200 1    39   Input ~ 0
SD_CH2_RX2
Text GLabel 3700 2200 1    39   Input ~ 0
SD_CH2_RX3
Text GLabel 3600 2200 1    39   Input ~ 0
SD_CH2_RX4
Text GLabel 3500 2200 1    39   Input ~ 0
SD_CH2_RX5
Text GLabel 3400 2200 1    39   Input ~ 0
SD_CH2_RX6
Text GLabel 3300 2200 1    39   Input ~ 0
SD_CH2_RX7
Text GLabel 6300 2200 1    39   Input ~ 0
SD_CH2_RX8
Text GLabel 5900 2200 1    39   Input ~ 0
SD_CH2_RX9
Text GLabel 3900 2200 1    39   Input ~ 0
SD_CH2_RX1
Text GLabel 4000 2200 1    39   Input ~ 0
SD_CH2_RX0
Wire Wire Line
	6500 2200 6500 2300
Wire Wire Line
	6400 2200 6400 2300
Wire Wire Line
	6300 2200 6300 2300
Wire Wire Line
	6100 2200 6100 2300
Wire Wire Line
	6000 2200 6000 2300
Wire Wire Line
	5900 2200 5900 2300
Text GLabel 5600 4400 3    39   Input ~ 0
SD_CH0_TX0
Text GLabel 5500 4400 3    39   Input ~ 0
SD_CH0_TX1
Text GLabel 5400 4400 3    39   Input ~ 0
SD_CH0_TX2
Text GLabel 5300 4400 3    39   Input ~ 0
SD_CH0_TX3
Text GLabel 5200 4400 3    39   Input ~ 0
SD_CH0_TX4
Text GLabel 5100 4400 3    39   Input ~ 0
SD_CH0_TX5
Text GLabel 5000 4400 3    39   Input ~ 0
SD_CH0_TX6
Text GLabel 4900 4400 3    39   Input ~ 0
SD_CH0_TX7
Text GLabel 6500 4400 3    39   Input ~ 0
SD_CH0_TX8
Text GLabel 6100 4400 3    39   Input ~ 0
SD_CH0_TX9
Text GLabel 4800 4400 3    39   Input ~ 0
SD_CH1_TX0
Text GLabel 4700 4400 3    39   Input ~ 0
SD_CH1_TX1
Text GLabel 6000 4400 3    39   Input ~ 0
SD_CH1_TX9
Text GLabel 6400 4400 3    39   Input ~ 0
SD_CH1_TX8
Text GLabel 4100 4400 3    39   Input ~ 0
SD_CH1_TX7
Text GLabel 4200 4400 3    39   Input ~ 0
SD_CH1_TX6
Text GLabel 4300 4400 3    39   Input ~ 0
SD_CH1_TX5
Text GLabel 4400 4400 3    39   Input ~ 0
SD_CH1_TX4
Text GLabel 4500 4400 3    39   Input ~ 0
SD_CH1_TX3
Text GLabel 4600 4400 3    39   Input ~ 0
SD_CH1_TX2
Text GLabel 3800 4400 3    39   Input ~ 0
SD_CH2_TX2
Text GLabel 3700 4400 3    39   Input ~ 0
SD_CH2_TX3
Text GLabel 3600 4400 3    39   Input ~ 0
SD_CH2_TX4
Text GLabel 3500 4400 3    39   Input ~ 0
SD_CH2_TX5
Text GLabel 3400 4400 3    39   Input ~ 0
SD_CH2_TX6
Text GLabel 3300 4400 3    39   Input ~ 0
SD_CH2_TX7
Text GLabel 6300 4400 3    39   Input ~ 0
SD_CH2_TX8
Text GLabel 5900 4400 3    39   Input ~ 0
SD_CH2_TX9
Text GLabel 3900 4400 3    39   Input ~ 0
SD_CH2_TX1
Text GLabel 4000 4400 3    39   Input ~ 0
SD_CH2_TX0
NoConn ~ 2050 2300
NoConn ~ 2050 4300
Text GLabel 2150 2200 1    39   Input ~ 0
SD_CH2_RXCLK
Text GLabel 2250 2200 1    39   Input ~ 0
SD_CH1_RXCLK
Text GLabel 2350 2200 1    39   Input ~ 0
SD_CH0_RXCLK
Wire Wire Line
	2350 2200 2350 2300
Wire Wire Line
	2250 2200 2250 2300
Wire Wire Line
	2150 2200 2150 2300
Text GLabel 2350 4400 3    39   Input ~ 0
SD_CH0_TXCLK
Text GLabel 2250 4400 3    39   Input ~ 0
SD_CH1_TXCLK
Text GLabel 2150 4400 3    39   Input ~ 0
SD_CH2_TXCLK
NoConn ~ 6650 4300
NoConn ~ 6750 4300
NoConn ~ 6650 2300
NoConn ~ 6750 2300
NoConn ~ 7650 4300
NoConn ~ 5800 2300
NoConn ~ 5800 4300
NoConn ~ 6200 4300
NoConn ~ 6200 2300
$Comp
L C C501
U 1 1 517549CB
P 6850 4600
F 0 "C501" H 6900 4700 50  0000 L CNN
F 1 "0.1uF" V 6800 4300 50  0000 L CNN
F 2 "daisho:GSG-0402" H 6850 4600 60  0001 C CNN
F 3 "" H 6850 4600 60  0001 C CNN
F 4 "Murata" H 3800 3300 60  0001 C CNN "Manufacturer"
F 5 "GRM155R61A104KA01D" H 3800 3300 60  0001 C CNN "Part Number"
F 6 "CAP CER 0.1UF 10V 10% X5R 0402" H 3800 3300 60  0001 C CNN "Description"
	1    6850 4600
	1    0    0    -1  
$EndComp
$Comp
L C C502
U 1 1 517549D1
P 6950 5150
F 0 "C502" H 7000 5250 50  0000 L CNN
F 1 "0.1uF" V 6900 4850 50  0000 L CNN
F 2 "daisho:GSG-0402" H 6950 5150 60  0001 C CNN
F 3 "" H 6950 5150 60  0001 C CNN
F 4 "Murata" H 3800 3300 60  0001 C CNN "Manufacturer"
F 5 "GRM155R61A104KA01D" H 3800 3300 60  0001 C CNN "Part Number"
F 6 "CAP CER 0.1UF 10V 10% X5R 0402" H 3800 3300 60  0001 C CNN "Description"
	1    6950 5150
	1    0    0    -1  
$EndComp
$Comp
L C C503
U 1 1 517549F1
P 7050 4600
F 0 "C503" H 7100 4700 50  0000 L CNN
F 1 "0.1uF" V 7000 4300 50  0000 L CNN
F 2 "daisho:GSG-0402" H 7050 4600 60  0001 C CNN
F 3 "" H 7050 4600 60  0001 C CNN
F 4 "Murata" H 3800 3300 60  0001 C CNN "Manufacturer"
F 5 "GRM155R61A104KA01D" H 3800 3300 60  0001 C CNN "Part Number"
F 6 "CAP CER 0.1UF 10V 10% X5R 0402" H 3800 3300 60  0001 C CNN "Description"
	1    7050 4600
	1    0    0    -1  
$EndComp
$Comp
L C C504
U 1 1 51754A0F
P 7150 5150
F 0 "C504" H 7200 5250 50  0000 L CNN
F 1 "0.1uF" V 7100 4850 50  0000 L CNN
F 2 "daisho:GSG-0402" H 7150 5150 60  0001 C CNN
F 3 "" H 7150 5150 60  0001 C CNN
F 4 "Murata" H 3800 3300 60  0001 C CNN "Manufacturer"
F 5 "GRM155R61A104KA01D" H 3800 3300 60  0001 C CNN "Part Number"
F 6 "CAP CER 0.1UF 10V 10% X5R 0402" H 3800 3300 60  0001 C CNN "Description"
	1    7150 5150
	1    0    0    -1  
$EndComp
$Comp
L C C505
U 1 1 51754A15
P 7250 4600
F 0 "C505" H 7300 4700 50  0000 L CNN
F 1 "0.1uF" V 7200 4300 50  0000 L CNN
F 2 "daisho:GSG-0402" H 7250 4600 60  0001 C CNN
F 3 "" H 7250 4600 60  0001 C CNN
F 4 "Murata" H 3800 3300 60  0001 C CNN "Manufacturer"
F 5 "GRM155R61A104KA01D" H 3800 3300 60  0001 C CNN "Part Number"
F 6 "CAP CER 0.1UF 10V 10% X5R 0402" H 3800 3300 60  0001 C CNN "Description"
	1    7250 4600
	1    0    0    -1  
$EndComp
$Comp
L C C506
U 1 1 51754A1B
P 7350 5150
F 0 "C506" H 7400 5250 50  0000 L CNN
F 1 "0.1uF" V 7300 4850 50  0000 L CNN
F 2 "daisho:GSG-0402" H 7350 5150 60  0001 C CNN
F 3 "" H 7350 5150 60  0001 C CNN
F 4 "Murata" H 3800 3300 60  0001 C CNN "Manufacturer"
F 5 "GRM155R61A104KA01D" H 3800 3300 60  0001 C CNN "Part Number"
F 6 "CAP CER 0.1UF 10V 10% X5R 0402" H 3800 3300 60  0001 C CNN "Description"
	1    7350 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 4300 7350 4950
Wire Wire Line
	7250 4300 7250 4400
Wire Wire Line
	7150 4300 7150 4950
Wire Wire Line
	7050 4300 7050 4400
Wire Wire Line
	6950 4300 6950 4950
Wire Wire Line
	6850 4800 6850 5650
Text Notes 3400 900  0    40   ~ 0
Pins are assigned for use in TBID Mode (Ten Bit Interface DDR).\nPins are configured for 1.5 V HSTL.
Wire Wire Line
	5900 4300 5900 4400
Wire Wire Line
	6000 4400 6000 4300
Wire Wire Line
	6100 4300 6100 4400
Wire Wire Line
	6300 4400 6300 4300
Wire Wire Line
	6400 4300 6400 4400
Wire Wire Line
	6500 4400 6500 4300
Wire Wire Line
	2150 4300 2150 4400
Wire Wire Line
	2250 4400 2250 4300
Wire Wire Line
	2350 4300 2350 4400
Wire Wire Line
	5600 4300 5600 4400
Wire Wire Line
	5500 4400 5500 4300
Wire Wire Line
	5400 4300 5400 4400
Wire Wire Line
	5300 4400 5300 4300
Wire Wire Line
	5200 4300 5200 4400
Wire Wire Line
	5100 4400 5100 4300
Wire Wire Line
	5000 4300 5000 4400
Wire Wire Line
	4900 4400 4900 4300
Wire Wire Line
	4800 4300 4800 4400
Wire Wire Line
	4700 4400 4700 4300
Wire Wire Line
	4600 4300 4600 4400
Wire Wire Line
	4500 4400 4500 4300
Wire Wire Line
	4400 4300 4400 4400
Wire Wire Line
	4300 4400 4300 4300
Wire Wire Line
	4200 4300 4200 4400
Wire Wire Line
	4100 4400 4100 4300
Wire Wire Line
	4000 4300 4000 4400
Wire Wire Line
	3900 4400 3900 4300
Wire Wire Line
	3800 4300 3800 4400
Wire Wire Line
	3700 4400 3700 4300
Wire Wire Line
	3600 4300 3600 4400
Wire Wire Line
	3500 4400 3500 4300
Wire Wire Line
	3400 4300 3400 4400
Wire Wire Line
	3300 4400 3300 4300
$EndSCHEMATC
