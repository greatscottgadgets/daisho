#!/usr/bin/env python

# Copyright 2013 Dominic Spill
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

import serial, sys
import random, string
import time

ports = ['/dev/ttyUSB0', '/dev/ttyUSB1']

devices = tuple([(serial.Serial(x, timeout=0), x) for x in ports])

iterations = 10
block_len = 1024

print "Daisho RS-232 pass-through test"
print "Attempting to transfer %d blocks of %d bytes between '%s' and '%s'\n" % \
    (iterations, block_len, ports[0], ports[1])
for iteration in range(1, iterations+1):
    tx = devices[0]
    rx = devices[1]

    print "Block %d: '%s' -> '%s'" % (iteration, tx[1], rx[1])
    block = ''.join(
        random.choice(string.ascii_uppercase + string.digits)
        for x in range(block_len)
    )

    tx[0].write(block)
    # Give it time to fill the rx buffer
    time.sleep(2)
    rx_bytes = rx[0].read(size=block_len)

    if len(rx_bytes) == block_len and rx_bytes == block:
        print "Successfully transferred.\n"
    else:
        print "Failed.\n"
        break

    devices = (rx, tx)
