#!/usr/bin/env python

# Transform a Cyclone IV pinout CSV file (obtained from data on Altera's Web site)
# into a block of text for insertion into a KiCAD part library.
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

import csv
from collections import defaultdict

units = defaultdict(list)

with open('ep4ce30f29_pinout.csv', 'rb') as pin_file:
    pin_reader = csv.DictReader(pin_file)
    for pin_row in pin_reader:
        pin_row = dict((key, value.strip()) for key, value in pin_row.items())
        
        package_pin_name = pin_row['F780']
        if package_pin_name == '':
            # Pin not exposed in this package
            continue
            
        bank = pin_row['Bank Number']
        pin_function = pin_row['Pin Name / Function']
        optional_function = pin_row['Optional Function(s)']
        configuration_functions = pin_row['Configuration Function'].split(',')
        if configuration_functions == ['']:
            configuration_functions = []
        vrefb_group = pin_row['VREFB Group']
        
        unit_name = None
        electrical_type = None
        pin_number = package_pin_name
        
        pin_names = []
        if bank:
            if pin_function != 'IO':
                pin_names.append(pin_function)
                electrical_type = 'I'
            else:
                electrical_type = 'B'
            if optional_function:
                pin_names.append(optional_function)
            if configuration_functions:
                pin_names.extend(configuration_functions)
            unit_name = bank
        elif pin_function.startswith('GND'):
            pin_names.append(pin_function)
            unit_name = 'GND'
            electrical_type = 'W'
        elif pin_function == 'VCCINT':
            pin_names.append(pin_function)
            unit_name = 'VCCINT'
            electrical_type = 'W'
        elif pin_function.startswith('VCCIO'):
            pin_names.append(pin_function)
            unit_name = 'VCCIO'
            electrical_type = 'W'
        elif pin_function.startswith('VCC'):
            pin_names.append(pin_function)
            unit_name = 'VCC'
            electrical_type = 'W'
        else:
            pin_names.append(pin_function)
            unit_name = 'MISC'
            electrical_type = 'B'
        
        if len(pin_names) == 0:
            pin_names = [package_pin_name]
        pin_name = '/'.join(pin_names)
        
        pin_data = {
            'name': pin_name,
            'number': pin_number,
            'orientation': 'R',
            'number_text_size': 50,
            'name_text_size': 50,
            'convert': 1,
            'e_type': electrical_type,
            'vrefb_group': vrefb_group,
        }
        units[unit_name].append(pin_data)

def assign_pins_x(pins, x):
    for i in range(len(pins)):
        pins[i]['x'] = x

def assign_pins_length(pins, length):
    for i in range(len(pins)):
        pins[i]['length'] = length

def assign_pins_y(pins):
    pin_spacing = -100
    pin_count = len(pins)
    y_offset = -300
    for i in range(pin_count):
        pin = pins[i]
        y = (i * pin_spacing) + y_offset
        pin['y'] = y

def assign_pins_unit(pins, unit):
    for pin in pins:
        pin['unit'] = unit

pin_template = 'X %(name)s %(number)s %(x)d %(y)d %(length)d %(orientation)s %(number_text_size)d %(name_text_size)d %(unit)d %(convert)d %(e_type)s'

def format_pin(pin):
    return pin_template % pin
    
def format_pins(pins):
    result = []
    for pin in pins:
        result.append(format_pin(pin))
    return result

def format_rectangle(unit_number, start, end):
    return ['S %(start_x)d %(start_y)d %(end_x)d %(end_y)d %(unit)d %(convert)d %(width)d %(fill)s' % {
        'start_x': start[0],
        'start_y': start[1],
        'end_x': end[0],
        'end_y': end[1],
        'unit': unit_number,
        'convert': 1,
        'width': 0,
        'fill': 'N',
    }]
    
def format_polyline(unit_number, points):
    result = ['P %(ccount)d %(unit)d %(convert)d %(width)d' % {
        'ccount': len(points),
        'unit': unit_number,
        'convert': 1,
        'width': 0,
    }]
    for point in points:
        result.append('%(x)d %(y)d' % {
            'x': point[0],
            'y': point[1],
        })
    result.append('%(fill)s' % {
        'fill': 'N',
    })
    
    return [' '.join(result)]

def format_vrefb_groups(unit_number, pins):
    result = []
    groups = frozenset([pin['vrefb_group'] for pin in pins if pin['vrefb_group']])
    for group in groups:
        y_list = [pin['y'] for pin in pins if pin['vrefb_group'] == group]
        y_min = min(y_list)
        y_max = max(y_list)
        result.extend(format_polyline(unit_number, [
            [400, y_min], [500, y_min], [500, y_max], [400, y_max]
        ]))
        
    return result
    
def format_unit(unit_number, pins):
    body_width = 1200
    pin_length = 300
    body_left = -body_width / 2
    body_right = body_width / 2
    pin_left = body_left - pin_length
    assign_pins_x(pins, pin_left)
    assign_pins_length(pins, pin_length)
    assign_pins_y(pins)
    assign_pins_unit(pins, unit_number)
    result = []
    y_min = min([pin['y'] for pin in pins])
    y_max = max([pin['y'] for pin in pins])
    result.extend(format_rectangle(unit_number, [body_left, y_min - 100], [body_right, y_max + 100]))
    result.extend(format_vrefb_groups(unit_number, pins))
    result.extend(format_pins(pins))
    return result

from pprint import pprint
unit_number = 1
for unit_name in sorted(units):
    formatted_pins = format_unit(unit_number, units[unit_name])
    print('\n'.join(formatted_pins))
    unit_number += 1
