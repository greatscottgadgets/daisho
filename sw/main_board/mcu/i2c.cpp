/*
 * Copyright 2013 Jared Boone <jared@sharebrained.com>
 *
 * This file is part of Daisho.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#include "i2c.h"

#include "lpc11u.h"

void i2c0_init(const uint16_t half_cycle_period) {
	I2C0.init(half_cycle_period);
}

void i2c0_tx_start(void) {
	I2C0.tx_start();
}

void i2c0_tx_byte(const uint_fast8_t byte) {
	I2C0.tx_byte(byte);
}

uint_fast8_t i2c0_rx_byte(void) {
	return I2C0.rx_byte();
}

void i2c0_stop(void) {
	I2C0.stop();
}
