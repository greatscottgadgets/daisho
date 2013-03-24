#!/usr/bin/env python

from kicad.pcbnew import make_square_qfn

qfn_definition = {
	'n': 20,
	'pitch': 0.5,
	'land': {
		'x': 0.3,
		'y': 0.75,
	},
	'thermal': {
		'x': 2.75,
		'y': 2.75,
	},
	'c1': 3.9,
	'c2': 3.9,
	'r1': 4.0,
	'r2': 4.0,
	'v1': 4.9,
	'v2': 4.9,
}

lines = make_square_qfn(**qfn_definition)

print('\n'.join(lines))
