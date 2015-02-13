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
LIBS:samtec_qsh_090-d
LIBS:hole
LIBS:TRS3237E
LIBS:TRSF3243
LIBS:MUN5212DW1
LIBS:MIC5318
LIBS:rs232_fe-cache
EELAYER 24 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 6
Title "Daisho Project RS232 Front-End Board"
Date "27 sep 2014"
Rev "1.0 Rev1"
Comp ""
Comment1 "Copyright © 2013/2014 Benjamin Vernoux"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L HOLE H3
U 1 1 51D6408B
P 1200 7050
F 0 "H3" H 1200 7200 60  0000 C CNN
F 1 "HOLE" H 1200 6900 60  0000 C CNN
F 2 "gsg-hole126mil:GSG-HOLE126MIL" H 1200 7050 60  0001 C CNN
F 3 "" H 1200 7050 60  0001 C CNN
F 4 "DNP" H 1200 7050 60  0001 C CNN "Note"
	1    1200 7050
	1    0    0    -1  
$EndComp
$Comp
L HOLE H2
U 1 1 51D64091
P 1500 6600
F 0 "H2" H 1500 6750 60  0000 C CNN
F 1 "HOLE" H 1500 6450 60  0000 C CNN
F 2 "gsg-hole126mil:GSG-HOLE126MIL" H 1500 6600 60  0001 C CNN
F 3 "" H 1500 6600 60  0001 C CNN
F 4 "DNP" H 1500 6600 60  0001 C CNN "Note"
	1    1500 6600
	1    0    0    -1  
$EndComp
$Comp
L HOLE H4
U 1 1 51D6409D
P 1500 7050
F 0 "H4" H 1500 7200 60  0000 C CNN
F 1 "HOLE" H 1500 6900 60  0000 C CNN
F 2 "gsg-hole126mil:GSG-HOLE126MIL" H 1500 7050 60  0001 C CNN
F 3 "" H 1500 7050 60  0001 C CNN
F 4 "DNP" H 1500 7050 60  0001 C CNN "Note"
	1    1500 7050
	1    0    0    -1  
$EndComp
$Comp
L HOLE H1
U 1 1 51D640A3
P 1200 6600
F 0 "H1" H 1200 6750 60  0000 C CNN
F 1 "HOLE" H 1200 6450 60  0000 C CNN
F 2 "gsg-hole126mil:GSG-HOLE126MIL" H 1200 6600 60  0001 C CNN
F 3 "" H 1200 6600 60  0001 C CNN
F 4 "DNP" H 1200 6600 60  0001 C CNN "Note"
	1    1200 6600
	1    0    0    -1  
$EndComp
$Sheet
S 1500 1200 2000 600 
U 51D64179
F0 "daisho_connector" 50
F1 "daisho_connector.sch" 50
$EndSheet
$Sheet
S 1500 2050 2000 550 
U 51D6FD50
F0 "rs232_pair_AB" 50
F1 "rs232_pair_AB.sch" 50
$EndSheet
$Sheet
S 1500 2800 2000 600 
U 51D6FF00
F0 "rs232_pair_CD" 50
F1 "rs232_pair_CD.sch" 50
$EndSheet
$Sheet
S 3800 2050 1750 550 
U 51E2A630
F0 "rs232_pair_AB_LED" 50
F1 "rs232_pair_AB_LED.sch" 50
$EndSheet
$Sheet
S 3800 2800 1700 600 
U 51E2B108
F0 "rs232_pair_CD_LED" 50
F1 "rs232_pair_CD_LED.sch" 50
$EndSheet
$EndSCHEMATC
