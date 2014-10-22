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
LIBS:hdmi-cache
EELAYER 24 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 7 9
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
L SI5338 U701
U 1 1 51473CC0
P 2350 3450
F 0 "U701" H 2650 3800 60  0000 C CNN
F 1 "SI5338B" H 2750 3700 60  0000 C CNN
F 2 "" H 2350 3450 60  0001 C CNN
F 3 "" H 2350 3450 60  0001 C CNN
F 4 "Silicon Labs" H 2350 3450 60  0001 C CNN "Manufacturer"
F 5 "SI5338B-B-GM" H 2350 3450 60  0001 C CNN "Part Number"
F 6 "IC CLK GEN I2C BUS PROG 24QFN" H 2350 3450 60  0001 C CNN "Description"
	1    2350 3450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR703
U 1 1 51473FA7
P 5700 2300
F 0 "#PWR703" H 5700 2300 30  0001 C CNN
F 1 "GND" H 5700 2230 30  0001 C CNN
F 2 "" H 5700 2300 60  0001 C CNN
F 3 "" H 5700 2300 60  0001 C CNN
	1    5700 2300
	1    0    0    -1  
$EndComp
$Comp
L C C701
U 1 1 51473FB6
P 3400 1500
F 0 "C701" H 3450 1600 50  0000 L CNN
F 1 "0.1uF" H 3450 1400 50  0000 L CNN
F 2 "" H 3400 1500 60  0001 C CNN
F 3 "" H 3400 1500 60  0001 C CNN
	1    3400 1500
	0    1    1    0   
$EndComp
$Comp
L C C702
U 1 1 51474262
P 5800 1900
F 0 "C702" H 5850 2000 50  0000 L CNN
F 1 "0.1uF" H 5850 1800 50  0000 L CNN
F 2 "" H 5800 1900 60  0001 C CNN
F 3 "" H 5800 1900 60  0001 C CNN
	1    5800 1900
	1    0    0    -1  
$EndComp
$Comp
L C C703
U 1 1 51474272
P 6100 1900
F 0 "C703" H 6150 2000 50  0000 L CNN
F 1 "0.1uF" H 6150 1800 50  0000 L CNN
F 2 "" H 6100 1900 60  0001 C CNN
F 3 "" H 6100 1900 60  0001 C CNN
	1    6100 1900
	1    0    0    -1  
$EndComp
$Comp
L C C704
U 1 1 51474278
P 6400 1900
F 0 "C704" H 6450 2000 50  0000 L CNN
F 1 "0.1uF" H 6450 1800 50  0000 L CNN
F 2 "" H 6400 1900 60  0001 C CNN
F 3 "" H 6400 1900 60  0001 C CNN
	1    6400 1900
	1    0    0    -1  
$EndComp
$Comp
L C C705
U 1 1 5147427E
P 6700 1900
F 0 "C705" H 6750 2000 50  0000 L CNN
F 1 "0.1uF" H 6750 1800 50  0000 L CNN
F 2 "" H 6700 1900 60  0001 C CNN
F 3 "" H 6700 1900 60  0001 C CNN
	1    6700 1900
	1    0    0    -1  
$EndComp
$Comp
L C C706
U 1 1 51474284
P 7000 1900
F 0 "C706" H 7050 2000 50  0000 L CNN
F 1 "0.1uF" H 7050 1800 50  0000 L CNN
F 2 "" H 7000 1900 60  0001 C CNN
F 3 "" H 7000 1900 60  0001 C CNN
	1    7000 1900
	1    0    0    -1  
$EndComp
$Comp
L R R703
U 1 1 5147462D
P 3550 2350
F 0 "R703" V 3630 2350 50  0000 C CNN
F 1 "1.5K" V 3550 2350 50  0000 C CNN
F 2 "" H 3550 2350 60  0001 C CNN
F 3 "" H 3550 2350 60  0001 C CNN
	1    3550 2350
	0    -1   -1   0   
$EndComp
Text GLabel 3200 2250 1    39   Input ~ 0
SI5338_SDA
$Comp
L R R702
U 1 1 51474698
P 3500 4250
F 0 "R702" V 3580 4250 50  0000 C CNN
F 1 "1.5K" V 3500 4250 50  0000 C CNN
F 2 "" H 3500 4250 60  0001 C CNN
F 3 "" H 3500 4250 60  0001 C CNN
	1    3500 4250
	0    1    1    0   
$EndComp
$Comp
L R R701
U 1 1 5147469E
P 2400 4250
F 0 "R701" V 2480 4250 50  0000 C CNN
F 1 "1.5K" V 2400 4250 50  0000 C CNN
F 2 "" H 2400 4250 60  0001 C CNN
F 3 "" H 2400 4250 60  0001 C CNN
	1    2400 4250
	0    1    1    0   
$EndComp
Text GLabel 3150 4350 3    39   Input ~ 0
SI5338_SCL
Text GLabel 2750 4350 3    39   Input ~ 0
SI5338_INTR
$Comp
L GND #PWR702
U 1 1 51474CF6
P 2450 2350
F 0 "#PWR702" H 2450 2350 30  0001 C CNN
F 1 "GND" H 2450 2280 30  0001 C CNN
F 2 "" H 2450 2350 60  0001 C CNN
F 3 "" H 2450 2350 60  0001 C CNN
	1    2450 2350
	0    1    1    0   
$EndComp
Text GLabel 4500 2800 2    39   Input ~ 0
SERDES_REFCLK_P
Text GLabel 4500 2600 2    39   Input ~ 0
SERDES_REFCLK_M
Text GLabel 4500 3200 2    39   Input ~ 0
CLK_HDMI_OUT_P
Text GLabel 4500 3400 2    39   Input ~ 0
CLK_HDMI_OUT_M
Text Notes 4000 3800 0    40   ~ 0
HDMI output driver supports 3.0 Gbps at\n10 bits per TMDS clock cycle, so we need\nto support up to 300 MHz CLK_HDMI_OUT.
$Comp
L C C713
U 1 1 54445D42
P 4200 3200
F 0 "C713" H 4250 3300 50  0000 L CNN
F 1 "0.1uF" V 4150 2900 50  0000 L CNN
F 2 "" H 4200 3200 60  0001 C CNN
F 3 "" H 4200 3200 60  0001 C CNN
	1    4200 3200
	0    1    1    0   
$EndComp
$Comp
L C C714
U 1 1 54445D8B
P 4200 3400
F 0 "C714" H 4250 3500 50  0000 L CNN
F 1 "0.1uF" V 4150 3100 50  0000 L CNN
F 2 "" H 4200 3400 60  0001 C CNN
F 3 "" H 4200 3400 60  0001 C CNN
	1    4200 3400
	0    1    1    0   
$EndComp
$Comp
L C C709
U 1 1 544476FE
P 1650 3200
F 0 "C709" H 1700 3300 50  0000 L CNN
F 1 "0.1uF" V 1600 2900 50  0000 L CNN
F 2 "" H 1650 3200 60  0001 C CNN
F 3 "" H 1650 3200 60  0001 C CNN
	1    1650 3200
	0    1    1    0   
$EndComp
$Comp
L C C710
U 1 1 54447793
P 1650 3900
F 0 "C710" H 1700 4000 50  0000 L CNN
F 1 "0.1uF" V 1600 3600 50  0000 L CNN
F 2 "" H 1650 3900 60  0001 C CNN
F 3 "" H 1650 3900 60  0001 C CNN
	1    1650 3900
	0    1    1    0   
$EndComp
$Comp
L R R705
U 1 1 54447894
P 1300 3550
F 0 "R705" V 1380 3550 40  0000 C CNN
F 1 "100" V 1307 3551 40  0000 C CNN
F 2 "" V 1230 3550 30  0000 C CNN
F 3 "" H 1300 3550 30  0000 C CNN
	1    1300 3550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR701
U 1 1 54448CAF
P 1900 3100
F 0 "#PWR701" H 1900 3100 30  0001 C CNN
F 1 "GND" H 1900 3030 30  0001 C CNN
F 2 "" H 1900 3100 60  0000 C CNN
F 3 "" H 1900 3100 60  0000 C CNN
	1    1900 3100
	0    1    1    0   
$EndComp
Text Label 1950 3100 0    40   ~ 0
I2C_LSB
$Comp
L C C707
U 1 1 5444906D
P 1650 2100
F 0 "C707" H 1700 2200 50  0000 L CNN
F 1 "0.1uF" V 1600 1800 50  0000 L CNN
F 2 "" H 1650 2100 60  0001 C CNN
F 3 "" H 1650 2100 60  0001 C CNN
	1    1650 2100
	0    1    1    0   
$EndComp
$Comp
L C C708
U 1 1 54449073
P 1650 2800
F 0 "C708" H 1700 2900 50  0000 L CNN
F 1 "0.1uF" V 1600 2500 50  0000 L CNN
F 2 "" H 1650 2800 60  0001 C CNN
F 3 "" H 1650 2800 60  0001 C CNN
	1    1650 2800
	0    1    1    0   
$EndComp
$Comp
L R R704
U 1 1 54449079
P 1300 2450
F 0 "R704" V 1380 2450 40  0000 C CNN
F 1 "100" V 1307 2451 40  0000 C CNN
F 2 "" V 1230 2450 30  0000 C CNN
F 3 "" H 1300 2450 30  0000 C CNN
	1    1300 2450
	1    0    0    -1  
$EndComp
Text GLabel 1200 3900 0    39   Input ~ 0
CLK_IN_M_EQ
Text GLabel 1200 3200 0    39   Input ~ 0
CLK_IN_P_EQ
Text GLabel 1200 2100 0    39   Input ~ 0
FE_CLK_P0
Text GLabel 1200 2800 0    39   Input ~ 0
FE_CLK_N0
Text GLabel 2900 1750 1    39   Input ~ 0
FE_CLKSRC
NoConn ~ 3000 2450
Text Notes 550  3050 0    40   ~ 0
TODO: single-ended clock\ninput from FPGA on IN3?
NoConn ~ 2200 3000
Text GLabel 2700 2250 1    39   Input ~ 0
V2P5_REGULATED
NoConn ~ 2850 3750
NoConn ~ 2950 3750
$Comp
L R R706
U 1 1 5444DA71
P 2900 2100
F 0 "R706" V 2900 2150 50  0000 C CNN
F 1 "20" V 2900 2000 50  0000 C CNN
F 2 "" H 2900 2100 60  0001 C CNN
F 3 "" H 2900 2100 60  0001 C CNN
F 4 "Panasonic" H 2900 2100 60  0001 C CNN "Manufacturer"
F 5 "ERJ-2RKF20R0X" H 2900 2100 60  0001 C CNN "Part#"
F 6 "RES 20.0 OHM 1/10W 1% 0402 SMD" H 2900 2100 60  0001 C CNN "Description"
	1    2900 2100
	1    0    0    -1  
$EndComp
Text GLabel 3850 2350 2    39   Input ~ 0
V2P5_REGULATED
Text GLabel 3900 3000 2    39   Input ~ 0
V2P5_REGULATED
Text GLabel 2550 3850 0    39   Input ~ 0
V2P5_REGULATED
Text GLabel 3850 4250 2    39   Input ~ 0
V2P5_REGULATED
Text GLabel 2050 4250 0    39   Input ~ 0
V2P5_REGULATED
$Comp
L C C712
U 1 1 54451C4E
P 4200 2800
F 0 "C712" H 4250 2900 50  0000 L CNN
F 1 "0.1uF" V 4150 2500 50  0000 L CNN
F 2 "" H 4200 2800 60  0001 C CNN
F 3 "" H 4200 2800 60  0001 C CNN
	1    4200 2800
	0    1    1    0   
$EndComp
$Comp
L C C711
U 1 1 54451C82
P 4200 2600
F 0 "C711" H 4250 2700 50  0000 L CNN
F 1 "0.1uF" V 4150 2300 50  0000 L CNN
F 2 "" H 4200 2600 60  0001 C CNN
F 3 "" H 4200 2600 60  0001 C CNN
	1    4200 2600
	0    1    1    0   
$EndComp
Text GLabel 3100 1400 1    39   Input ~ 0
V3P3_REGULATED
Text GLabel 5700 1500 1    39   Input ~ 0
V2P5_REGULATED
$Comp
L GND #PWR?
U 1 1 54475316
P 3700 1500
F 0 "#PWR?" H 3700 1500 30  0001 C CNN
F 1 "GND" H 3700 1430 30  0001 C CNN
F 2 "" H 3700 1500 60  0000 C CNN
F 3 "" H 3700 1500 60  0000 C CNN
	1    3700 1500
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3700 3000 3800 3000
Wire Wire Line
	3800 3000 3900 3000
Wire Wire Line
	3700 3100 3800 3100
Wire Wire Line
	3800 3100 3800 3000
Connection ~ 3800 3000
Wire Wire Line
	3050 3850 3050 3750
Wire Wire Line
	2550 3850 2650 3850
Wire Wire Line
	2650 3850 3050 3850
Connection ~ 2650 3850
Wire Wire Line
	3200 2250 3200 2350
Wire Wire Line
	3200 2350 3200 2450
Wire Wire Line
	3200 2350 3300 2350
Connection ~ 3200 2350
Wire Wire Line
	3800 2350 3850 2350
Wire Wire Line
	2750 3750 2750 4250
Wire Wire Line
	2750 4250 2750 4350
Wire Wire Line
	3150 3750 3150 4250
Wire Wire Line
	3150 4250 3150 4350
Wire Wire Line
	3150 4250 3250 4250
Connection ~ 2750 4250
Connection ~ 3150 4250
Wire Wire Line
	2750 4250 2650 4250
Wire Wire Line
	2450 2350 2600 2350
Wire Wire Line
	2600 2350 2800 2350
Wire Wire Line
	2800 2350 2800 2450
Wire Wire Line
	2600 2450 2600 2350
Connection ~ 2600 2350
Wire Wire Line
	1850 3200 2200 3200
Wire Wire Line
	3700 3200 4000 3200
Wire Wire Line
	3700 3300 3800 3300
Wire Wire Line
	2650 3850 2650 3750
Wire Wire Line
	4500 3200 4400 3200
Wire Wire Line
	4400 3400 4500 3400
Wire Wire Line
	3800 3300 3800 3400
Wire Wire Line
	3800 3400 4000 3400
Wire Wire Line
	2200 3300 1950 3300
Wire Wire Line
	1950 3300 1950 3900
Wire Wire Line
	1950 3900 1850 3900
Wire Wire Line
	1200 3900 1300 3900
Wire Wire Line
	1300 3900 1450 3900
Wire Wire Line
	1300 3900 1300 3800
Wire Wire Line
	1300 3300 1300 3200
Wire Wire Line
	1200 3200 1300 3200
Wire Wire Line
	1300 3200 1450 3200
Connection ~ 1300 3200
Connection ~ 1300 3900
Wire Wire Line
	2200 3100 1900 3100
Wire Wire Line
	1200 2800 1300 2800
Wire Wire Line
	1300 2800 1450 2800
Wire Wire Line
	1300 2800 1300 2700
Wire Wire Line
	1300 2200 1300 2100
Wire Wire Line
	1200 2100 1300 2100
Wire Wire Line
	1300 2100 1450 2100
Connection ~ 1300 2100
Connection ~ 1300 2800
Wire Wire Line
	2200 2900 1950 2900
Wire Wire Line
	1950 2900 1950 2800
Wire Wire Line
	1950 2800 1850 2800
Wire Wire Line
	2200 2800 2050 2800
Wire Wire Line
	2050 2800 2050 2100
Wire Wire Line
	2050 2100 1850 2100
Wire Wire Line
	2900 2450 2900 2350
Wire Wire Line
	2900 1750 2900 1850
Wire Wire Line
	2050 4250 2150 4250
Wire Wire Line
	3750 4250 3850 4250
Wire Wire Line
	3700 2900 3900 2900
Wire Wire Line
	3900 2900 3900 2800
Wire Wire Line
	3900 2800 4000 2800
Wire Wire Line
	3700 2800 3800 2800
Wire Wire Line
	3800 2800 3800 2600
Wire Wire Line
	3800 2600 4000 2600
Wire Wire Line
	4400 2600 4500 2600
Wire Wire Line
	4500 2800 4400 2800
Wire Wire Line
	3100 1400 3100 1500
Wire Wire Line
	3100 1500 3100 2450
Wire Wire Line
	2700 2250 2700 2450
Wire Wire Line
	5700 2300 5700 2200
Wire Wire Line
	5700 2200 5800 2200
Wire Wire Line
	5800 2200 6100 2200
Wire Wire Line
	6100 2200 6400 2200
Wire Wire Line
	6400 2200 6700 2200
Wire Wire Line
	6700 2200 7000 2200
Wire Wire Line
	7000 2200 7000 2100
Wire Wire Line
	5700 1500 5700 1600
Wire Wire Line
	5700 1600 5800 1600
Wire Wire Line
	5800 1600 6100 1600
Wire Wire Line
	6100 1600 6400 1600
Wire Wire Line
	6400 1600 6700 1600
Wire Wire Line
	6700 1600 7000 1600
Wire Wire Line
	7000 1600 7000 1700
Wire Wire Line
	6700 1600 6700 1700
Connection ~ 6700 1600
Wire Wire Line
	6400 1600 6400 1700
Connection ~ 6400 1600
Wire Wire Line
	6100 1600 6100 1700
Connection ~ 6100 1600
Wire Wire Line
	5800 1600 5800 1700
Connection ~ 5800 1600
Wire Wire Line
	5800 2100 5800 2200
Connection ~ 5800 2200
Wire Wire Line
	6100 2100 6100 2200
Connection ~ 6100 2200
Wire Wire Line
	6400 2100 6400 2200
Connection ~ 6400 2200
Wire Wire Line
	6700 2100 6700 2200
Connection ~ 6700 2200
Wire Wire Line
	3700 1500 3600 1500
Wire Wire Line
	3100 1500 3200 1500
Connection ~ 3100 1500
$EndSCHEMATC
