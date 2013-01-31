#!/usr/bin/env python

# Generates text for insertion into a KiCAD module, describing pads for
# the TI TUSB1310A "ZAY" (S-PBGA-N175) BGA package.
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

from kicad import mm_to_kicad

columns = [
    '1',  '2',  '3',  '4',  '5',  '6',  '7',
    '8',  '9',  '10', '11', '12', '13', '14',
]

rows = [
    'A',  'B',  'C',  'D',  'E',  'F',  'G',
    'H',  'J',  'K',  'L',  'M',  'N',  'P',
]

pads_to_omit = [
    'A1',
    'E5', 'E6', 'E7', 'E8', 'E9', 'E10',
    'F5', 'F10',
    'G5', 'G10',
	'H5', 'H10',
	'J5', 'J10',
	'K5', 'K6', 'K7', 'K8', 'K9', 'K10',
]

def make_nsmd_bga_pad(pad_name, position):
    data = {
        'pad_name': pad_name,
		'pad_width': mm_to_kicad(0.35),
		'pad_height': mm_to_kicad(0.35),
		'solder_mask': mm_to_kicad(0.075),
        'x': mm_to_kicad(position[0]),
        'y': mm_to_kicad(position[1]),
    }
    return [
        '$PAD',
        'Sh "%(pad_name)s" C %(pad_width)s %(pad_height)s 0 0 0' % data,
        'Dr 0 0 0',
        'At SMD N 00888000',
        'Ne 0 ""',
        'Po %(x)s %(y)s' % data,
        '.SolderMask %(solder_mask)s' % data,
        '$EndPAD',
    ]

x_spacing = y_spacing = 0.8

x_offset = float((len(columns) - 1) * x_spacing) / -2.0
y_offset = float((len(rows) - 1) * y_spacing) / -2.0

lines = []
for y_index in range(len(rows)):
    row = rows[y_index]
    y = y_index * y_spacing + y_offset
    for x_index in range(len(columns)):
        column = columns[x_index]
        x = x_index * x_spacing + x_offset
        pad_name = '%s%s' % (row, column)
        if pad_name not in pads_to_omit:
            lines.extend(make_nsmd_bga_pad(pad_name, [x, y]))

print('\n'.join(lines))