/* 
 * NXP LPC11U14 peripheral definitions and wrapper classes.
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

#ifndef LPC11U_H_6MHWJJ4R
#define LPC11U_H_6MHWJJ4R

#include <cstdint>
#include <cstddef>

using reg_t = uint32_t;
using reg_readwrite_t = volatile reg_t;
using reg_readonly_t = volatile const reg_t;

struct reg_writeonly_t {
	reg_writeonly_t() = delete;
	reg_writeonly_t(reg_writeonly_t&) = delete;
	
	reg_writeonly_t& operator=(const reg_t value) {
		reg = value;
		return *this;
	}
	
private:
	reg_t reg;
	
	static void _assert_struct() {
		static_assert(sizeof(reg_writeonly_t) == 4, "reg_writeonly_t size not correct");
	}
};

struct reg_reserved_t {
	reg_reserved_t() = delete;
	reg_reserved_t(reg_reserved_t&) = delete;
	
private:
	reg_t reg;
	
	static void _assert_struct() {
		static_assert(sizeof(reg_reserved_t) == 4, "reg_writeonly_t size not correct");
	}
};

struct NVIC_t {
	NVIC_t() = delete;
	NVIC_t(NVIC_t&) = delete;
	
	enum IRQN_TYPE_t {
		IRQN_TYPE_PIN_INT0 = 0,
		IRQN_TYPE_PIN_INT1 = 1,
		IRQN_TYPE_PIN_INT2 = 2,
		IRQN_TYPE_PIN_INT3 = 3,
		IRQN_TYPE_PIN_INT4 = 4,
		IRQN_TYPE_PIN_INT5 = 5,
		IRQN_TYPE_PIN_INT6 = 6,
		IRQN_TYPE_PIN_INT7 = 7,
		IRQN_TYPE_GINT0 = 8,
		IRQN_TYPE_GINT1 = 9,
		IRQN_TYPE_SSP1 = 14,
		IRQN_TYPE_I2C = 15,
		IRQN_TYPE_CT16B0 = 16,
		IRQN_TYPE_CT16B1 = 17,
		IRQN_TYPE_CT32B0 = 18,
		IRQN_TYPE_CT32B1 = 19,
		IRQN_TYPE_SSP0 = 20,
		IRQN_TYPE_USART = 21,
		IRQN_TYPE_USB_IRQ = 22,
		IRQN_TYPE_USB_FIQ = 23,
		IRQN_TYPE_ADC = 24,
		IRQN_TYPE_WWDT = 25,
		IRQN_TYPE_BOD = 26,
		IRQN_TYPE_FLASH = 27,
		IRQN_TYPE_USB_WAKEUP = 30,
	};
	
	static void enable_interrupts() {
		__asm__("cpsie i");
	}
	
	static void disable_interrupts() {
		__asm__("cpsid i");
	}
	
	void enable_irq(const IRQN_TYPE_t irqn) {
		ISER = (1 << irqn);
	}
	
	void disable_irq(const IRQN_TYPE_t irqn) {
		ICER = (1 << irqn);
	}
	
	reg_readwrite_t		ISER;
	reg_reserved_t		_reserved_0x004[31];
	reg_readwrite_t		ICER;
	reg_reserved_t		_reserved_0x084[31];
	reg_readwrite_t		ISPR;
	reg_reserved_t		_reserved_0x104[31];
	reg_readwrite_t		ICPR;
	reg_reserved_t		_reserved_0x184[31];
	reg_reserved_t		_reserved_0x200[64];
	reg_readwrite_t		IPR[8];
	
private:
	static void _assert_struct() {
		static_assert(sizeof(NVIC_t) == 0x320, "NVIC_t size is wrong");
	}
};

struct SCB_t {
	SCB_t() = delete;
	SCB_t(SCB_t&) = delete;
	
	void reset_ssp1_peripheral() {
		PRESETCTRL &= ~(1 << 2);
		PRESETCTRL |= (1 << 2);
	}
	
	bool is_system_pll_locked() {
		return (SYSPLLSTAT & 1) != 0;
	}
	
	void wait_for_system_pll_lock() {
		while( !is_system_pll_locked() );
	}
	
	enum SYSPLLCLKSEL_SEL_t {
		SYSPLLCLKSEL_SEL_IRC_OSCILLATOR = 0x0,
		SYSPLLCLKSEL_SEL_CRYSTAL_OSCILLATOR = 0x1,
	};
	
	void set_system_pll_clock_source(const SCB_t::SYSPLLCLKSEL_SEL_t value) {
		SYSPLLCLKSEL = value;
		SYSPLLCLKUEN = 0;
		SYSPLLCLKUEN = 1;
	}
	
	void set_system_pll_dividers(const reg_t psel, const reg_t msel) {
		SYSPLLCTRL =
	 		  (psel << 5)
			| (msel << 0)
			;
	}
	
	void set_system_clock_divider(const reg_t value) {
		SYSAHBCLKDIV = value;
	}
	
	void disable_system_clock_divider() {
		set_system_clock_divider(0);
	}
	
	enum MAINCLKSEL_SEL_t {
		MAINCLKSEL_SEL_IRC_OSCILLATOR = 0x0,
		MAINCLKSEL_SEL_PLL_INPUT = 0x1,
		MAINCLKSEL_SEL_WATCHDOG_OSCILLATOR = 0x2,
		MAINCLKSEL_SEL_PLL_OUTPUT = 0x3,
	};

	void set_main_clock_source(const SCB_t::MAINCLKSEL_SEL_t value) {
		MAINCLKSEL = value;
		MAINCLKUEN = 0;
		MAINCLKUEN = 1;
	}
	
	enum SYSAHBCLKCTRL_t {
		SYSAHBCLKCTRL_SYS			= (1 <<  0),
		SYSAHBCLKCTRL_ROM			= (1 <<  1),
		SYSAHBCLKCTRL_RAM0			= (1 <<  2),
		SYSAHBCLKCTRL_FLASHREG		= (1 <<  3),
		SYSAHBCLKCTRL_FLASHARRAY	= (1 <<  4),
		SYSAHBCLKCTRL_I2C			= (1 <<  5),
		SYSAHBCLKCTRL_GPIO			= (1 <<  6),
		SYSAHBCLKCTRL_CT16B0		= (1 <<  7),
		SYSAHBCLKCTRL_CT16B1		= (1 <<  8),
		SYSAHBCLKCTRL_CT32B0		= (1 <<  9),
		SYSAHBCLKCTRL_CT32B1		= (1 << 10),
		SYSAHBCLKCTRL_SSP0			= (1 << 11),
		SYSAHBCLKCTRL_USART			= (1 << 12),
		SYSAHBCLKCTRL_ADC			= (1 << 13),
		SYSAHBCLKCTRL_USB			= (1 << 14),
		SYSAHBCLKCTRL_WWDT			= (1 << 15),
		SYSAHBCLKCTRL_IOCON			= (1 << 16),
		SYSAHBCLKCTRL_SSP1			= (1 << 18),
		SYSAHBCLKCTRL_PINT			= (1 << 19),
		SYSAHBCLKCTRL_GROUP0INT		= (1 << 23),
		SYSAHBCLKCTRL_GROUP1INT		= (1 << 24),
		SYSAHBCLKCTRL_RAM1			= (1 << 26),
		SYSAHBCLKCTRL_USBRAM		= (1 << 27),
	};

	void enable_clocks(const reg_t value) {
		SYSAHBCLKCTRL |= value;
	}
	
	bool is_usb_pll_locked() {
		return (USBPLLSTAT & 1) != 0;
	}
	
	void wait_for_usb_pll_lock() {
		while( !is_usb_pll_locked() );
	}
	
	void set_usb_pll_dividers(const reg_t psel, const reg_t msel) {
		USBPLLCTRL =
	 		  (psel << 5)
			| (msel << 0)
			;
	}
	
	enum USBPLLCLKSEL_SEL_t {
		USBPLLCLKSEL_SEL_IRC_OSCILLATOR = 0x0,
		USBPLLCLKSEL_SEL_SYSTEM_OSCILLATOR = 0x1,
	};
	
	void set_usb_pll_clock_source(const SCB_t::USBPLLCLKSEL_SEL_t value) {
		USBPLLCLKSEL = value;
		USBPLLCLKUEN = 0;
		USBPLLCLKUEN = 1;
	}
	
	void set_ssp0_clock_divider(const reg_t divisor) {
		SSP0CLKDIV = divisor;
	}
	
	void disable_ssp0_clock() {
		set_ssp0_clock_divider(0);
	}

	void set_usart_clock_divider(const reg_t divisor) {
		UARTCLKDIV = divisor;
	}
	
	void disable_usart_clock_divider() {
		set_usart_clock_divider(0);
	}
	
	void set_ssp1_clock_divider(const reg_t divisor) {
		SSP1CLKDIV = divisor;
	}
	
	void disable_ssp1_clock_divider() {
		set_ssp1_clock_divider(0);
	}
	
	enum USBCLKSEL_SEL_t {
		USBCLKSEL_SEL_USB_PLL_OUT = 0x0,
		USBCLKSEL_SEL_MAIN_CLOCK = 0x1,
	};
	
	void set_usb_clock_source(const SCB_t::USBCLKSEL_SEL_t value) {
		USBCLKSEL = value;
		USBCLKUEN = 0;
		USBCLKUEN = 1;
	}
	
	void set_usb_clock_divider(const reg_t value) {
		USBCLKDIV = value;
	}
	
	void disable_usb_clock_divider() {
		set_usb_clock_divider(0);
	}
	
	enum CLKOUTSEL_SEL_t {
		CLKOUTSEL_SEL_IRC_OSCILLATOR = 0x0,
		CLKOUTSEL_SEL_CRYSTAL_OSCILLATOR = 0x1,
		CLKOUTSEL_SEL_LF_OSCILLATOR = 0x2,
		CLKOUTSEL_SEL_MAIN_CLOCK = 0x3,
	};
	
	void set_clkout_clock_source(const SCB_t::CLKOUTSEL_SEL_t value) {
		CLKOUTSEL = value;
		CLKOUTUEN = 0;
		CLKOUTUEN = 1;
	}
	
	void set_clkout_divider(const reg_t value) {
		CLKOUTDIV = value;
	}
	
	enum PDRUNCFG_t {
		PDRUNCFG_IRCOUT = (1 << 0),
		PDRUNCFG_IRC = (1 << 1),
		PDRUNCFG_FLASH = (1 << 2),
		PDRUNCFG_BOD = (1 << 3),
		PDRUNCFG_ADC = (1 << 4),
		PDRUNCFG_SYSOSC = (1 << 5),
		PDRUNCFG_WDTOSC = (1 << 6),
		PDRUNCFG_SYSPLL = (1 << 7),
		PDRUNCFG_USBPLL = (1 << 8),
		PDRUNCFG_USBPAD = (1 << 10),
	};
	
	void enable_power(const PDRUNCFG_t value) {
		PDRUNCFG &= ~value;
	}
	
	reg_readwrite_t		SYSMEMREMAP;		// 0x000
	reg_readwrite_t		PRESETCTRL;
	reg_readwrite_t		SYSPLLCTRL;
	reg_readonly_t		SYSPLLSTAT;
	reg_readwrite_t		USBPLLCTRL;			// 0x010
	reg_readonly_t		USBPLLSTAT;
	reg_reserved_t		_reserved_0x018[2];
	reg_readwrite_t		SYSOSCCTRL;			// 0x020
	reg_readwrite_t		WDTOSCCTRL;
	reg_reserved_t		_reserved_0x028[2];
	reg_readwrite_t		SYSRSTSTAT;			// 0x030
	reg_reserved_t		_reserved_0x034[3];
	reg_readwrite_t		SYSPLLCLKSEL;		// 0x040
	reg_readwrite_t		SYSPLLCLKUEN;
	reg_readwrite_t		USBPLLCLKSEL;
	reg_readwrite_t		USBPLLCLKUEN;
	reg_reserved_t		_reserved_0x050[8];
	reg_readwrite_t		MAINCLKSEL;			// 0x070
	reg_readwrite_t		MAINCLKUEN;
	reg_readwrite_t		SYSAHBCLKDIV;
	reg_reserved_t		_reserved_0x07c[1];
	reg_readwrite_t		SYSAHBCLKCTRL;		// 0x080
	reg_reserved_t		_reserved_0x084[4];
	reg_readwrite_t		SSP0CLKDIV;			// 0x094
	reg_readwrite_t		UARTCLKDIV;
	reg_readwrite_t		SSP1CLKDIV;
	reg_reserved_t 		_reserved_0x0a0[8];
	reg_readwrite_t 	USBCLKSEL;			// 0x0c0
	reg_readwrite_t 	USBCLKUEN;
	reg_readwrite_t 	USBCLKDIV;
	reg_reserved_t 		_reserved_0x0cc[5];
	reg_readwrite_t 	CLKOUTSEL;			// 0x0e0
	reg_readwrite_t 	CLKOUTUEN;
	reg_readwrite_t 	CLKOUTDIV;
	reg_reserved_t 		_reserved_0x0ec[5];
	reg_readonly_t 		PIOPORCAP0;			// 0x100
	reg_readonly_t	 	PIOPORCAP1;
	reg_reserved_t 		_reserved_0x108[18];
	reg_readwrite_t 	BODCTRL;			// 0x150
	reg_readwrite_t 	SYSTCKCAL;
	reg_reserved_t 		_reserved_0x158[6];
	reg_readwrite_t 	IRQLATENCY;			// 0x170
	reg_readwrite_t 	NMISRC;
	reg_readwrite_t 	PINTSEL[8];			// 0x178
	reg_readwrite_t 	USBCLKCTRL;			// 0x198
	reg_readonly_t	 	USBCLKST;
	reg_reserved_t 		_reserved_0x1a0[25];
	reg_readwrite_t 	STARTERP0;			// 0x204
	reg_reserved_t 		_reserved_0x208[3];
	reg_readwrite_t 	STARTERP1;			// 0x214
	reg_reserved_t 		_reserved_0x218[6];
	reg_readwrite_t 	PDSLEEPCFG;			// 0x230
	reg_readwrite_t 	PDAWAKECFG;
	reg_readwrite_t 	PDRUNCFG;
	reg_reserved_t 		_reserved_0x23c[110];
	reg_readonly_t	 	DEVICE_ID;			// 0x3f4

private:
	static void _assert_struct() {
		static_assert(sizeof(SCB_t) == 0x3f8, "SCB_t size is wrong");
	}
};

static SCB_t& SCB = *reinterpret_cast<SCB_t*>(0x40048000);

struct FCB_t {
	FCB_t() = delete;
	FCB_t(FCB_t&) = delete;
	
	reg_reserved_t	reserved_0x000[4];	// 0x000
	reg_readwrite_t	FLASHCFG;			// 0x010
	
private:
	static void _assert_struct() {
		static_assert(offsetof(FCB_t, FLASHCFG) == 0x010, "FCB_t.FLASHCFG offset is wrong");
		static_assert(sizeof(FCB_t) == 0x014, "FCB_t size is wrong");
	}
};

struct SSP_t {
	SSP_t() = delete;
	SSP_t(SSP_t&) = delete;
	
	reg_readwrite_t		CR0;	// 0x000
	reg_readwrite_t		CR1;	// 0x004
	reg_readwrite_t		DR;		// 0x008
	reg_readonly_t		SR;		// 0x00C
	reg_readwrite_t		CPSR;	// 0x010
	reg_readwrite_t		IMSC;	// 0x014
	reg_readonly_t		RIS;	// 0x018
	reg_readonly_t		MIS;	// 0x01C
	reg_writeonly_t		ICR;	// 0x020
	
private:
	static void _assert_struct() {
		static_assert(sizeof(SSP_t) == 0x024, "SSP_t size is wrong");
	}
};

struct IOCON_t {
	IOCON_t() = delete;
	IOCON_t(IOCON_t&) = delete;
	
	reg_readwrite_t RESET_PIO0_0;
	reg_readwrite_t PIO0_1;
	reg_readwrite_t PIO0_2;
	reg_readwrite_t PIO0_3;
	reg_readwrite_t PIO0_4;
	reg_readwrite_t PIO0_5;
	reg_readwrite_t PIO0_6;
	reg_readwrite_t PIO0_7;
	reg_readwrite_t PIO0_8;
	reg_readwrite_t PIO0_9;
	reg_readwrite_t SWCLK_PIO0_10;
	reg_readwrite_t TDI_PIO0_11;
	reg_readwrite_t TMS_PIO0_12;
	reg_readwrite_t TDO_PIO0_13;
	reg_readwrite_t TRST_PIO0_14;
	reg_readwrite_t SWDIO_PIO0_15;
	reg_readwrite_t PIO0_16;
	reg_readwrite_t PIO0_17;
	reg_readwrite_t PIO0_18;
	reg_readwrite_t PIO0_19;
	reg_readwrite_t PIO0_20;
	reg_readwrite_t PIO0_21;
	reg_readwrite_t PIO0_22;
	reg_readwrite_t PIO0_23;
	reg_readwrite_t PIO1_0;
	reg_readwrite_t PIO1_1;
	reg_readwrite_t PIO1_2;
	reg_readwrite_t PIO1_3;
	reg_readwrite_t PIO1_4;
	reg_readwrite_t PIO1_5;
	reg_readwrite_t PIO1_6;
	reg_readwrite_t PIO1_7;
	reg_readwrite_t PIO1_8;
	reg_readwrite_t PIO1_9;
	reg_readwrite_t PIO1_10;
	reg_readwrite_t PIO1_11;
	reg_readwrite_t PIO1_12;
	reg_readwrite_t PIO1_13;
	reg_readwrite_t PIO1_14;
	reg_readwrite_t PIO1_15;
	reg_readwrite_t PIO1_16;
	reg_readwrite_t PIO1_17;
	reg_readwrite_t PIO1_18;
	reg_readwrite_t PIO1_19;
	reg_readwrite_t PIO1_20;
	reg_readwrite_t PIO1_21;
	reg_readwrite_t PIO1_22;
	reg_readwrite_t PIO1_23;
	reg_readwrite_t PIO1_24;
	reg_readwrite_t PIO1_25;
	reg_readwrite_t PIO1_26;
	reg_readwrite_t PIO1_27;
	reg_readwrite_t PIO1_28;
	reg_readwrite_t PIO1_29;
	reg_reserved_t _reserved_0x0d8[1];
	reg_readwrite_t PIO1_31;

private:
	static void _assert_struct() {
		static_assert(offsetof(IOCON_t, PIO1_31) == 0x0dc, "IOCON_t.PIO1_31 offset is wrong");
		static_assert(sizeof(IOCON_t) == 0x0e0, "IOCON_t size is wrong");
	}
};

struct CT16_t {
	CT16_t() = delete;
	CT16_t(CT16_t&) = delete;
	
	reg_readwrite_t		IR;						// 0x000
	reg_readwrite_t		TCR;
	reg_readwrite_t		TC;
	reg_readwrite_t		PR;
	reg_readwrite_t		PC;						// 0x010
	reg_readwrite_t		MCR;
	reg_readwrite_t		MR[4];					// 0x018
	reg_readwrite_t		CCR;					// 0x028
	reg_readwrite_t		CR[2];					// 0x02c
	reg_reserved_t		_reserved_0x034[2];
	reg_readwrite_t		EMR;
	reg_reserved_t		_reserved_0x040[12];	// 0x040
	reg_readwrite_t		CTCR;					// 0x070
	reg_readwrite_t		PWMC;

private:
	static void _assert_struct() {
		static_assert(offsetof(CT16_t, IR) == 0x000, "CT16_t.IR offset is wrong");
		static_assert(offsetof(CT16_t, EMR) == 0x03c, "CT16_t.EMR offset is wrong");
		static_assert(offsetof(CT16_t, CTCR) == 0x070, "CT16_t.EMR offset is wrong");
		static_assert(sizeof(CT16_t) == 0x078, "CT16_t size is wrong");
	}
};

struct CT32_t {
	CT32_t() = delete;
	CT32_t(CT32_t&) = delete;
	
	reg_readwrite_t		IR;						// 0x000
	reg_readwrite_t		TCR;					// 0x004
	reg_readwrite_t		TC;						// 0x008
	reg_readwrite_t		PR;						// 0x00c
	reg_readwrite_t		PC;						// 0x010
	reg_readwrite_t		MCR;					// 0x014
	reg_readwrite_t		MR[4];					// 0x018 - 0x024
	reg_readwrite_t		CCR;					// 0x028
	reg_readonly_t		CRO;					// 0x02c
	reg_reserved_t		_reserved_0x030[3];		// 0x030 - 0x038
	reg_readwrite_t		EMR;					// 0x03c
	reg_reserved_t		_reserved_0x040[12];	// 0x040 - 0x06c
	reg_readwrite_t		CTCR;					// 0x070
	reg_readwrite_t		PWMC;					// 0x074
	
private:
	static void _assert_struct() {
		static_assert(offsetof(CT32_t, EMR) == 0x03c, "CT32_t.EMR offset is wrong");
		static_assert(offsetof(CT32_t, CTCR) == 0x070, "CT32_t.CTCR offset is wrong");
		static_assert(sizeof(CT32_t) == 0x078, "CT32_t size is wrong");
	}
};

struct USART_t {
	USART_t() = delete;
	USART_t(USART_t&) = delete;
	
	union {									// 0x000
		reg_readonly_t		RBR;
		reg_writeonly_t		THR;
		reg_readwrite_t		DLL;
	};
	union {									// 0x004
		reg_readwrite_t		DLM;
		reg_readwrite_t		IER;
	};
	union {									// 0x008
		reg_readonly_t		IIR;
		reg_writeonly_t		FCR;
	};
	reg_readwrite_t		LCR;				// 0x00c
	reg_readwrite_t		MCR;				// 0x010
	reg_readonly_t		LSR;				// 0x014
	reg_readonly_t		MSR;				// 0x018
	reg_readwrite_t		SCR;				// 0x01c
	reg_readwrite_t		ACR;				// 0x020
	reg_readwrite_t		ICR;				// 0x024
	reg_readwrite_t		FDR;				// 0x028
	reg_readwrite_t		OSR;				// 0x02c
	reg_readwrite_t		TER;				// 0x030
	reg_reserved_t		_reserved_0x034[3];
	reg_readwrite_t		HDEN;				// 0x040
	reg_reserved_t		_reserved_0x044[1];
	reg_readwrite_t		SCICTRL;			// 0x048
	reg_readwrite_t		RS485CTRL;			// 0x04c
	reg_readwrite_t		RS485ADRMATCH;		// 0x050
	reg_readwrite_t		RS485DLY;			// 0x054
	reg_readwrite_t		SYNCCTRL;			// 0x058
	
	void enable_access_to_divisor_latches() {
		LCR |= (1 << 7);
	}

	void disable_access_to_divisor_latches() {
		LCR &= ~(1 << 7);
	}

	void set_divisor(const reg_t value) {
		enable_access_to_divisor_latches();
		DLL = value & 0xFF;
		DLM = (value >> 8) & 0xFF;
		disable_access_to_divisor_latches();
	}
	
	void set_fractional_divider(const reg_t mulval, const reg_t divaddval) {
		FDR = (mulval << 4) | (divaddval << 0);
	}
	
	enum LCR_WLS_t {
		LCR_WLS_5_BIT_CHARACTER_LENGTH = (0x0 << 0),
		LCR_WLS_6_BIT_CHARACTER_LENGTH = (0x1 << 0),
		LCR_WLS_7_BIT_CHARACTER_LENGTH = (0x2 << 0),
		LCR_WLS_8_BIT_CHARACTER_LENGTH = (0x3 << 0),
	};
	
	enum LCR_SBS_t {
		LCR_SBS_1_STOP_BIT = (0 << 2),
		LCR_SBS_1_5_OR_2_STOP_BITS = (1 << 2),
	};
	
	enum LCR_PE_t {
		LCR_PE_PARITY_DISABLED = (0 << 3),
		LCR_PE_PARITY_ENABLED = (1 << 3),
	};
	
	enum LCR_BC_t {
		LCR_BC_DISABLE_BREAK_TRANSMISSION = (0 << 6),
		LCR_BC_ENABLE_BREAK_TRANSMISSION = (1 << 6),
	};
	
	reg_t word_length(const reg_t bits) {
		switch(bits) {
		case 5: return LCR_WLS_5_BIT_CHARACTER_LENGTH;
		case 6: return LCR_WLS_6_BIT_CHARACTER_LENGTH;
		case 7: return LCR_WLS_7_BIT_CHARACTER_LENGTH;
		default:
		case 8: return LCR_WLS_8_BIT_CHARACTER_LENGTH;
		}
	}
	
	reg_t stop_bits(const reg_t bits) {
		switch(bits) {
		default:
		case 1: return LCR_SBS_1_STOP_BIT;
		case 2: return LCR_SBS_1_5_OR_2_STOP_BITS;
		}
	}

	reg_t parity_disabled() {
		return LCR_PE_PARITY_DISABLED;
	}
	
	reg_t break_transmission_disabled() {
		return LCR_BC_DISABLE_BREAK_TRANSMISSION;
	}
	
	void set_line_control(const reg_t value) {
		LCR = value;
	}
	
private:
	static void _assert_struct() {
		static_assert(offsetof(USART_t, HDEN) == 0x040, "USART_t.HDEN offset is wrong");
		static_assert(offsetof(USART_t, SCICTRL) == 0x048, "USART_t.SCICTRL offset is wrong");
		static_assert(sizeof(USART_t) == 0x05c, "USART_t size is wrong");
	}
};

struct GPIO_PORT_BYTE_PIN_t {
	GPIO_PORT_BYTE_PIN_t() = delete;
	GPIO_PORT_BYTE_PIN_t(GPIO_PORT_BYTE_PIN_t&) = delete;
	
	volatile uint8_t B[64];
	
private:
	static void _assert_struct() {
		// NOTE: Data sheet specifies size of B32 - B63 block as 0x30 bytes, which seems wrong.
		static_assert(sizeof(GPIO_PORT_BYTE_PIN_t) == 0x040, "GPIO_PORT_BYTE_PIN_t size is wrong");
	}
};

struct GPIO_PORT_WORD_PIN_t {
	GPIO_PORT_WORD_PIN_t() = delete;
	GPIO_PORT_WORD_PIN_t(GPIO_PORT_WORD_PIN_t&) = delete;

	reg_t read(const reg_t port, const reg_t pin) {
		return W[port * 32 + pin];
	}
	
private:
	reg_readwrite_t W[64];
	
	static void _assert_struct() {
		// NOTE: Data sheet specifies size of W32 - W63 block as 0xFC bytes, which seems wrong.
		static_assert(sizeof(GPIO_PORT_WORD_PIN_t) == 0x100, "GPIO_PORT_WORD_PIN_t size is wrong");
	}
};

struct GPIO_PORT_t {
	GPIO_PORT_t() = delete;
	GPIO_PORT_t(GPIO_PORT_t&) = delete;
	
	reg_readwrite_t		DIR0;
	reg_readwrite_t		DIR1;
	reg_reserved_t		_reserved_1[30];
	reg_readwrite_t		MASK0;
	reg_readwrite_t		MASK1;
	reg_reserved_t		_reserved_2[30];
	reg_readwrite_t		PIN0;
	reg_readwrite_t		PIN1;
	reg_reserved_t		_reserved_3[30];
	reg_readwrite_t		MPIN0;
	reg_readwrite_t		MPIN1;
	reg_reserved_t		_reserved_4[30];
	reg_readwrite_t		SET0;
	reg_readwrite_t		SET1;
	reg_reserved_t		_reserved_5[30];
	reg_writeonly_t		CLR0;
	reg_writeonly_t		CLR1;
	reg_reserved_t		_reserved_6[30];
	reg_writeonly_t		NOT0;
	reg_writeonly_t		NOT1;
	
	void set(const uint_fast8_t port_ordinal, const uint_fast8_t bit_ordinal) {
		(port_ordinal ? SET1 : SET0) = 1 << bit_ordinal;
	}
	
	void clear(const uint_fast8_t port_ordinal, const uint_fast8_t bit_ordinal) {
		(port_ordinal ? CLR1 : CLR0) = 1 << bit_ordinal;
	}
	
	void write(const uint_fast8_t port_ordinal, const uint_fast8_t bit_ordinal, const uint_fast8_t value) {
		if( value ) {
			set(port_ordinal, bit_ordinal);
		} else {
			clear(port_ordinal, bit_ordinal);
		}
	}

private:
	static void _assert_struct() {
		static_assert(offsetof(GPIO_PORT_t, MASK0) == 0x080, "GPIO_PORT_t.MASK0 offset is wrong");
		static_assert(offsetof(GPIO_PORT_t, PIN0) == 0x100, "GPIO_PORT_t.PIN0 offset is wrong");
		static_assert(offsetof(GPIO_PORT_t, MPIN0) == 0x180, "GPIO_PORT_t.MPIN0 offset is wrong");
		static_assert(offsetof(GPIO_PORT_t, SET0) == 0x200, "GPIO_PORT_t.SET0 offset is wrong");
		static_assert(offsetof(GPIO_PORT_t, CLR0) == 0x280, "GPIO_PORT_t.CLR0 offset is wrong");
		static_assert(offsetof(GPIO_PORT_t, NOT0) == 0x300, "GPIO_PORT_t.NOT0 offset is wrong");
		static_assert(sizeof(GPIO_PORT_t) == 0x308, "GPIO_PORT_t size is wrong");
	}
};

struct usb_endpoint_entry_t {
	reg_readwrite_t out[2];
	reg_readwrite_t in[2];
	
private:
	static void _assert_struct() {
		static_assert(sizeof(usb_endpoint_entry_t) == 0x10, "usb_endpoint_entry_t size is wrong");
	}
};

struct usb_endpoint_list_t {
	usb_endpoint_entry_t ep[5];
	
private:
	static void _assert_struct() {
		static_assert(sizeof(usb_endpoint_list_t) == 0x50, "usb_endpoint_list_t size is wrong");
	}
};

struct USB_t {
	USB_t() = delete;
	USB_t(USB_t&) = delete;
	
	reg_readwrite_t		DEVCMDSTAT;			// 0x000
	reg_readwrite_t		INFO;				// 0x004
	reg_readwrite_t		EPLISTSTART;		// 0x008
	reg_readwrite_t		DATABUFSTART;		// 0x00c
	reg_readwrite_t		LPM;				// 0x010
	reg_readwrite_t		EPSKIP;				// 0x014
	reg_readwrite_t		EPINUSE;			// 0x018
	reg_readwrite_t		EPBUFCFG;			// 0x01c
	reg_readwrite_t		INTSTAT;			// 0x020
	reg_readwrite_t		INTEN;				// 0x024
	reg_readwrite_t		INTSETSTAT;			// 0x028
	reg_readwrite_t		INTROUTING;			// 0x02c
	reg_reserved_t		_reserved_0x030;	// 0x030
	reg_readonly_t		EPTOGGLE;			// 0x034
	
	void enable_device() {
		DEVCMDSTAT |= (1 << 7);
	}
	
	void clear_all_interrupts() {
		INTSTAT = 0xc00003ff;
	}
	
	void enable_all_interrupts() {
		INTEN = 0xc00003ff;
	}
	
	bool setup_token_received() {
		return DEVCMDSTAT & (1 << 8);
	}
	
	void enable_connect() {
		DEVCMDSTAT |= (1 << 16);
	}
	
	bool vbus_debounced() {
		return DEVCMDSTAT & (1 << 28);
	}
	
	void set_endpoint_list_start_address(usb_endpoint_list_t* const list) {
		//static_assert(((uint32_t)list & 0xFF) == 0, "list base address not valid");
		EPLISTSTART = (uint32_t)list;
	}
	
	void set_data_buffer_start_address(const uint32_t buffer) {
		//static_assert((buffer & 0x3FFFFF) == 0, "buffer start address not valid");
		DATABUFSTART = buffer;
	}
	
private:
	static void _assert_struct() {
		static_assert(sizeof(USB_t) == 0x038, "USB_t size is wrong");
	}
};

static USART_t& USART = *reinterpret_cast<USART_t*>(0x40008000);

static CT16_t& CT16B0 = *reinterpret_cast<CT16_t*>(0x4000c000);
static CT16_t& CT16B1 = *reinterpret_cast<CT16_t*>(0x40010000);
static CT32_t& CT32B0 = *reinterpret_cast<CT32_t*>(0x40014000);
static CT32_t& CT32B1 = *reinterpret_cast<CT32_t*>(0x40018000);

static FCB_t& FCB = *reinterpret_cast<FCB_t*>(0x4003c000);
static SSP_t& SSP0 = *reinterpret_cast<SSP_t*>(0x40040000);
static SSP_t& SSP1 = *reinterpret_cast<SSP_t*>(0x40058000);
static IOCON_t& IOCON = *reinterpret_cast<IOCON_t*>(0x40044000);
static GPIO_PORT_BYTE_PIN_t& GPIO_BYTE = *reinterpret_cast<GPIO_PORT_BYTE_PIN_t*>(0x50000000);
static GPIO_PORT_WORD_PIN_t& GPIO_WORD = *reinterpret_cast<GPIO_PORT_WORD_PIN_t*>(0x50001000);
static GPIO_PORT_t& GPIO_PORT = *reinterpret_cast<GPIO_PORT_t*>(0x50002000);

static USB_t& USB = *reinterpret_cast<USB_t*>(0x40080000);

static NVIC_t& NVIC = *reinterpret_cast<NVIC_t*>(0xE000E100);

void delay(const uint32_t amount);

#endif /* end of include guard: LPC11U_H_6MHWJJ4R */
