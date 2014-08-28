# Utilities for working with KiCAD PCBNew data and files.
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

def degrees_to_kicad(degrees):
	return int(round(float(degrees) * 10.0))

def make_silkscreen_line(start, end, width):
	data = {
		'x1': mm_to_kicad(start[0]),
		'y1': mm_to_kicad(start[1]),
		'x2': mm_to_kicad(end[0]),
		'y2': mm_to_kicad(end[1]),
		'width': mm_to_kicad(width),
		'layer': 21,
	}
	return [
		'DS %(x1)d %(y1)d %(x2)d %(y2)d %(width)d %(layer)d' % data,
	]

def make_silkscreen_rectangle(corners, width):
	corners = (
		(corners[0][0], corners[0][1]),
		(corners[1][0], corners[0][1]),
		(corners[1][0], corners[1][1]),
		(corners[0][0], corners[1][1]),
	)
	result = []
	result += make_silkscreen_line(corners[0], corners[1], width)
	result += make_silkscreen_line(corners[1], corners[2], width)
	result += make_silkscreen_line(corners[2], corners[3], width)
	result += make_silkscreen_line(corners[3], corners[0], width)
	return result
	
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

def make_nsmd_rect_pad(pad_name, pad_width, pad_height, rotation, position):
	data = {
		'pad_name': pad_name,
		'pad_width': mm_to_kicad(pad_width),
		'pad_height': mm_to_kicad(pad_height),
		'orientation': degrees_to_kicad(rotation),
		'x': mm_to_kicad(position[0]),
		'y': mm_to_kicad(position[1]),
	}
	return [
		'$PAD',
		'Sh "%(pad_name)s" R %(pad_width)s %(pad_height)s 0 0 %(orientation)d' % data,
		'Dr 0 0 0',
		'At SMD N 00888000',
		'Ne 0 ""',
		'Po %(x)s %(y)s' % data,
		'$EndPAD',
	]

def make_npth_hole(diameter, position):
	data = {
		'diameter': mm_to_kicad(diameter),
		'x': mm_to_kicad(position[0]),
		'y': mm_to_kicad(position[1]),
	}
	return [
		'$PAD',
		'Sh "" C %(diameter)s %(diameter)s 0 0 0' % data,
		'Dr %(diameter)s 0 0' % data,
		'At HOLE N 00E0FFFF',
		'Ne 0 ""',
		'Po %(x)s %(y)s' % data,
		'$EndPAD',
	]

def make_pth_hole(pad_name, drill_diameter, pad_diameter, position):
	data = {
		'pad_name': pad_name,
		'drill_diameter': mm_to_kicad(drill_diameter),
		'pad_diameter': mm_to_kicad(pad_diameter),
		'x': mm_to_kicad(position[0]),
		'y': mm_to_kicad(position[1]),
	}
	return [
		'$PAD',
		'Sh "%(pad_name)s" C %(pad_diameter)s %(pad_diameter)s 0 0 0' % data,
		'Dr %(drill_diameter)s 0 0' % data,
		'At STD N 00E0FFFF',
		'Ne 0 ""',
		'Po %(x)s %(y)s' % data,
		'$EndPAD',
	]
	
def make_square_qf(n, pitch, land, c1, c2, r1, r2, v1, v2):
	if n % 4 != 0:
		raise RuntimeError('QFP pin count must be evenly divisible by 4')
	
	n_side = n / 4
	pin_row_offset = ((n_side - 1) * pitch) / 2.0
	
	lines = []
	
	lines += make_silkscreen_rectangle(
		((-r1 / 2.0, -r2 / 2.0), (r1 / 2.0, r2 / 2.0)),
		0.2032,
	)	

	lines += make_silkscreen_rectangle(
		((-v1 / 2.0, -v2 / 2.0), (v1 / 2.0, v2 / 2.0)),
		0.2032,
	)	

	for i in range(n_side):
		lines += make_nsmd_rect_pad(
			pad_name=1 + i + (n_side * 0),
			pad_width=land['y'],
			pad_height=land['x'],
			rotation=0.0,
			position=(
				c1 / -2.0,
				(i * pitch) - pin_row_offset,
			),
		)
		lines += make_nsmd_rect_pad(
			pad_name=1 + i + (n_side * 1),
			pad_width=land['y'],
			pad_height=land['x'],
			rotation=90.0,
			position=(
				(i * pitch) - pin_row_offset,
				c2 / 2.0,
			),
		)
		lines += make_nsmd_rect_pad(
			pad_name=1 + i + (n_side * 2),
			pad_width=land['y'],
			pad_height=land['x'],
			rotation=180.0,
			position=(
				c1 / 2.0,
				pin_row_offset - (i * pitch),
			),
		)
		lines += make_nsmd_rect_pad(
			pad_name=1 + i + (n_side * 3),
			pad_width=land['y'],
			pad_height=land['x'],
			rotation=270.0,
			position=(
				pin_row_offset - (i * pitch),
				c2 / -2.0,
			),
		)
	
	return lines

def make_square_qfp(n, pitch, land, c1, c2, r1, r2, v1, v2):
	return make_square_qf(n, pitch, land, c1, c2, r1, r2, v1, v2)

def make_square_qfn(n, pitch, land, thermal, c1, c2, r1, r2, v1, v2):
	lines = make_square_qfp(n, pitch, land, c1, c2, r1, r2, v1, v2)
	
	lines += make_nsmd_rect_pad(
		pad_name=n + 1,
		pad_width=thermal['x'],
		pad_height=thermal['y'],
		rotation=0.0,
		position=(0, 0),
	)
	
	return lines
