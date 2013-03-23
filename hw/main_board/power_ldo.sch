EESchema Schematic File Version 2  date Saturday, March 23, 2013 11:24:01 AM
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
LIBS:main_board-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 16 16
Title "Daisho Project Main Board"
Date "23 mar 2013"
Rev "0"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4500 3550 4750 3550
Wire Wire Line
	7450 4450 7200 4450
Wire Wire Line
	7200 4350 7450 4350
Wire Wire Line
	4500 3350 4750 3350
Wire Wire Line
	7450 3950 7200 3950
Wire Wire Line
	7200 4050 7450 4050
Wire Wire Line
	7450 4850 7200 4850
Wire Wire Line
	7450 3250 7200 3250
Wire Wire Line
	7200 3150 7450 3150
Wire Wire Line
	7450 4550 7200 4550
Wire Wire Line
	4750 3450 4500 3450
Text HLabel 4750 3550 2    60   Output ~ 0
FPGA_VCCD_PLL
Text HLabel 4750 3450 2    60   Output ~ 0
FPGA_VCCA
Text HLabel 7450 4450 2    60   Output ~ 0
DDR2_VCCSPD
Text HLabel 7450 4550 2    60   Output ~ 0
DDR2_VREF
Text HLabel 7450 4350 2    60   Output ~ 0
DDR2_1V8
Text HLabel 7450 3250 2    60   Output ~ 0
USB_VDD1P1
Text HLabel 7450 3150 2    60   Output ~ 0
USB_VDDA1P1
Text HLabel 4750 3350 2    60   Output ~ 0
FPGA_VCCINT
Text HLabel 7450 4850 2    60   Output ~ 0
USB_VDDA3P3
Text HLabel 7450 4050 2    60   Output ~ 0
USB_VDD1P8
Text HLabel 7450 3950 2    60   Output ~ 0
USB_VDDA1P8
$EndSCHEMATC
