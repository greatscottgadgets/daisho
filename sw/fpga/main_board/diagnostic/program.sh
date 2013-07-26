#!/bin/sh

jtag <<COMMANDSEND
cable jtagkey vid=0x0403 pid=0x6010 interface=0 driver=ftdi-mpsse
frequency 1000000
bsdl path ../..
detect
svf output_files/diagnostic.svf progress stop
COMMANDSEND

