/* 
 * Simple serial port API.
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

void serial_init() {
	//rx_fifo_init();
	//tx_fifo_init();

	SCB.set_usart_clock_divider(1);

	// (1.1333333333333333, [(2, 15)])
	// (1.5333333333333332, [(8, 15)])
	
	// (17, 1.5333333333333332, 0.0009590792838872764)
	// (23, 1.1333333333333333, 0.0009590792838873874)
	/*
	U0DLM = 0
	U0DLL = 17
	DIVADDVAL = 8
	MULVAL = 15
	*/
	// PCLK / (16 * (256 * U0DLM + U0DLL) * (1 + (DIVADDVAL / MULVAL)))
	USART.set_divisor(17);
	USART.set_fractional_divider(15, 8);
	/*
	USART.OSR =
		  (0 << 8)		// FDINT
		| (0xF << 4)	// Integer part of oversampling ratio, minus 1
		| (0 << 1)		// Fractional part of oversampling ratio
		;
	*/	
	USART.LCR =
		  (0 << 7)		// Disable access to divisor latches
		| (0 << 6)		// Disable break transmission
		| (0 << 4)		// Parity select: don't care
		| (0 << 3)		// Disable parity generation
		| (0 << 2)		// 1 stop bit
		| (3 << 0)		// 8-bit character length
		;
	/*
	USART.MCR =
		  (0 << 7)		// Disable auto-CTS flow control
		| (0 << 6)		// Disable auto-RTS flow control
		| (0 << 4)		// Disable modem loopback mode
		;
	*/
	/*
	USART.set_line_control(
		  USART.word_length(8)
		| USART.stop_bits(1)
		| USART.parity_disabled()
		| USART.break_transmission_disabled()
	);
	*/
	USART.FCR =
		  (2 << 6)		// RX FIFO interrupt at 8-character level.
		| (1 << 0)		// Enable and clear the RX and TX FIFOs.
		;
	/*
	USART.TER =
		  (1 << 7)		// Transmit enabled
		;
		
	USART.ICR =
		  (0 << 0)		// IrDA mode is disabled
		;
	*/
	/*
	USART.set_modem_control(
		
	);
	*/
	/*
	// Don't enable TX interrupt until there's something to send.
	USART.IER =
		  (1 << 0)		// RBR interrupt enable
		;
		
	NVIC.enable_irq(NVIC.IRQN_TYPE_USART);
	*/
}
/*
uint8_t serial_read() {
	uint8_t c;
	while( rx_fifo_get(&c) == 0 );
	return c;
}
*/
void serial_write(const uint8_t c) {
	while( (USART.LSR & 0x20) == 0 );
	USART.THR = (uint32_t)c;
	/*
	while( tx_fifo_put(c) == 0 );

	NVIC.disable_irq(NVIC.IRQN_TYPE_USART);
	USART.IER |= (1 << 1);		// THRE interrupt enable
	NVIC.enable_irq(NVIC.IRQN_TYPE_USART);
	*/
}
/*
void usart_irqhandler() {
	switch( USART.IIR & 0xF ) {
	case (0x1 << 1):	// THRE interrupt
		uint8_t c;
		if( tx_fifo_get(&c) ) {
			USART.THR = (uint32_t)c;
		} else {
			// Disable data register empty interrupt.
			USART.IER &= ~(1 << 1);		// THRE interrupt disable
		}
		break;
	
	case (0x2 << 1):	// Receive Data Available (RDA) interrupt
		//const uint8_t c = UDR1;
		//rx_fifo_put(c);
		break;
	
	default:
		// ignore
		break;
	}
}
*/

void serial_write_buffer(const uint8_t* const buffer, const size_t length) {
	for(size_t i=0; i<length; i++) {
		serial_write(buffer[i]);
	}
}

void serial_write_string(const char* s) {
	if( s != nullptr ) {
		while( *s != 0 ) {
			serial_write((uint8_t)*(s++));
		}
	}
}

void serial_write_line(const char* s=nullptr) {
	serial_write_string(s);
	serial_write('\r');
	serial_write('\n');
}

static void serial_write_hex_digit(const uint32_t value) {
	if( value < 10 ) {
		serial_write((uint8_t)value + (uint8_t)'0');
	} else if( value < 16 ) {
		serial_write((uint8_t)(value - 10) + (uint8_t)'A');
	} else {
		serial_write('?');
	}
}

static void serial_write_hex_recursive(const uint32_t value, const size_t width) {
	const size_t new_width = width ? (width - 1) : 0;
	const uint32_t new_value = value >> 4;
	if( (new_value > 0) || (new_width > 0) ) {
		serial_write_hex_recursive(new_value, new_width);
	}
	serial_write_hex_digit(value & 0xF);
}

void serial_write_hex(const uint32_t value, const size_t width=1) {
	serial_write_hex_recursive(value, width);
}
