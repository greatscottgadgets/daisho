# Hey Emacs, this is a -*- makefile -*-
#
# Makefile for Monulator ARM LPC11U14.
# 
# Copyright 2013 Jared Boone <jared@sharebrained.com>
#
# This file is part of the Monulator project.
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

BINARY = main

C = 

CPP = $(BINARY).cpp \
	serial.cpp \
	lpc11u.cpp

ASM = startup_lpc11u.S

#STACK_SIZE = 3072
#HEAP_SIZE = 0

include Makefile_inc.mk
