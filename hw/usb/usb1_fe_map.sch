EESchema Schematic File Version 2  date Wed 19 Feb 2014 10:16:01 PM PST
LIBS:power
LIBS:device
LIBS:ep4ce30f29
LIBS:gsg-ip4220cz6
LIBS:quartzcms4_ground
LIBS:tusb1310a
LIBS:usb3_esd_son50-10
LIBS:usb3_micro_ab
LIBS:tps62420
LIBS:mic5207-bm5
LIBS:samtec_qsh-090-d
LIBS:tps2065c-2
LIBS:barrel_jack
LIBS:on_cat24c256
LIBS:conn
LIBS:tps54821
LIBS:hole
LIBS:usb-cache
EELAYER 25  0
EELAYER END
$Descr A3 16535 11700
encoding utf-8
Sheet 3 9
Title "Daisho Project USB Front-End"
Date "17 feb 2014"
Rev ""
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright © 2014 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7100 3600 8700 3600
Wire Wire Line
	5900 8600 4000 8600
Wire Wire Line
	5900 8400 4000 8400
Wire Wire Line
	5900 8200 4000 8200
Wire Wire Line
	5900 8000 4000 8000
Wire Wire Line
	5900 7800 4000 7800
Wire Wire Line
	5900 7600 4000 7600
Wire Wire Line
	5900 7400 4000 7400
Wire Wire Line
	5900 7200 4000 7200
Wire Wire Line
	5900 7000 4000 7000
Wire Wire Line
	5900 6800 4000 6800
Wire Wire Line
	5900 6600 4000 6600
Wire Wire Line
	5900 6400 4000 6400
Wire Wire Line
	5900 6200 4000 6200
Wire Wire Line
	4000 6000 5900 6000
Wire Wire Line
	4000 5800 5900 5800
Wire Wire Line
	4000 5600 5900 5600
Wire Wire Line
	4000 5400 5900 5400
Wire Wire Line
	4000 5200 5900 5200
Wire Wire Line
	4000 5000 5900 5000
Wire Wire Line
	4000 4800 5900 4800
Wire Wire Line
	4000 4600 5900 4600
Wire Wire Line
	4000 4400 5900 4400
Wire Wire Line
	4000 4200 5900 4200
Wire Wire Line
	5900 4000 4000 4000
Wire Wire Line
	5900 3800 4000 3800
Wire Wire Line
	4000 3600 5900 3600
Wire Wire Line
	1200 900  13000 900 
Wire Wire Line
	1200 1100 13000 1100
Wire Wire Line
	4000 3700 5900 3700
Wire Wire Line
	4000 3900 5900 3900
Wire Wire Line
	4000 4100 5900 4100
Wire Wire Line
	5900 4300 4000 4300
Wire Wire Line
	5900 4500 4000 4500
Wire Wire Line
	5900 4700 4000 4700
Wire Wire Line
	5900 4900 4000 4900
Wire Wire Line
	5900 5100 4000 5100
Wire Wire Line
	5900 5300 4000 5300
Wire Wire Line
	5900 5500 4000 5500
Wire Wire Line
	5900 5700 4000 5700
Wire Wire Line
	5900 5900 4000 5900
Wire Wire Line
	4000 6100 5900 6100
Wire Wire Line
	4000 6300 5900 6300
Wire Wire Line
	4000 6500 5900 6500
Wire Wire Line
	4000 6700 5900 6700
Wire Wire Line
	4000 6900 5900 6900
Wire Wire Line
	4000 7100 5900 7100
Wire Wire Line
	4000 7300 5900 7300
Wire Wire Line
	4000 7500 5900 7500
Wire Wire Line
	4000 7700 5900 7700
Wire Wire Line
	4000 7900 5900 7900
Wire Wire Line
	4000 8100 5900 8100
Wire Wire Line
	4000 8300 5900 8300
Wire Wire Line
	4000 8500 5900 8500
Wire Wire Line
	4000 8700 5900 8700
Text Label 8200 3600 0    60   ~ 0
ULPI_CLK
Text Label 5100 8700 0    60   ~ 0
ELAS_BUF_MODE
Text Label 5100 8600 0    60   ~ 0
RX_TERMINATION
Text Label 5100 8500 0    60   ~ 0
RX_POLARITY
Text Label 5100 8400 0    60   ~ 0
TX_DEEMPH1
Text Label 5100 8300 0    60   ~ 0
TX_DEEMPH0
Text Label 5100 8200 0    60   ~ 0
PWRPRESENT
Text Label 5100 8100 0    60   ~ 0
PHY_STATUS
Text Label 5100 8000 0    60   ~ 0
POWER_DOWN1
Text Label 5100 7900 0    60   ~ 0
POWER_DOWN0
Text Label 5100 7800 0    60   ~ 0
RX_STATUS2
Text Label 5100 7700 0    60   ~ 0
RX_STATUS1
Text Label 5100 7600 0    60   ~ 0
RX_STATUS0
Text Label 5100 7500 0    60   ~ 0
RX_ELECIDLE
Text Label 5100 7400 0    60   ~ 0
RX_VALID
Text Label 5100 7300 0    60   ~ 0
RX_DATAK1
Text Label 5100 7200 0    60   ~ 0
RX_DATAK0
Text Label 5100 7100 0    60   ~ 0
RX_DATA15
Text Label 5100 7000 0    60   ~ 0
RX_DATA14
Text Label 5100 6900 0    60   ~ 0
RX_DATA13
Text Label 5100 6800 0    60   ~ 0
RX_DATA12
Text Label 5100 6700 0    60   ~ 0
RX_DATA11
Text Label 5100 6600 0    60   ~ 0
RX_DATA10
Text Label 5100 6500 0    60   ~ 0
RX_DATA9
Text Label 5100 6400 0    60   ~ 0
RX_DATA8
Text Label 5100 6300 0    60   ~ 0
RX_DATA7
Text Label 5100 6200 0    60   ~ 0
RX_DATA6
Text Label 5100 6100 0    60   ~ 0
RX_DATA5
Text Label 5100 6000 0    60   ~ 0
RX_DATA4
Text Label 5100 5900 0    60   ~ 0
RX_DATA3
Text Label 5100 5800 0    60   ~ 0
RX_DATA2
Text Label 5100 5700 0    60   ~ 0
RX_DATA1
Text Label 5100 5600 0    60   ~ 0
RX_DATA0
Text Label 5100 5500 0    60   ~ 0
PCLK
Text Label 5100 5400 0    60   ~ 0
TX_DATAK1
Text Label 5100 5300 0    60   ~ 0
TX_DATAK0
Text Label 5100 5200 0    60   ~ 0
TX_DATA15
Text Label 5100 5100 0    60   ~ 0
TX_DATA14
Text Label 5100 5000 0    60   ~ 0
TX_DATA13
Text Label 5100 4900 0    60   ~ 0
TX_DATA12
Text Label 5100 4800 0    60   ~ 0
TX_DATA11
Text Label 5100 4700 0    60   ~ 0
TX_DATA10
Text Label 5100 4600 0    60   ~ 0
TX_DATA9
Text Label 5100 4500 0    60   ~ 0
TX_DATA8
Text Label 5100 4400 0    60   ~ 0
TX_DATA7
Text Label 5100 4300 0    60   ~ 0
TX_DATA6
Text Label 5100 4200 0    60   ~ 0
TX_DATA5
Text Label 5100 4100 0    60   ~ 0
TX_DATA4
Text Label 5100 4000 0    60   ~ 0
TX_DATA3
Text Label 5100 3900 0    60   ~ 0
TX_DATA2
Text Label 5100 3800 0    60   ~ 0
TX_DATA1
Text Label 5100 3700 0    60   ~ 0
TX_DATA0
Text Label 5100 3600 0    60   ~ 0
TX_CLK
Text Label 4600 6400 0    60   ~ 0
FE_C51
Text Label 4600 7000 0    60   ~ 0
FE_C50
Text Label 4600 6200 0    60   ~ 0
FE_C49
Text Label 4600 7100 0    60   ~ 0
FE_C48
Text Label 4600 6100 0    60   ~ 0
FE_C47
Text Label 4600 6900 0    60   ~ 0
FE_C46
Text Label 4100 6000 0    60   ~ 0
FE_C45
Text Label 4600 6800 0    60   ~ 0
FE_C44
Text Label 4100 5900 0    60   ~ 0
FE_C43
Text Label 4600 7200 0    60   ~ 0
FE_C42
Text Label 4100 5700 0    60   ~ 0
FE_C41
Text Label 4600 7300 0    60   ~ 0
FE_C40
Text Label 4100 5800 0    60   ~ 0
FE_C39
Text Label 4600 6700 0    60   ~ 0
FE_C38
Text Label 4100 5600 0    60   ~ 0
FE_C37
Text Label 4600 6500 0    60   ~ 0
FE_C36
Text Label 4100 7400 0    60   ~ 0
FE_C35
Text Label 4100 8000 0    60   ~ 0
FE_C34
Text Label 4100 5200 0    60   ~ 0
FE_C33
Text Label 4600 6600 0    60   ~ 0
FE_C32
Text Label 4100 5400 0    60   ~ 0
FE_C31
Text Label 4600 6300 0    60   ~ 0
FE_C30
Text Label 4100 5100 0    60   ~ 0
FE_C29
Text Label 4600 4600 0    60   ~ 0
FE_C28
Text Label 4100 5000 0    60   ~ 0
FE_C27
Text Label 4600 4400 0    60   ~ 0
FE_C26
Text Label 4100 4900 0    60   ~ 0
FE_C25
Text Label 4600 4200 0    60   ~ 0
FE_C24
Text Label 7200 3600 0    60   ~ 0
FE_C23
Text Label 4600 4300 0    60   ~ 0
FE_C22
Text Label 4600 5500 0    60   ~ 0
FE_C21
Text Label 4600 4100 0    60   ~ 0
FE_C20
Text Label 4100 8500 0    60   ~ 0
FE_C19
Text Label 4600 4000 0    60   ~ 0
FE_C18
Text Label 4100 8200 0    60   ~ 0
FE_C17
Text Label 4600 3900 0    60   ~ 0
FE_C16
Text Label 4100 7900 0    60   ~ 0
FE_C15
Text Label 4100 7800 0    60   ~ 0
FE_C14
Text Label 4100 7700 0    60   ~ 0
FE_C13
Text Label 4600 3800 0    60   ~ 0
FE_C12
Text Label 4100 7600 0    60   ~ 0
FE_C11
Text Label 4600 3700 0    60   ~ 0
FE_C10
Text Label 4100 3600 0    60   ~ 0
FE_C9
Text Label 4600 4500 0    60   ~ 0
FE_C8
Text Label 4100 8600 0    60   ~ 0
FE_C7
Text Label 4100 4800 0    60   ~ 0
FE_C6
Text Label 4100 8400 0    60   ~ 0
FE_C5
Text Label 4100 8300 0    60   ~ 0
FE_C4
Text Label 4100 8100 0    60   ~ 0
FE_C3
Text Label 4100 5300 0    60   ~ 0
FE_C2
Text Label 4100 4700 0    60   ~ 0
FE_C1
Text Label 4100 7500 0    60   ~ 0
FE_C0
Text HLabel 13000 1100 2    60   Output ~ 0
XI
Text HLabel 13000 900  2    60   Input ~ 0
VCCIO_USB
Text HLabel 1200 2600 0    60   BiDi ~ 0
FE_C[51..0]
Text HLabel 1200 900  0    60   Output ~ 0
FE_VCCIO_C
Text HLabel 1200 1100 0    60   Input ~ 0
FE_CLK_P
Text HLabel 1200 1200 0    60   Input ~ 0
FE_CLK_N
Text HLabel 13000 5000 2    60   Output ~ 0
TX_CLK
Text HLabel 13000 5100 2    60   Output ~ 0
TX_DATA[15..0]
Text HLabel 13000 5200 2    60   Output ~ 0
TX_DATAK[1..0]
Text HLabel 13000 5400 2    60   Input ~ 0
PCLK
Text HLabel 13000 5500 2    60   Input ~ 0
RX_DATA[15..0]
Text HLabel 13000 5600 2    60   Input ~ 0
RX_DATAK[1..0]
Text HLabel 13000 5700 2    60   Input ~ 0
RX_VALID
Text HLabel 13000 5900 2    60   Output ~ 0
RESETN
Text HLabel 13000 6000 2    60   BiDi ~ 0
RX_ELECIDLE
Text HLabel 13000 6100 2    60   Input ~ 0
RX_STATUS[2..0]
Text HLabel 13000 6200 2    60   Output ~ 0
POWER_DOWN[1..0]
Text HLabel 13000 6300 2    60   BiDi ~ 0
PHY_STATUS
Text HLabel 13000 6400 2    60   Input ~ 0
PWRPRESENT
Text HLabel 13000 6600 2    60   Output ~ 0
TX_DEEMPH[1..0]
Text HLabel 13000 6700 2    60   Output ~ 0
RX_POLARITY
Text HLabel 13000 6800 2    60   Output ~ 0
RX_TERMINATION
Text HLabel 13000 6900 2    60   Output ~ 0
ELAS_BUF_MODE
Text HLabel 13000 7100 2    60   Input ~ 0
USB3_ID
Text HLabel 13000 4000 2    60   Output ~ 0
RATE
Text HLabel 13000 3900 2    60   Output ~ 0
TX_SWING
Text HLabel 13000 3800 2    60   Output ~ 0
TX_MARGIN[2..0]
Text HLabel 13000 3700 2    60   Output ~ 0
TX_ONESZEROS
Text HLabel 13000 3500 2    60   Output ~ 0
TX_ELECIDLE
Text HLabel 13000 3400 2    60   Output ~ 0
TX_DETRX_LPBK
Text HLabel 13000 3300 2    60   Output ~ 0
PHY_RESETN
Text HLabel 13000 3200 2    60   Output ~ 0
OUT_ENABLE
Text HLabel 13000 3000 2    60   Output ~ 0
ULPI_STP
Text HLabel 13000 2900 2    60   Input ~ 0
ULPI_NXT
Text HLabel 13000 2800 2    60   Input ~ 0
ULPI_DIR
Text HLabel 13000 2700 2    60   BiDi ~ 0
ULPI_DATA[7..0]
Text HLabel 13000 2600 2    60   Input ~ 0
ULPI_CLK
$EndSCHEMATC
