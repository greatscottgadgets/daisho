
//
// daisho usb stack verification
//
// Copyright (c) 2012-2013 Marshall H.
// All rights reserved.
// This code is released under the terms of the simplified BSD license. 
// See LICENSE.TXT for details.
//

#include <stdio.h>
#include "libusb.h"

#pragma comment(lib, "libusb.lib")

#include "lusb0_usb.h"

usb_dev_handle *open_device(uint16_t vid, uint16_t pid)
{
    struct usb_bus *bus;
    struct usb_device *dev;

    for (bus = usb_get_busses(); bus; bus = bus->next){
        for (dev = bus->devices; dev; dev = dev->next){
            if (dev->descriptor.idVendor == vid && dev->descriptor.idProduct == pid){
                return usb_open(dev);
            }
        }
    }
    return NULL;
}

void vend_req(usb_dev_handle *dev, int request, int value)
{
	int ret;
	ret = usb_control_msg(dev,
		LIBUSB_ENDPOINT_OUT | LIBUSB_REQUEST_TYPE_VENDOR | LIBUSB_RECIPIENT_DEVICE,
		request, value, 
		0, NULL, 0, 2000);

	if(ret < 0) {
		printf("* Error in VENDOR_REQ send\n");
		exit(-1);
	}
}

#define BUF_SIZE	(2*1024*1024)
#define ITERATIONS	8

int main(void)
{
    usb_dev_handle *dev = NULL;
    static char tmp[BUF_SIZE];
	static char readback[BUF_SIZE];
    int ret;
	int	iter;
	int i;
	unsigned int v = rand();
	unsigned char *ptr = (unsigned char *)tmp;

	//srand ( time(NULL) );
	srand(0);

    usb_init();
    usb_find_busses();
    usb_find_devices();

	printf("Daisho USB controller verification\n\n");

	dev = open_device( 0x1d50, 0x605a );
    if(dev){
		printf("* Opened device\n");
	} else {
		printf("* Can't open device: %s\n", usb_strerror() );
        return 0;
    } 

	ret = usb_set_configuration(dev, 1);
    if (ret < 0) {
		printf("* Can't set config: %s\n", usb_strerror() );
        usb_close(dev);
        return 0;
    } else {
        printf("* Set configuration \n");
    }

	ret = usb_claim_interface(dev, 0);
    if (ret < 0) {
        printf("* Can't claim interface: %s\n", usb_strerror() );
        usb_close(dev);
        return 0;
    } else {
        printf("* Claimed interface\n");
    }

	printf("* Testing %d random write/readback iterations of %d bytes\n", ITERATIONS, BUF_SIZE);
	for(iter = 0; iter < ITERATIONS; iter++){

		printf("* Iteration %d...", iter);

		// fill buffer with unique garbage
		for(i = 0; i < sizeof(tmp); i++)
			ptr[i] = rand() % 255;

		// index for debugging
		for(i = 0; i < BUF_SIZE / 512; i++){
			sprintf(&ptr[i*512], "CHUNK %d, %d", i, time(NULL));
		}

		// write 512 bytes at a time
		for(i = 0; i < BUF_SIZE / 512; i++){

			ret = usb_bulk_write(dev, 0x2, &tmp[i*512], 512, 2000);
			if (ret < 0){
				printf("* Couldn't write: %s\n", usb_strerror() );
				return -1;
			}
			// write chunk to SRAM
			vend_req(dev, 2, i);
		}
		printf(" [write]");

		// read back 512 bytes at a time
		for(i = 0; i < BUF_SIZE / 512; i++){
			
			// fill endpoint with chunk from SRAM
			vend_req(dev, 1, i);

			ret = usb_bulk_read(dev, 0x81, &readback[i*512], 512, 2000);
			if (ret < 0){
				printf("* Couldn't read: %s\n", usb_strerror() );
			}			
			if(memcmp(&tmp[i*512], &readback[i*512], 512) != 0) {
				printf("* Failed at chunk %d\n", i);
				break;
			}
		}
		printf(" [read]\n");

		if(memcmp(tmp, readback, sizeof(tmp)) != 0) {
			printf("* Failed in iteration %d\n", iter);
			break;
		}
	}

    usb_release_interface(dev, 0);
	if(dev) usb_close(dev);

    printf("\n* Finished\n");
    return 0;
}