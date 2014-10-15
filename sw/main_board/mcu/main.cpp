/* 
 * Monulator ARM LPC11U14 application.
 * 
 * Copyright (C) 2013 Jared Boone, ShareBrained Technology, Inc.
 * 
 * This file is part of the Monulator project.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#include "lpc11u.h"
#include "serial.h"

#include "i2c.h"
#include "si5351c.h"

#include <cstdint>

void turn_on_crystal_oscillator() {
	SCB.SYSOSCCTRL = 0;
	SCB.enable_power(SCB.PDRUNCFG_SYSOSC);
}

void start_system_pll() {
	// Start up system PLL: 12MHz crystal to 48 MHz.
	SCB.set_system_pll_dividers(1, 3);
	SCB.set_system_pll_clock_source(SCB.SYSPLLCLKSEL_SEL_CRYSTAL_OSCILLATOR);
	SCB.enable_power(SCB.PDRUNCFG_SYSPLL);
	SCB.wait_for_system_pll_lock();
}

void set_main_clock_to_system_pll() {
	// Switch main (and system clocks) to system PLL
	SCB.set_main_clock_source(SCB.MAINCLKSEL_SEL_PLL_OUTPUT);
}

void start_usb_pll() {
	// Start up USB PLL: 12MHz crystal to 48 MHz.
	SCB.set_usb_pll_dividers(1, 3);
	SCB.set_usb_pll_clock_source(SCB.USBPLLCLKSEL_SEL_SYSTEM_OSCILLATOR);
	SCB.enable_power(SCB.PDRUNCFG_USBPLL);
	SCB.wait_for_usb_pll_lock();
}

void set_usb_clock_to_main_clock() {
	// NOTE: Both clock sources must be running in order to switch!
	// So if you want to use the main clock instead of the USB PLL,
	// you have to start the USB PLL in order to switch away from it!
	SCB.set_usb_clock_source(SCB.USBCLKSEL_SEL_MAIN_CLOCK);
}

void set_usb_clock_to_usb_pll() {
	SCB.set_usb_clock_source(SCB.USBCLKSEL_SEL_USB_PLL_OUT);
}

void enable_peripheral_clocks() {
	SCB.set_system_clock_divider(1);
	SCB.enable_clocks(
		  SCB.SYSAHBCLKCTRL_GPIO
		//| SCB.SYSAHBCLKCTRL_CT16B0
		//| SCB.SYSAHBCLKCTRL_CT16B1
		//| SCB.SYSAHBCLKCTRL_CT32B0
		//| SCB.SYSAHBCLKCTRL_CT32B1
		| SCB.SYSAHBCLKCTRL_I2C
		| SCB.SYSAHBCLKCTRL_USART
		//| SCB.SYSAHBCLKCTRL_SSP1
		//| SCB.SYSAHBCLKCTRL_USB
		| SCB.SYSAHBCLKCTRL_IOCON
		//| SCB.SYSAHBCLKCTRL_RAM1	// Available on larger parts.
		| SCB.SYSAHBCLKCTRL_USBRAM
	);
}

void enable_clock_output() {
	SCB.set_clkout_clock_source(SCB.CLKOUTSEL_SEL_MAIN_CLOCK);
	SCB.set_clkout_divider(48);
	IOCON.PIO0_1 = 1;
}

void write_led_status(const uint_fast8_t value) {
	GPIO_PORT.write(0, 1, value);
}

void write_ddr2_sa(const uint_fast8_t value) {
	GPIO_PORT.write(0,  7, value & 2);
	GPIO_PORT.write(1, 24, value & 1);
}

void write_fe_en(const uint_fast8_t value) {
	GPIO_PORT.write(0, 20, value);
}

void fe_disable() {
	write_fe_en(0);
}

void fe_enable() {
	write_fe_en(1);
}

void write_v3p3a_enable(const uint_fast8_t value) {
	GPIO_PORT.write(0, 14, value);
}

void v3p3a_enable() {
	write_v3p3a_enable(1);
}

void v3p3a_disable() {
	write_v3p3a_enable(0);
}

void write_v2p5_enable(const uint_fast8_t value) {
	GPIO_PORT.write(0, 16, value);
}

void v2p5_enable() {
	write_v2p5_enable(1);
}

void v2p5_disable() {
	write_v2p5_enable(0);
}

void write_v1p8_enable(const uint_fast8_t value) {
	GPIO_PORT.write(1, 28, value);
}

void v1p8_enable() {
	write_v1p8_enable(1);
}

void v1p8_disable() {
	write_v1p8_enable(0);
}

void write_v1p2_enable(const uint_fast8_t value) {
	GPIO_PORT.write(0, 18, value);
}

void v1p2_enable() {
	write_v1p2_enable(1);
}

void v1p2_disable() {
	write_v1p2_enable(0);
}

void write_v1p1_enable(const uint_fast8_t value) {
	GPIO_PORT.write(0, 17, value);
}

void v1p1_enable() {
	write_v1p1_enable(1);
}

void v1p1_disable() {
	write_v1p1_enable(0);
}

void write_clockgen_oeb_n(const uint_fast8_t value) {
	GPIO_PORT.write(1, 14, value);
}

void clockgen_output_enable() {
	write_clockgen_oeb_n(0);
}

void clockgen_output_disable() {
	write_clockgen_oeb_n(1);
}

void write_v1px_smps_mode(const uint_fast8_t value) {
	GPIO_PORT.write(1, 25, value);
}

bool read_fpga_status() {
	return GPIO_PORT.read(1, 16) == 0;
}

bool read_fpga_conf_done() {
	return GPIO_PORT.read(0, 19) == 1;
}

void configure_pins() {
	// Configure port 0 pin directions
	GPIO_PORT.DIR0 |=
		  (1 << 20)	// FE_EN
		| (1 << 18)	// V1P2_ENABLE
		| (1 << 17)	// V1P1_ENABLE
		| (1 << 16)	// V2P5_ENABLE
		| (1 << 14)	// V3P3A_ENABLE
		| (1 << 13)	// USB_POWER_EN
		| (1 <<  7)	// DDR2_SA1
		| (1 <<  1)	// LED_STATUS
		;
	
	// Configure port 1 pin directions
	GPIO_PORT.DIR1 |=
		  (1 << 28)	// V1P8_ENABLE
		| (1 << 25)	// V1PX_SMPS_MODE
		| (1 << 24)	// DDR2_SA0
		| (1 << 14)	// CLOCKGEN_OEB#
		;
	
	// Set GPIO initial pin values
	write_led_status(0);
	write_ddr2_sa(0);
	fe_disable();
	v3p3a_disable();
	v2p5_disable();
	v1p8_disable();
	v1p2_disable();
	v1p1_disable();
	clockgen_output_disable();
	write_v1px_smps_mode(0);
	
	bool enable_fpga_jtag_interface = false;
	
	// Set pin multiplexers and behaviors
	IOCON.PIO0_1 = 0;		// PIO0_1: LED_STATUS (out), TODO: PWM control.
	IOCON.PIO0_2 = 1;		// SSEL0: SD_CS#
	IOCON.PIO0_3 = 1;		// USB_VBUS, TODO: needs pull-down?
	IOCON.PIO0_4 = 1;		// SCL: I2C_SCL
	IOCON.PIO0_5 = 1;		// SDA: I2C_SDA
	IOCON.PIO0_6 = 1;		// USB_CONNECT#
	IOCON.PIO0_7 = 0;		// PIO0_7: DDR2_SA1 (out)
	IOCON.PIO0_8 = 1;		// MISO0: SD_MISO
	IOCON.PIO0_9 = 1;		// MOSI0: SD_MOSI
	IOCON.TDI_PIO0_11 = 1;	// PIO0_11: ALT_SW_STAT (in)
	IOCON.TMS_PIO0_12 = 1;	// PIO0_12: USB_POWER_FLT# (in)
	IOCON.TDO_PIO0_13 = 1;	// PIO0_13: USB_POWER_EN (out)
	IOCON.TRST_PIO0_14 = 1;	// PIO0_14: V3P3A_ENABLE (out)
	IOCON.PIO0_16 = 0;		// PIO0_16: V2P5_ENABLE (out)
	IOCON.PIO0_17 = 0;		// PIO0_17: V1P1_ENABLE (out)
	IOCON.PIO0_18 = 0;		// PIO0_18: V1P2_ENABLE (out)
	IOCON.PIO0_19 = 0;		// PIO0_19: FPGA_CONF_DONE (in)
	IOCON.PIO0_20 = 0;		// PIO0_20: FE_EN (out)
	if( enable_fpga_jtag_interface ) {
		IOCON.PIO0_21 = 2;		// MOSI1: FPGA_TDI, TODO: Overloaded with SPI_MOSI
	} else {
		IOCON.PIO0_21 = 0;
	}
	IOCON.PIO0_22 = 3;		// MISO1: FPGA_MISO_V3P3, TODO: Overloaded with FPGA_TDO_V3P3
	IOCON.PIO0_23 = 0;		// PIO0_23: SD_DET (in)
	
	IOCON.PIO1_13 = 0;		// PIO1_13: CLOCKGEN_INTR# (in)
	IOCON.PIO1_14 = 0;		// PIO1_14: CLOCKGEN_OEB# (out)
	IOCON.PIO1_15 = 3;		// SCK1: SPI_SCK, TODO: Overloaded with FPGA_TCK
	IOCON.PIO1_16 = 0;		// PIO1_16: FPGA_NSTATUS (in)
	IOCON.PIO1_19 = 2;		// SSEL1: SPI_SS, TODO: Overloaded with FPGA_TMS
	if( enable_fpga_jtag_interface ) {
		IOCON.PIO1_20 = 2;		// SCK1: FPGA_TCK, TODO: Overloaded with SPI_SCK
		IOCON.PIO1_21 = 2;		// MISO1: FPGA_TDO_V3P3, TODO: Overloaded with FPGA_MISO_V3P3
	} else {
		IOCON.PIO1_20 = 0;
		IOCON.PIO1_21 = 0;
	}
	IOCON.PIO1_22 = 2;		// MOSI1: SPI_MOSI, TODO: Overloaded with FPGA_TDI
	if( enable_fpga_jtag_interface ) {
		IOCON.PIO1_23 = 2;		// SSEL1: FPGA_TMS, TODO: Overloaded with SPI_SS
	} else {
		IOCON.PIO1_23 = 0;
	}
	IOCON.PIO1_24 = 0;		// PIO1_24: DDR2_SA0 (out)
	IOCON.PIO1_25 = 0;		// PIO1_25: V1PX_SMPS_MODE (out)
	IOCON.PIO1_26 = 2;		// RXD: RXD
	IOCON.PIO1_27 = 2;		// TXD: TXD
	IOCON.PIO1_28 = 0;		// PIO1_28: V1P8_ENABLE (out)
	IOCON.PIO1_29 = 1;		// SCK0: SD_SCK
	IOCON.PIO1_31 = 0;		// PIO1_31: V1P8_PWRGD (in)
	
	SCB.enable_power(SCB.PDRUNCFG_USBPAD);
}

extern "C" int main() {
	turn_on_crystal_oscillator();
	start_system_pll();
	start_usb_pll();
	set_main_clock_to_system_pll();
	enable_peripheral_clocks();
	serial_init();

	configure_pins();
	delay(1000000);
	
	//enable_clock_output();
	
	NVIC.enable_interrupts();

	//serial_write_string("main():loop");
	//serial_write_line();
	
	// Power for FPGA
	v1p2_enable();	// FPGA VCCINT
	v2p5_enable();	// FPGA PLLs?
	v1p8_enable();	// FPGA VCCIOs, DDR2.
	v1p1_enable();	// USB internal voltage
	delay(1000000);

	// Power for the clock generator.
	// V3P3A must be turned on *after* V1P8 to satisfy
	// Si5351C requirement.
	v3p3a_enable();
	delay(1000000);
	
	// I2C configuration
	i2c0_init(500);
	
	// Give Si5351C time to power up?
	delay(100000);
	si5351c_disable_all_outputs();
	//si5351c_disable_oeb_pin_control();
	si5351c_power_down_all_clocks();
	si5351c_set_crystal_configuration();
	si5351c_enable_xo_and_ms_fanout();
	si5351c_configure_pll_sources_for_xtal();
	si5351c_configure_pll1_multisynth();
	
	si5351c_configure_multisynth(4, 1536, 0, 1, 0); // 50MHz
	si5351c_configure_multisynth(5, 1536, 0, 1, 0); // 50MHz
	si5351c_configure_multisynths_6_and_7();
	
	si5351c_configure_clock_control();
	si5351c_enable_clock_outputs();
	clockgen_output_enable();

	fe_enable();

	while(true) {
		//write_led_status(read_fpga_conf_done());
		write_led_status(1);
		delay(1000000);
		write_led_status(0);
		delay(1000000);
	}
	
	return 0;
}

extern "C" void SystemInit() {
	
}
