# Utilities for working with KiCAD data and files.
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

factor_mm_to_kicad_old_units = 1.0 / 25.4 * 10000.0

def mm_to_kicad(mm):
	return int(round(float(mm) * factor_mm_to_kicad_old_units))

def make_nsmd_bga_pad(pad_name, pad_diameter, solder_mask_clearance, position):
    data = {
        'pad_name': pad_name,
		'pad_width': mm_to_kicad(pad_diameter),
		'pad_height': mm_to_kicad(pad_diameter),
		'solder_mask': mm_to_kicad(solder_mask_clearance),
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

def make_nsmd_bga_pads(spacing, pad_diameter, solder_mask_clearance, columns, rows, pads_to_omit):
	x_spacing = y_spacing = spacing
	
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
	            lines.extend(make_nsmd_bga_pad(pad_name, pad_diameter, solder_mask_clearance, [x, y]))

	return lines
