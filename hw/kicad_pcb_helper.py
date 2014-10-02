#!/usr/bin/env python

# Copyright (c) 2014 Jared Boone, ShareBrained Technology, Inc.
#
# This file is part of Project Daisho.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.

import sys
import re
import math
from collections import defaultdict, OrderedDict

f = open(sys.argv[1], 'r')
file_data = f.read()

# S-Expression parser lifted from:
# http://rosettacode.org/wiki/S-Expressions
# Made available under GNU Free Documentation License 1.2
# Modified to deal with KiCad variant of S-expressions.

dbg = False

term_regex = r'''(?mx)
    \s*(?:
        (?P<brackl>\()|
        (?P<brackr>\))|
        (?P<sq>"[^"]*")|
        (?P<s>[^(^)\s]+)
       )'''

def parse_sexp(sexp):
    stack = []
    out = []
    if dbg: print("%-6s %-14s %-44s %-s" % tuple("term value out stack".split()))
    for termtypes in re.finditer(term_regex, sexp):
        term, value = [(t,v) for t,v in termtypes.groupdict().items() if v][0]
        if dbg: print("%-7s %-14s %-44r %-r" % (term, value, out, stack))
        if   term == 'brackl':
            stack.append(out)
            out = []
        elif term == 'brackr':
            assert stack, "Trouble with nesting of brackets"
            tmpout, out = out, stack.pop(-1)
            out.append(tmpout)
        # elif term == 'num':
        #     v = float(value)
        #     if v.is_integer(): v = int(v)
        #     out.append(v)
        elif term == 'sq':
            out.append(value[1:-1])
        elif term == 's':
            out.append(value)
        else:
            raise NotImplementedError("Error: %r" % (term, value))
    assert not stack, "Trouble with nesting of brackets"
    return out[0]

parsed = parse_sexp(file_data)

net_by_number = {}
net_by_name = {}
for element in parsed:
	if element[0] == 'net':
		net_number, net_name = int(element[1]), element[2]
		net_by_number[net_number] = net_name
		net_by_name[net_name] = net_number
net_names = frozenset(net_by_name.keys())

nets_by_net_class = defaultdict(list)
net_class_by_net = {}
for element in parsed:
	if element[0] == 'net_class':
		net_class_name = element[1]
		for item in element:
			if type(item) == type([]):
				if item[0] == 'add_net':
					net_name = item[1]
					nets_by_net_class[net_class_name].append(net_name)
					if net_name in net_class_by_net:
						raise RuntimeError("net %s has multiple net classes" % net_name)
					net_class_by_net[net_name] = net_class_name
for key, value in nets_by_net_class.items():
	nets_by_net_class[key] = frozenset(value)

def force_trace_widths(board):
	microstrip_layers = frozenset(('1_top', '6_bot'))
	stripline_layers = frozenset(('3_inner', '4_inner'))

	se_50_microstrip_width = '0.1778'
	se_50_stripline_width = '0.1651'

	diff_90_microstrip_width = '0.127'
	diff_90_stripline_width = '0.127'

	for element in board:
		if element[0] == 'segment':
			segment = OrderedDict([(v[0], v[1:]) for v in element[1:]])
			assert len(segment['net']) == 1
			net_name = net_by_number[int(segment['net'][0])]
			assert len(segment['layer']) == 1
			layer = segment['layer'][0]

			new_width = None
			if net_name in nets_by_net_class['50_se']:
				if layer in microstrip_layers:
					new_width = [se_50_microstrip_width]
				if layer in stripline_layers:
					new_width = [se_50_stripline_width]
			elif net_name in nets_by_net_class['90_diff']:
				if layer in microstrip_layers:
					new_width = [diff_90_microstrip_width]
				if layer in stripline_layers:
					new_width = [diff_90_stripline_width]

			if new_width:
				segment['width'] = new_width
				new_elements = [[a] + b for a, b in segment.items()]
				element[1:] = new_elements

def calculate_net_lengths(board, net_class_name, layer_delay_map, via_delay):
	net_names = nets_by_net_class[net_class_name]

	def list_dict():
		return defaultdict(list)
	net_delays = defaultdict(list_dict)

	for element in board:
		if element[0] == 'segment':
			segment = OrderedDict([(v[0], v[1:]) for v in element[1:]])
			net_name = net_by_number[int(segment['net'][0])]
			if net_name in net_names:
				layer_name = segment['layer'][0]
				width = segment['width'][0]
				start = tuple(map(float, segment['start']))
				end = tuple(map(float, segment['end']))
				dx = end[0] - start[0]
				dy = end[1] - start[1]
				length = math.sqrt(dx * dx + dy * dy)
				delay = length * layer_delay_map[layer_name]
				net_delays[net_name][layer_name].append(delay)
		if element[0] == 'via':
			via = OrderedDict([(v[0], v[1:]) for v in element[1:]])
			net_name = net_by_number[int(via['net'][0])]
			if net_name in net_names:
				layer_names = via['layers']
				delay = via_delay
				net_delays[net_name][layer_name].append(delay)

	# TODO: Take into account via delay based on via length. capacitance, inductance
	for net_name, layers in sorted(net_delays.items()):
		total_delay = 0
		for layer_name, delays in layers.items():
			delay = sum(delays)
			total_delay += delay
		print('%s: %.0f ps' % (net_name, total_delay * 1e12))

def print_nets_with_multiple_widths(board):
	def set_dict():
		return defaultdict(set)
	nets = defaultdict(set_dict)

	for element in board:
		if element[0] == 'segment':
			segment = OrderedDict([(v[0], v[1:]) for v in element[1:]])
			net_name = net_by_number[int(segment['net'][0])]
			layer_name = segment['layer'][0]
			width = segment['width'][0]
			nets[net_name][layer_name].add(width)

	for net_name, layers in nets.items():
		for layer_name, widths in layers.items():
			if len(widths) > 1:
				print('%s (%s): %s: %s' % (
					net_name, net_by_name[net_name], layer_name, ', '.join(widths)
				))

def print_tree(o, t, indent=0, scope=''):
	scope = scope + '/' + t[0]
	indent_s = ' ' * indent
	o.write('%s(%s' % (indent_s, t[0]))
	for v in t[1:]:
		if type(v) == type([]):
			o.write('\n')
			print_tree(o, v, indent + 2, scope)
		else:
			escape = ('(' in v) or (')' in v) or (' ' in v) or (len(v) == 0)
			format = ' "%s"' if escape else " %s"
			o.write(format % v)
	o.write(')')

microstrip_single_ended_delay_mm = 151.975e-12 / 25.4
stripline_single_ended_delay_mm = 171.556e-12 / 25.4

layer_delay_single_ended = {
	'1_top': microstrip_single_ended_delay_mm,
	'2_gnd': microstrip_single_ended_delay_mm,
	'3_inner': stripline_single_ended_delay_mm,
	'4_inner': stripline_single_ended_delay_mm,
	'5_pwr': microstrip_single_ended_delay_mm,
	'6_bot': microstrip_single_ended_delay_mm,
}

microstrip_differential_delay_mm = 145.980e-12 / 25.4
stripline_differential_delay_mm = 171.556e-12 / 25.4

layer_delay_differential = {
	'1_top': microstrip_differential_delay_mm,
	'2_gnd': 'invalid',
	'3_inner': stripline_differential_delay_mm,
	'4_inner': stripline_differential_delay_mm,
	'5_pwr': 'invalid',
	'6_bot': microstrip_differential_delay_mm,
}

e_r = 4.1
thickness_inch = 0.0609
via_pad_diameter_inch = 0.457 / 25.4
via_ground_clearance_inch = (0.1778 / 25.4) * 2 + via_pad_diameter_inch
c_via_pf = (1.41 * e_r * thickness_inch * via_pad_diameter_inch) / (via_ground_clearance_inch - via_pad_diameter_inch)
print('via capacitance: %f pF' % c_via_pf)
c_via = c_via_pf / 1e12
z0 = 50.0
t_10_90 = 2.2 * c_via * (z0 / 2.0)
print('T(10-90): %.0f ps' % (t_10_90 * 1e12))
via_delay = t_10_90
#force_trace_widths(parsed)
#print_nets_with_multiple_widths(parsed)

print('=== 50 Ohm single-ended ===')
calculate_net_lengths(parsed, '50_se', layer_delay_single_ended, via_delay)
print

print('=== 90 Ohm differential ===')
calculate_net_lengths(parsed, '90_diff', layer_delay_differential, via_delay)
print

#print_tree(sys.stdout, parsed)
