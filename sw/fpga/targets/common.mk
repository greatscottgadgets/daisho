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

# Assume that quartus_cmd and quartus_pgm are in $PATH unless
QUARTUS_CMD = quartus_cmd
QUARTUS_PGM = quartus_pgm
QUARTUS_CPF = quartus_cpf

OUTPUT_DIR = output
OUTPUT_FILE = $(OUTPUT_DIR)/$(TARGET).sof
SETTINGS_FILE = $(TARGET).qsf

all: $(OUTPUT_FILE)

$(OUTPUT_FILE):
	$(QUARTUS_CMD) $(TARGET) -c $(SETTINGS_FILE)
	
program: $(OUTPUT_DIR)/$(TARGET).sof
	$(QUARTUS_PGM) --mode=jtag -o "P;$(OUTPUT_FILE)@1"

flash: $(TARGET).opt $(OUTPUT_DIR)/$(TARGET).sof
	$(QUARTUS_CPF) --convert --option=$(TARGET).opt --device=EPCS64 $(OUTPUT_DIR)/$(TARGET).sof $(TARGET).pof
	#$(QUARTUS_PGM) --mode=jtag -o "P;$(OUTPUT_FILE)@1"
	
optionfile:
	$(QUARTUS_CPF) -w $(TARGET).opt

clean:
	rm -rf output db incremental_db

.PHONY: all clean program $(OUTPUT_FILE)
