
//
// daisho usb core verification
//
// Copyright (c) 2012-2014 Marshall H.
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

//#define BUF_SIZE	(2*1024*1024)
#define BUF_SIZE	(8*1024*1024)
#define ITERATIONS	1000

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

	LARGE_INTEGER timer_start_r, timer_start_w;
	LARGE_INTEGER timer_stop_r, timer_stop_w;
	LARGE_INTEGER timer_freq_r, timer_freq_w;
	LONGLONG timer_diff_r, timer_diff_w;
	double timer_dur_r, timer_dur_w;

	void *req_r, *req_w;
	int	bytes_r, bytes_w;

	const int lfsr_buf_size = 1*1024*1024*1024/4;
	const int lfsr_range = lfsr_buf_size/4;
	unsigned int tx_lfsr = 0x38A3D76C;
	unsigned int tx_lfsr_out;
	unsigned int rx_lfsr = 0x38A3D76C;
	unsigned int rx_lfsr_out;
	unsigned int *txbuf;
	unsigned int *rxbuf;

	srand ( time(NULL) );
	//srand(0);

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

	// malloc lfsr buffer
	txbuf = malloc(lfsr_buf_size); // nom nom
	if(txbuf == NULL) {
		printf("FAIL txbuf malloc\n");
		return(-1);
	}
	rxbuf = malloc(lfsr_buf_size); // nom nom
	if(rxbuf == NULL) {
		printf("FAIL rxbuf malloc\n");
		return(-1);
	}

	printf("* Testing %d LFSR write/readback iterations of %d kb\n", ITERATIONS, lfsr_buf_size/1024);

	for(iter = 0; iter < ITERATIONS; iter++){

		printf("* Iteration %d...", iter);

		// fill buffer with unique garbage
		//for(i = 0; i < sizeof(tmp); i++)
		//	ptr[i] = rand() % 255;

		// index for debugging
		//for(i = 0; i < BUF_SIZE / 512; i++){
		//	sprintf(&ptr[i*512], "CHUNK %d, %d", i, time(NULL));
		//}

		for(i = 0; i < lfsr_range; i++){
			tx_lfsr_out	=(	((tx_lfsr >> 27)&1)<<31 | ((tx_lfsr >> 5 )&1)<<30 | ((tx_lfsr >> 3 )&1)<<29 | ((tx_lfsr >> 17)&1)<<28 |
							((tx_lfsr >> 12)&1)<<27 | ((tx_lfsr >> 26)&1)<<26 | ((tx_lfsr >> 22)&1)<<25 | ((tx_lfsr >> 31)&1)<<24 |
							
							((tx_lfsr >> 22)&1)<<23 | ((tx_lfsr >> 8 )&1)<<22 | ((tx_lfsr >> 0 )&1)<<21 | ((tx_lfsr >> 11)&1)<<20 |
							((tx_lfsr >> 13)&1)<<19 | ((tx_lfsr >> 29)&1)<<18 | ((tx_lfsr >> 23)&1)<<17 | ((tx_lfsr >> 15)&1)<<16 |
							
							((tx_lfsr >> 26)&1)<<15 | ((tx_lfsr >> 3 )&1)<<14 | ((tx_lfsr >> 1 )&1)<<13 | ((tx_lfsr >> 29)&1)<<12 |
							((tx_lfsr >> 13)&1)<<11 | ((tx_lfsr >> 25)&1)<<10 | ((tx_lfsr >> 21)&1)<<9  | ((tx_lfsr >> 30)&1)<<8 |
							
							((tx_lfsr >> 25)&1)<<7  | ((tx_lfsr >> 9 )&1)<<6  | ((tx_lfsr >> 2 )&1)<<5  | ((tx_lfsr >> 15)&1)<<4 |
							((tx_lfsr >> 17)&1)<<3  | ((tx_lfsr >> 22)&1)<<2  | ((tx_lfsr >> 5 )&1)<<1  | ((tx_lfsr >> 21)&1)<<0 
							);
			
			tx_lfsr = ( ((tx_lfsr >> 4) ^ (tx_lfsr >> 14) ^ (tx_lfsr >> 27) ^ (tx_lfsr >> 7)) << 31) | (tx_lfsr >> 1);
			txbuf[i] = tx_lfsr_out;
		}

		printf("- started\n");

		///////////////////////////////////////////////////
		QueryPerformanceFrequency(&timer_freq_w);
		QueryPerformanceCounter(&timer_start_w);

		ret = usb_bulk_setup_async(dev, &req_w, 0x2);
		ret = usb_submit_async(req_w, txbuf, lfsr_buf_size);
		if (ret < 0){
			printf("* Couldn't write: %s\n", usb_strerror() );
			return -1;
		}

		///////////////////////////////////////////////////
		QueryPerformanceFrequency(&timer_freq_r);
		QueryPerformanceCounter(&timer_start_r);
		ret = usb_bulk_setup_async(dev, &req_r, 0x81);
		ret = usb_submit_async(req_r, rxbuf, lfsr_buf_size);
		if (ret < 0){
			printf("* Couldn't read: %s\n", usb_strerror() );
			return -1;
		} 
		
		bytes_w = usb_reap_async(req_w, 2000);
		//printf("* KB reaped (W): %d\n", bytes_w / 1024);
		QueryPerformanceCounter(&timer_stop_w);
		timer_diff_w = timer_stop_w.QuadPart - timer_start_w.QuadPart;
		timer_dur_w = (double) timer_diff_w * 1000.0 / (double) timer_freq_w.QuadPart;
		//printf("* WriteComplete in %.2f seconds (%.2f MB/sec)\n", timer_dur_w/1000, lfsr_buf_size/1024/1024/(timer_dur_w/1000));

		bytes_r = usb_reap_async(req_r, 2000);
		//printf("* KB reaped (R): %d\n", bytes_r / 1024);
		QueryPerformanceCounter(&timer_stop_r);
		timer_diff_r = timer_stop_r.QuadPart - timer_start_r.QuadPart;
		timer_dur_r = (double) timer_diff_r * 1000.0 / (double) timer_freq_r.QuadPart;
		//printf("* ReadComplete in %.2f seconds (%.2f MB/sec)\n", timer_dur_r/1000, lfsr_buf_size/1024/1024/(timer_dur_r/1000));

		printf("* BothComplete in %.2f seconds (%.2f MB/sec combined)\n", timer_dur_r/1000, lfsr_buf_size/1024/1024/(timer_dur_r/1000));

		// verify received data against local LFSR
		for(i = 0; i < lfsr_range; i++){
			rx_lfsr_out	=(	((rx_lfsr >> 27)&1)<<31 | ((rx_lfsr >> 5 )&1)<<30 | ((rx_lfsr >> 3 )&1)<<29 | ((rx_lfsr >> 17)&1)<<28 |
							((rx_lfsr >> 12)&1)<<27 | ((rx_lfsr >> 26)&1)<<26 | ((rx_lfsr >> 22)&1)<<25 | ((rx_lfsr >> 31)&1)<<24 |
							
							((rx_lfsr >> 22)&1)<<23 | ((rx_lfsr >> 8 )&1)<<22 | ((rx_lfsr >> 0 )&1)<<21 | ((rx_lfsr >> 11)&1)<<20 |
							((rx_lfsr >> 13)&1)<<19 | ((rx_lfsr >> 29)&1)<<18 | ((rx_lfsr >> 23)&1)<<17 | ((rx_lfsr >> 15)&1)<<16 |
							
							((rx_lfsr >> 26)&1)<<15 | ((rx_lfsr >> 3 )&1)<<14 | ((rx_lfsr >> 1 )&1)<<13 | ((rx_lfsr >> 29)&1)<<12 |
							((rx_lfsr >> 13)&1)<<11 | ((rx_lfsr >> 25)&1)<<10 | ((rx_lfsr >> 21)&1)<<9  | ((rx_lfsr >> 30)&1)<<8 |
							
							((rx_lfsr >> 25)&1)<<7  | ((rx_lfsr >> 9 )&1)<<6  | ((rx_lfsr >> 2 )&1)<<5  | ((rx_lfsr >> 15)&1)<<4 |
							((rx_lfsr >> 17)&1)<<3  | ((rx_lfsr >> 22)&1)<<2  | ((rx_lfsr >> 5 )&1)<<1  | ((rx_lfsr >> 21)&1)<<0 
							);
			
			rx_lfsr = ( ((rx_lfsr >> 4) ^ (rx_lfsr >> 14) ^ (rx_lfsr >> 27) ^ (rx_lfsr >> 7)) << 31) | (rx_lfsr >> 1);

			if(rxbuf[i] != rx_lfsr_out) {
				printf("* Error comparing received data, LFSR mismatch in word %d\n", i);
				printf("* Expected %08X\n* Received %08X\n", rx_lfsr_out, rxbuf[i]);

				if(i >= 2) printf("* Previous values %08X %08X\n", rxbuf[i-2], rxbuf[i-1]);
				if(i >= 2) printf("* Post value %08X\n", rxbuf[i+1]);
				return -1;
			}
		}

	}

	free(txbuf);
	free(rxbuf);
    usb_release_interface(dev, 0);
	if(dev) usb_close(dev);

    printf("\n* Finished\n");
    return 0;
}
