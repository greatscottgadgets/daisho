#!/usr/bin/env python

# Generates text for insertion into a KiCAD module, describing pads for
# the Altera F780 BGA package.
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
	'spacing': 1.0,

	'pad_diameter': 0.5,
	
	'solder_mask_clearance': 0.075,
	
	'columns': [
	    '1',  '2',  '3',  '4',  '5',  '6',  '7',
	    '8',  '9',  '10', '11', '12', '13', '14',
	    '15', '16', '17', '18', '19', '20', '21',
	    '22', '23', '24', '25', '26', '27', '28',
	],

	'rows': [
	    'A',  'B',  'C',  'D',  'E',  'F',  'G',
	    'H',  'J',  'K',  'L',  'M',  'N',  'P',
	    'R',  'T',  'U',  'V',  'W',  'Y',  'AA',
	    'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH',
	],

	'pads_to_omit': [
	    'A1',
	    'A28',
	    'AH1',
	    'AH28',
	],
}

lines = make_nsmd_bga_pads(**bga_definition)

print('\n'.join(lines))