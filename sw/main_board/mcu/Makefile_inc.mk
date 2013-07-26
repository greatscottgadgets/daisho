# Hey Emacs, this is a -*- makefile -*-
#
# Copyright 2009 Uwe Hermann <uwe@hermann-uwe.de>
# Copyright 2010 Piotr Esden-Tempski <piotr@esden.net>
# Copyright 2012 Michael Ossmann <mike@ossmann.com>
# Copyright 2012 Benjamin Vernoux <titanmkd@gmail.com>
# Copyright 2012 Jared Boone <jared@sharebrained.com>
#
# This file is part of the Monulator project.
# It was derived from Makefiles in libopencm3 and HackRF.
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
#

Q := @

BOARD ?= MONULATOR_LPC11U14

PRODUCT_OPTS = -D$(BOARD)

LDSCRIPT ?= lpc11u14.ld

PREFIX ?= arm-none-eabi
CC = $(PREFIX)-gcc
CXX = $(PREFIX)-g++
AS = $(PREFIX)-g++
LD = $(PREFIX)-g++
OBJCOPY = $(PREFIX)-objcopy
OBJDUMP = $(PREFIX)-objdump
SIZE = $(PREFIX)-size
GDB = $(PREFIX)-gdb
TOOLCHAIN_DIR := $(shell dirname `which $(CC)`)/../$(PREFIX)

ARCH_FLAGS = -mthumb -mcpu=cortex-m0

DEBUG_OPT = -O0
RELEASE_OPT = -Os -ffunction-sections -fdata-sections
OPT = $(DEBUG_OPT)
ifeq ($(RELEASE),1)
    OPT = $(RELEASE_OPT)
endif

COMMON += -g3
COMMON += -Wall -Wextra
COMMON += -MD
COMMON += -specs=nano.specs
#COMMON += -D__STACK_SIZE=$(STACK_SIZE)
#COMMON += -D__HEAP_SIZE=$(HEAP_SIZE)
#COMMON += -specs=rdimon.specs

CFLAGS += -std=c99

CXXFLAGS += -std=c++11
CXXFLAGS += -Weffc++
CXXFLAGS += -fno-exceptions
CXXFLAGS += -fno-rtti
CXXFLAGS += -lstdc++

LDFLAGS += -L .
LDFLAGS += -T $(LDSCRIPT)
LDFLAGS += -T sections.ld
LDFLAGS += -lc
LDFLAGS += -lc
LDFLAGS += -lnosys
#LDFLAGS += -lrdimon
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,-Map=$(BINARY).map

OBJ = $(C:.c=.o) $(CPP:.cpp=.o) $(ASM:.S=.o)

.SUFFIXES: .elf .bin .hex .srec .list .images
.SECONDEXPANSION:
.SECONDARY:

all: images

images: $(BINARY).images
flash: $(BINARY).flash

program: $(BINARY).dfu
	$(Q)dfu-util --device 1fc9:000c --alt 0 --download $(BINARY).dfu

%.images: %.bin %.hex %.srec %.list
	@#echo "*** $* images generated ***"

%.dfu: %.bin
	$(Q)rm -f _tmp.dfu _header.bin
	$(Q)cp $(*).bin _tmp.dfu
	$(Q)dfu-suffix --vid=0x1fc9 --pid=0x000c --did=0x0 -s 0 -a _tmp.dfu
	$(Q)python -c "import os.path; import struct; print('0000000: da ff ' + ' '.join(map(lambda s: '%02x' % ord(s), struct.pack('<H', os.path.getsize('$(*).bin') / 512 + 1))) + ' ff ff ff ff')" | xxd -g1 -r > _header.bin
	$(Q)cat _header.bin _tmp.dfu >$(*).dfu
	$(Q)rm -f _tmp.dfu _header.bin

%.bin: %.elf
	@printf "  OBJCOPY $(*).bin\n"
	$(Q)$(OBJCOPY) -Obinary -j .text -j .ARM.exidx $(*).elf $(*).bin

%.hex: %.elf
	@printf "  OBJCOPY $(*).hex\n"
	$(Q)$(OBJCOPY) -Oihex $(*).elf $(*).hex

%.srec: %.elf
	@printf "  OBJCOPY $(*).srec\n"
	$(Q)$(OBJCOPY) -Osrec $(*).elf $(*).srec

%.list: %.elf
	@printf "  OBJDUMP $(*).list\n"
	$(Q)$(OBJDUMP) -S $(*).elf > $(*).list

%.elf: $(OBJ)
	@printf "  LD      $(subst $(shell pwd)/,,$(@))\n"
	$(Q)$(LD) $(ARCH_FLAGS) $(COMMON) $(OPT) $(PRODUCT_OPTS) $(CFLAGS) $(CXXFLAGS) $(LDFLAGS) -o $(*).elf $(OBJ)
	$(Q)$(SIZE) $(*).elf

%.o: %.c
	@printf "  CC      $(subst $(shell pwd)/,,$(@))\n"
	$(Q)$(CC) $(ARCH_FLAGS) $(COMMON) $(OPT) $(PRODUCT_OPTS) $(CFLAGS) -o $@ -c $<

%.o: %.S
	@printf "  S       $(subst $(shell pwd)/,,$(@))\n"
	$(Q)$(AS) $(ARCH_FLAGS) $(COMMON) $(OPT) $(PRODUCT_OPTS) $(ASFLAGS) -o $@ -c $<

%.o: %.cpp
	@printf "  CXX     $(subst $(shell pwd)/,,$(@))\n"
	$(Q)$(CXX) $(ARCH_FLAGS) $(COMMON) $(OPT) $(PRODUCT_OPTS) $(CXXFLAGS) -o $@ -c $<

clean:
	$(Q)rm -f *.o
	$(Q)rm -f *.d
	$(Q)rm -f *.lst
	$(Q)rm -f *.elf
	$(Q)rm -f *.bin
	$(Q)rm -f *.dfu
	$(Q)rm -f _tmp.dfu _header.bin
	$(Q)rm -f *.hex
	$(Q)rm -f *.srec
	$(Q)rm -f *.lst
	$(Q)rm -f *.list
	$(Q)rm -f *.map

.PHONY: images clean

#-include $(OBJ:.o=.d)
