/*
 * Copyright 2013 Dominic Spill
 * Copyright (c) 2013 Jared Boone, ShareBrained Technology, Inc.
 *
 * This file is part of Project Daisho.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#include "daisho.h"
#include <stdlib.h>
#include <stdio.h>

#define BUF_LEN 512
int main(void)
{
    int i, ret, transferred;
	struct libusb_device_handle *dev = NULL;
	unsigned char readback[BUF_LEN];

	ret = libusb_init(NULL);
	if (ret < 0) {
		fprintf(stderr, "libusb_init failed (got 1.0?)\n");
		return 1;
	}
	libusb_set_debug(NULL, 3);

	printf("Daisho USB controller verification\n\n");

	dev = open_daisho_device();
	if (dev == NULL) {
		printf("Failed to find Daisho device\n");
		return -1;
	}
	printf("got device\n");
	ret = libusb_set_configuration(dev, 1);
    if (ret < 0) {
		printf("* Can't set config: %s\n", libusb_error_name(ret));
        libusb_close(dev);
        return -1;
    } else {
        printf("* Set configuration \n");
    }

	ret = libusb_claim_interface(dev, 0);
    if (ret < 0) {
        printf("* Can't claim interface: %s\n", libusb_error_name(ret));
        libusb_close(dev);
        return -1;
    } else {
        printf("* Claimed interface\n");
    }

	while(1) {
		ret = libusb_bulk_transfer(dev, 0x81, readback, BUF_LEN, &transferred, 0);
		if (ret < 0){
			printf("* Couldn't read: %s\n", libusb_error_name(ret));
			break;
		/* Ignore case where we have an incomplete state */
		} else if (transferred > 0) {
			for(i=0;i<transferred;i++)
				printf("%02x ", readback[i]);
			printf("\n");
		}
		fflush(NULL);
	}

    libusb_release_interface(dev, 0);
	if(dev) libusb_close(dev);

    printf("\n* Finished\n");
    return 0;
}
