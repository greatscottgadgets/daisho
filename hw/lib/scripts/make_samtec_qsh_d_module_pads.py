#!/usr/bin/env python

# Generates text for insertion into a KiCAD module, describing pads for
# the Samtec QSH-XXX-XX-X-D-XXX mezzanine connector.
# 
# Copyright (C) 2014 Jared Boone, ShareBrained Technology, Inc.
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

from kicad.pcbnew import make_nsmd_rect_pad, make_npth_hole, make_pth_hole
	
def shift_pad_positions(position_delta, pads):
	for pad in pads:
		pad['position'][0] += position_delta[0]
		pad['position'][1] += position_delta[1]
	return pads

def add_to_pad_names(n, pads):
	for pad in pads:
		pad['pad_name'] += n
	return pads

def center(pads):
	pad_xs = [pad['position'][0] for pad in pads]
	min_x = min(pad_xs)
	max_x = max(pad_xs)
	pad_ys = [pad['position'][1] for pad in pads]
	min_y = min(pad_ys)
	max_y = max(pad_ys)
	center_x = (min_x + max_x) / 2.0
	center_y = (min_y + max_y) / 2.0
	return shift_pad_positions((-center_x, -center_y), pads)
	
def make_signal_pads():
	position_count = 30
	position_spacing = 0.50
	row_spacing = 2.865
	pad_width = 0.279
	pad_height = 2.27
	pads = []
	for pad_row in range(position_count):
		pads.append({
			'pad_name': pad_row * 2 + 1,
			'pad_width': pad_width,
			'pad_height': pad_height,
			'rotation': 0.0,
			'position': [pad_row * position_spacing, row_spacing],
		})
		pads.append({
			'pad_name': pad_row * 2 + 2,
			'pad_width': pad_width,
			'pad_height': pad_height,
			'rotation': 0.0,
			'position': [pad_row * position_spacing, -row_spacing],
		})
	return center(pads)

def make_ground_pads(bank_index):
	pad_name_prefix = chr(ord('A') + bank_index)
	short_pad_width = 2.54
	short_pad_spacing = 16.13
	long_pad_width = 4.7
	long_pad_spacing = 6.35
	pad_height = 0.43
	pad_y = 0.0
	return [
		{
			'pad_name': pad_name_prefix + '0',
			'pad_width': short_pad_width,
			'pad_height': pad_height,
			'rotation': 0.0,
			'position': [-short_pad_spacing / 2.0, pad_y],
		},
		{
			'pad_name': pad_name_prefix + '1',
			'pad_width': long_pad_width,
			'pad_height': pad_height,
			'rotation': 0.0,
			'position': [-long_pad_spacing / 2.0, pad_y],
		},
		{
			'pad_name': pad_name_prefix + '2',
			'pad_width': long_pad_width,
			'pad_height': pad_height,
			'rotation': 0.0,
			'position': [long_pad_spacing / 2.0, pad_y],
		},
		{
			'pad_name': pad_name_prefix + '3',
			'pad_width': short_pad_width,
			'pad_height': pad_height,
			'rotation': 0.0,
			'position': [short_pad_spacing / 2.0, pad_y],
		},
	]

def make_option_a_holes(banks):
	y = -2.67
	spacing_map = {
		1: 20.13,
		2: 40.13,
		3: 60.13,
	}
	spacing = spacing_map[banks]
	diameter = 1.02
	return [
		{
			'diameter': diameter,
			'position': [-spacing / 2.0, y],
		},
		{
			'diameter': diameter,
			'position': [spacing / 2.0, y],
		},
	]

def make_option_l_holes(positions):
	y = 0.51
	spacing_map = {
		30: 24.36,
		60: 44.36,
		90: 64.36,
	}
	spacing = spacing_map[positions]
	drill_diameter = 2.03
	pad_diameter = 5.08
	return [
		{
			'pad_name': '',
			'drill_diameter': drill_diameter,
			'pad_diameter': pad_diameter,
			'position': [-spacing / 2.0, y],
		},
		{
			'pad_name': '',
			'drill_diameter': drill_diameter,
			'pad_diameter': pad_diameter,
			'position': [spacing / 2.0, y],
		},
	]

def make_option_rt1_holes(banks):
	y = 0.0
	spacing_map = {
		1: 28.68,
		2: 48.68,
		3: 68.68,
	}
	spacing = spacing_map[banks]
	drill_diameter = 3.96
	pad_diameter = 6.5
	return [
		{
			'pad_name': '',
			'drill_diameter': drill_diameter,
			'pad_diameter': pad_diameter,
			'position': [-spacing / 2.0, y],
		},
		{
			'pad_name': '',
			'drill_diameter': drill_diameter,
			'pad_diameter': pad_diameter,
			'position': [spacing / 2.0, y],
		},
	]
	
def make_footprint(banks):
	pads = []
	bank_spacing = 20.003
	for bank_index in range(banks):
		bank_position = (bank_index * bank_spacing, 0.0)
		signal_pads = add_to_pad_names(
			bank_index * 60,
			make_signal_pads()
		)
		ground_pads = make_ground_pads(bank_index)
		bank_pads = signal_pads + ground_pads
		pads += shift_pad_positions(
					bank_position,
					bank_pads
				)
	
	npth_holes = make_option_a_holes(banks)
	pth_holes = make_option_l_holes(banks * 30) + make_option_rt1_holes(banks)
	
	return center(pads), npth_holes, pth_holes

kicad_text = []
pads, npth_holes, pth_holes = make_footprint(3)
for pad in pads:
	kicad_text.extend(
		make_nsmd_rect_pad(**pad)
	)
for npth_hole in npth_holes:
	kicad_text.extend(
		make_npth_hole(**npth_hole)
	)
for pth_hole in pth_holes:
	kicad_text.extend(
		make_pth_hole(**pth_hole)
	)
print('\n'.join(kicad_text))
