
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

int main(void)
{
    usb_dev_handle *dev = NULL;
    char tmp[512];
	char readback[512];
    int ret;
	int	iter;
	int i;
	unsigned int v = rand();
	unsigned char *ptr = (unsigned char *)tmp;

	srand ( time(NULL) );

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

	printf("* Testing 1024 random write/readback iterations\n");
	for(iter = 0; iter < 1024; iter++){

		for(i = 0; i < sizeof(tmp); i++)
			ptr[i] = rand() % 255;

		ret = usb_bulk_write(dev, 0x2, tmp, sizeof(tmp), 2000);
		if (ret < 0){
			printf("* Couldn't write: %s\n", usb_strerror() );
		} else {
			//printf("* Wrote %d bytes\n", ret);
		}

		ret = usb_bulk_read(dev, 0x81, readback, sizeof(tmp), 2000);
		if (ret < 0){
			printf("* Couldn't read: %s\n", usb_strerror() );
		} else {
			//printf("* Read %d bytes\n", ret);
		}

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