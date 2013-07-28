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

CC      ?= gcc
AR      ?= ar
INSTALL ?= /usr/bin/install
LDCONFIG ?= /sbin/ldconfig

OPTFLAGS   = -O3 -Wall
CFLAGS    += $(OPTFLAGS)

LIB_DIR ?= /usr/local/lib
INCLUDE_DIR ?= /usr/local/include
INSTALL_DIR ?= /usr/local/bin

OS = $(shell uname)
ifeq ($(OS), FreeBSD)
	LIBUSB = usb
	CFLAGS += -DFREEBSD
else
	LIBUSB = usb-1.0
endif

LDFLAGS += -l$(LIBUSB)

TOOLS = daisho-rs232


LIB_NAME   = libdaisho.so
SONAME     = $(LIB_NAME).0
LIB_FILE   = $(SONAME).1

LIB_CFLAGS = $(CFLAGS) -shared -Wl,-soname,$(SONAME)

LIB_SOURCE_FILES = daisho.c
LIB_OBJECT_FILES = $(LIB_SOURCE_FILES:%.c=%.o)
LIB_HEADER_FILES = $(LIB_SOURCE_FILES:%.c=%.h)

TOOLS_SOURCE = $(TOOLS:%=%.c)

all: $(LIB_FILE) $(TOOLS) daisho-en-uart

$(LIB_FILE): $(LIB_SOURCE_FILES) $(LIB_HEADER_FILES)
	$(CC) $(CFLAGS) -fPIC -c $(LIB_SOURCE_FILES)
	$(CC) $(LIB_CFLAGS) -o $(LIB_FILE) $(LIB_OBJECT_FILES) $(LDFLAGS)

# Temporary
daisho-en-uart:
	$(CC) $(CFLAGS) -o $@ $@.c -lpcap

$(TOOLS): $(LIB_FILE) $(TOOLS_SOURCE)
		$(CC) $(CFLAGS) -o $@ $@.c $(LIB_FILE) $(LDFLAGS)

$(STATIC_LIB_FILE): $(LIB_FILE)
	$(AR) rcs $(STATIC_LIB_FILE) $(LIB_OBJECT_FILES)

install: $(LIB_FILE) $(TOOLS)
	$(INSTALL) -m 0644 $(LIB_HEADER_FILES) $(INCLUDE_DIR)
	$(INSTALL) -m 0644 $(LIB_FILE) $(LIB_DIR)
	ln -fs $(LIB_FILE) $(LIB_DIR)/$(LIB_NAME)
	ln -fs $(LIB_FILE) $(LIB_DIR)/$(SONAME)
	$(LDCONFIG)
	$(INSTALL) -m 0755 $(TOOLS) $(INSTALL_DIR)

clean:
	rm -f $(LIB_NAME).* $(TOOLS) $(LIB_OBJECT_FILES) daisho-en-uart

.PHONY: all clean install
