Daisho Milestone 32
===================

Demonstrate RS-232 pass-through using the Terasic DE2-115 FPGA development
board and HSMC communication board.

"The platform and RS-232 front-end connected in-line with a target RS-232
link should operate in a pass-through mode such that the link functions as
it would without the platform in place."

Requirements
============

* Altera Quartus II Web Edition 12.1
* Terasic DE2-115 FPGA development board
* Terasic(?) HSMC communication board

Connections
===========

Two RS-232 DB-9 connectors are utilized:

* J6 "RS-232" on the DE2-115 board
* J3 "RS232 (0)" on the HSMC communication board

Beware that the TX and RX pinouts are different between the two connectors.

Indications
===========

Four LEDs on the DE2-115 are used to show data present on the connectors:

* LEDG0: HSMC RXD (input from external device)
* LEDG1: DE2-115 TXD (output to external device)
* LEDG2: HSMC TXD (output to external device)
* LEDG3: DE2-115 RXD (input from external device)

LEDs LEDG0 and LEDG1 should blink in unison, and LEDs LEDG2 and LEDG3 should
blink in unison.

The DE2-115 also has RXD1 and TXD1 LEDs near J6 "RS-232" that indicate data
present on the RS-232 connector.

License
=======

This sub-project is part of the Daisho project.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

Contact
=======

The latest version of this repository can be found at
https://github.com/mossmann/daisho
