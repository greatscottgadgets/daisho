#!/usr/bin/env python

# Produce a block of text representing a Samtec QSH connector, for
# insertion into a KiCAD part library.
# 
# Copyright (C) 2013 Jared Boone, ShareBrained Technology, Inc.
# Copyright (C) 2013 Benjamin Vernoux.
# 
# This file is part of the Daisho project.
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

from kicad.eeschema import format_lib

component_name = 'SAMTEC_QSH-090-D'

banks = 3
positions_per_bank = 30
grounds_per_bank = 4

body_width = 1200
pin_length = 300
body_offset_y = -300
position_spacing = 100

pin_row_x = (
	body_width / 2.0,
	-body_width / 2.0,
)
rows = len(pin_row_x)

units = []
for bank in range(banks):
	bank_first_pin_number = bank * positions_per_bank * rows + 1
	bank_y = body_offset_y
	
	unit = {
		'name': 'BANK %d' % (bank + 1),
		'pins': [],
	}
	
	for position in range(positions_per_bank):
		pin_y = (position * -position_spacing) + bank_y
		
		for row in range(rows):
			pin_number = bank_first_pin_number + position * rows + row
			
			pin = {
				'position': (pin_row_x[row], pin_y),
				'number': pin_number,
				'pin_length': pin_length,
				'orientation': 'L' if row == 0 else 'R',
				'e_type': 'P',	# Passive
			}
			unit['pins'].append(pin)
	
	outline_top_y = max([pin['position'][1] for pin in unit['pins']]) + position_spacing
	outline_bottom_y = min([pin['position'][1] for pin in unit['pins']]) - position_spacing
	unit['outline'] = (
		(min(pin_row_x) + pin_length, outline_bottom_y),
		(max(pin_row_x) - pin_length, outline_top_y),
	)
	
	# Add ground pins:
	for n in range(grounds_per_bank):
		pin_x = n * position_spacing - ((grounds_per_bank - 1) * position_spacing / 2.0)
		pin_y = outline_bottom_y - pin_length

		pin = {
			'position': (pin_x, pin_y),
			'name': 'GND',
			'number': '%c%c' % (chr(ord('A') + bank), chr(ord('0') + n)),
			'pin_length': pin_length,
			'orientation': 'U',
			'e_type': 'W',	# Power IN
		}
		unit['pins'].append(pin)

	units.append(unit)

lib = {
	'component_name': component_name,
	'reference_name': 'J',
	'units': units,
}

lines = format_lib(lib)

print('\n'.join(lines))
