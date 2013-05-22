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

#ifndef SERIAL_H_CETCJ77Y
#define SERIAL_H_CETCJ77Y

#include <cstdint>
#include <cstddef>

void serial_init();
uint8_t serial_read();
void serial_write(const uint8_t c);

void serial_write_buffer(const uint8_t* const buffer, const size_t length);
void serial_write_string(const char* s);
void serial_write_line(const char* s=nullptr);
void serial_write_hex(const uint32_t value, const size_t padding=1);

#endif /* end of include guard: SERIAL_H_CETCJ77Y */
