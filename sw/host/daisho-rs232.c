
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
		printf("Calling bulk_transfer (read)\n");
		vend_req(dev, 1, 1);
		ret = libusb_bulk_transfer(dev, 0x81, readback, BUF_LEN, &transferred, 2000);
		if (ret < 0){
			printf("* Couldn't read: %s\n", libusb_error_name(ret));
			break;
		} else {
			printf("Working (%d)\n", transferred);
			for(i=0;i<transferred;i++)
				printf("%02x ", readback[i]);
			printf("\n");
			//break;
		}
	}

    libusb_release_interface(dev, 0);
	if(dev) libusb_close(dev);

    printf("\n* Finished\n");
    return 0;
}