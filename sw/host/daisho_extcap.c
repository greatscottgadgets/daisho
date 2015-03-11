#include <stdio.h>
#include <getopt.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

void list_interfaces()
{
	/* Adapt to count attached Daisho devices in future
	 * Identify them by bus/device number or serial?
	 */
	printf("interface {display=Daisho0}{value=/dev/ttyUSB0}\n");
	printf("interface {display=Daisho1}{value=/dev/ttyUSB1}\n");
	printf("interface {display=Daisho2}{value=/dev/ttyUSB2}\n");
}

void list_dlts()
{
	printf("dlt {number=1}{name=EN10MB}{display=Ethernet (Daisho)}\n");
}

void show_config()
{
	return;
	printf("arg {number=0}{call=device}{display=Serial Device}{type=selector}\n");
}

void spawn_daisho_en_uart(char *source, char *fifo)
{
	fprintf(stderr, "daisho-en-uart -s %s -p %s\n", source, fifo);
	execlp("daisho-en-uart", "daisho-en-uart", "-s", source, "-p", fifo, NULL);
}

typedef enum {
	LIST_INTERFACES,
	CONFIG,
	INTERFACE,
	LIST_DLTS,
	CAPTURE,
	FIFO
} options;

int main(int argc, char *argv[])
{
	// Turn off the getopt error reporting
	opterr = 0;
	optind = 0;
	int arg, option_idx = 0;
	int do_daisho_en_uart = 0, do_config = 0, do_dlts = 0;
	char *fifo = NULL;
	char *interface = NULL;

	static struct option longopts[] = {
		{ "list-interfaces", no_argument, 0, LIST_INTERFACES},
		{ "config", no_argument, 0, CONFIG},
		{ "interface", required_argument, 0, INTERFACE},
		{ "list-dlts", no_argument, 0, LIST_DLTS},
		{ "capture", no_argument, 0, CAPTURE},
		{ "fifo", required_argument, 0, FIFO},
		{ 0, 0, 0, 0 }
	};

	while ((arg = getopt_long(argc, argv, "", longopts, &option_idx)) >= 0) {
		switch (arg) {
		case LIST_INTERFACES:
			list_interfaces();
			return 0;
		case CONFIG:
			do_config = 1;
			break;
		case INTERFACE:
			interface = strdup(optarg);
			break;
		case LIST_DLTS:
			do_dlts = 1;
			break;
		case CAPTURE:
			do_daisho_en_uart = 1;
			break;
		case FIFO:
			fifo = strdup(optarg);
			break;
		}
	}

	if (do_daisho_en_uart) {
		if (fifo == NULL)
			return -1;

		spawn_daisho_en_uart(interface, fifo);
	}

	if (do_config) {
		if (interface == NULL)
			return -1;

		if (strcmp(interface, "/dev/ttyUSB0") != 0 &&
			strcmp(interface, "/dev/ttyUSB1") != 0 &&
			strcmp(interface, "/dev/ttyUSB2") != 0)
			return -1;

		show_config();

		return 0;
	}

	if (do_dlts) {
		if (interface == NULL)
			return -1;

		if (strcmp(interface, "/dev/ttyUSB0") != 0 &&
			strcmp(interface, "/dev/ttyUSB1") != 0 &&
			strcmp(interface, "/dev/ttyUSB2") != 0)
			return -1;

		list_dlts();

		return 0;
	}

	return -1;
}
