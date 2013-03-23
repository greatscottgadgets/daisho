#!/usr/bin/env python

from kicad.pcbnew import make_square_qfp

qfp_definition = {
	'n': 48,
	'pitch': 0.5,
	'land': {
		'x': 0.3,
		'y': 1.50,
	},
	'c1': 8.4,
	'c2': 8.4,
	'r1': 6.2,
	'r2': 6.2,
	'v1': 10.4,
	'v2': 10.4,
}

lines = make_square_qfp(**qfp_definition)

print('\n'.join(lines))
