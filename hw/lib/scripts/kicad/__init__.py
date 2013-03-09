# Utilities for working with KiCAD common data and files.
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

import datetime

def date_to_kicad(dt):
	# TODO: day of month should not be zero-padded.
	# e.g. "Thursday, March 7, 2013 12:06:00 PM"
	data = {
		'weekday': dt.strftime('%A'),
		'month': dt.strftime('%B'),
		'day': str(dt.day),
		'year': '%04d' % dt.year,
		'hour': dt.strftime('%I'),
		'minute': '%02d' % dt.minute,
		'second': '%02d' % dt.second,
		'am_pm': dt.strftime('%p'),
	}
	return '{weekday}, {month} {day}, {year} {hour}:{minute}:{second} {am_pm}'.format(**data)
