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

from kicad.pcbnew import mm_to_kicad, make_nsmd_bga_pads

bga_definition = {
	'spacing': 0.8,

	'pad_diameter': 0.35,
	
	'solder_mask_clearance': 0.075,
	
	'columns': [
	    '1',  '2',  '3',  '4',  '5',  '6',  '7',
	    '8',  '9',  '10', '11', '12', '13', '14',
	],

	'rows': [
	    'A',  'B',  'C',  'D',  'E',  'F',  'G',
	    'H',  'J',  'K',  'L',  'M',  'N',  'P',
	],

	'pads_to_omit': [
	    'A1',
	    'E5', 'E6', 'E7', 'E8', 'E9', 'E10',
	    'F5', 'F10',
	    'G5', 'G10',
		'H5', 'H10',
		'J5', 'J10',
		'K5', 'K6', 'K7', 'K8', 'K9', 'K10',
	],
}

lines = make_nsmd_bga_pads(**bga_definition)

print('\n'.join(lines))