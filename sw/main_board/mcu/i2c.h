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

#pragma once
#ifndef __I2C_H__
#define __I2C_H__ 1

#include <stdint.h>

void i2c0_init(const uint16_t half_cycle_period);
void i2c0_tx_start(void);
void i2c0_tx_byte(const uint_fast8_t byte);
uint_fast8_t i2c0_rx_byte(void);
void i2c0_stop(void);

#define I2C_WRITE           0
#define I2C_READ            1

#endif/*__I2C_H__*/

