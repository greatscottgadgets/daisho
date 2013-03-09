# Utilities for working with KiCAD EESchema data and files.
# 
# Copyright (C) 2013 Jared Boone, ShareBrained Technology, Inc.
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

import datetime

from kicad import date_to_kicad

rectangle_template = 'S %(start_x)d %(start_y)d %(end_x)d %(end_y)d %(unit)d %(convert)d %(width)d %(fill)s'

def format_rectangle(rectangle, unit_index):
	data = {
		'start_x': int(rectangle[0][0]),
		'start_y': int(rectangle[0][1]),
		'end_x': int(rectangle[1][0]),
		'end_y': int(rectangle[1][1]),
		'unit': int(unit_index),
		'convert': 1,
		'width': 0,
		'fill': 'N',
	}
	return (rectangle_template % data,)

def format_outline(outline, unit_index):
	return format_rectangle(outline, unit_index)

pin_template = 'X %(name)s %(number)s %(x)d %(y)d %(length)d %(orientation)s %(number_text_size)d %(name_text_size)d %(unit)d %(convert)d %(e_type)s'

def format_pin(pin, unit_index):
	data = {
		'name': str(pin['name'] if 'name' in pin else '~'),
		'number': str(pin['number'] if 'number' in pin else ''),
		'x': int(round(pin['position'][0] if 'position' in pin else 0)),
		'y': int(round(pin['position'][1] if 'position' in pin else 0)),
		'length': int(round(pin['length'] if 'length' in pin else 300)),
		'orientation': pin['orientation'] if 'orientation' in pin else 'R',
		'number_text_size': int(round(50)),
		'name_text_size': int(round(50)),
		'unit': unit_index,
		'convert': 1,
		'e_type': pin['e_type'],
	}
	return (pin_template % data,)
    
def format_pins(pins, unit_index):
	result = []
	for pin in pins:
		result.extend(format_pin(pin, unit_index))
	return result

def format_unit(unit, unit_index=0):
	outline = unit['outline'] if 'outline' in unit else None
	pins = unit['pins']
	
	result = []
	if outline:
		result.extend(format_outline(outline, unit_index))
	result.extend(format_pins(pins, unit_index))
	return result

lib_header_template = (
	'EESchema-LIBRARY Version 2.3  Date: {modified_date}',
	'#encoding utf-8',
	'#',
	'# {component_name}',
	'#'
)
lib_component_start_template = (
	'DEF {component_name} {reference_name} 0 {pin_name_offset} {show_pin_numbers} {show_pin_names} {unit_count} {units_locked} {options}',
	'F0 "{reference_name}" 0 50 60 H V C CNN',
	'F1 "{component_name}" 50 -50 60 H V C CNN',
	'DRAW',
)
lib_component_end_template = (
	'ENDDRAW',
	'ENDDEF',
	'#',
	'#End Library',
)

def format_lib(lib):
	unit_count = len(lib['units'])
	data = {
		'modified_date': date_to_kicad(datetime.datetime.now()),
		'component_name': str(lib['component_name']),
		'reference_name': str(lib['reference_name']) if 'reference_name' in lib else '~',
		'pin_name_offset': int(lib['pin_name_offset'] if 'pin_name_offset' in lib else 40),
		'show_pin_numbers': lib['show_pin_numbers'] if 'show_pin_numbers' in lib else 'Y',
		'show_pin_names': lib['show_pin_names'] if 'show_pin_names' in lib else 'Y',
		'unit_count': unit_count,
		'units_locked': lib['units_locked'] if 'units_locked' in lib else 'L',
		'options': lib['options'] if 'options' in lib else 'N',
	}
	
	result = []
	result.extend([line.format(**data) for line in lib_header_template])
	result.extend([line.format(**data) for line in lib_component_start_template])
	
	units = lib['units']
	for unit_index in range(len(units)):
		unit = units[unit_index]
		result.extend(format_unit(unit, unit_index + 1))
	
	result.extend([line.format(**data) for line in lib_component_end_template])
	
	return result
