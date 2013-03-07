#!/usr/bin/env python

# Script to convert my KiCAD modules from the newer -testing internal units
# (based on meters) into the old units (in 1/10000 of an inch).
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

import sys

from coroutine import coroutine
from kicad.pcbnew import mm_to_kicad

def convert_mm_args(arg_indices):
	def _convert(line):
		# TODO: Handle spaces within quoted strings!!!
		values = line.split()
		for i in arg_indices:
			if i < len(values):
				values[i] = str(mm_to_kicad(values[i]))
		return ' '.join(values)
	return _convert

def unsupported(line):
	raise RuntimeError('unhandled line: "%s"' % line)

def delete_units(line):
	return None
	
conversions_file = {
	'Units': delete_units,
}

conversions_index = {
}

conversions_module = {
	'Po': convert_mm_args((1, 2)),
	'T0': convert_mm_args((1, 2, 3, 4, 6)),
	'T1': convert_mm_args((1, 2, 3, 4, 6)),
	'DS': convert_mm_args((1, 2, 3, 4, 5)),
	'DC': convert_mm_args((1, 2, 3, 4, 5)),
	'DA': convert_mm_args((1, 2, 3, 4, 6)),
	'DP': unsupported,
	'.SolderMask': convert_mm_args((1,)),
	'.SolderPaste': convert_mm_args((1,)),
	'.LocalClearance': convert_mm_args((1,)),
}

conversions_pad = {
	'Sh': convert_mm_args((3, 4, 5, 6)),
	'Dr': convert_mm_args((1, 2, 3, 5, 6)),
	'Po': convert_mm_args((1, 2)),
	'Le': convert_mm_args((1,)),
	'.SolderMask': convert_mm_args((1,)),
	'.SolderPaste': convert_mm_args((1,)),
	'.LocalClearance': convert_mm_args((1,)),
}

conversions_contexts = {
	'$INDEX': conversions_index,
	'$MODULE': conversions_module,
	'$PAD': conversions_pad,
}

@coroutine
def mod_to_objects():
	conversions = conversions_file
	while True:
		line = (yield)
		line_split = line.split(' ', 1)
		command = line_split[0]
		if command.startswith('$End'):
			conversions = None
		elif command in conversions_contexts:
			conversions = conversions_contexts[command]
		else:
			if conversions and len(line_split) > 1:
				if command in conversions:
					line = conversions[command](line)
		
		if line is not None:
			print(line)
	
input_stream = open(sys.argv[1], 'r')

handler = mod_to_objects()
for line in input_stream:
	handler.send(line.strip())
