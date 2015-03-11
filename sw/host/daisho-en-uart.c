
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <pcap.h>
#include <stdio.h>
#include <unistd.h>
#include <termios.h>
#include <sys/stat.h>
#include <fcntl.h>

static pcap_t *pcap_dumpfile;
static pcap_dumper_t *dumper;

/* default snap length (maximum bytes per packet to capture) */
#define SNAP_LEN 1518

static void dump_packet(u_char *pkt_data, int packet_length) {

	struct pcap_pkthdr ph;
	struct timeval ts;
	u_char *start;
	gettimeofday(&ts, NULL);

	/* Find start of frame delimiter */
	for (start = pkt_data; *start != 0xd5 && start - pkt_data < packet_length; ++start);
	++start;

	if ((start - pkt_data) >= packet_length) {
		fprintf(stderr, "Unable to find start of frame delimiter\n");
		return;
	}

	ph.ts = ts;
	ph.caplen = ph.len = packet_length - (start - pkt_data);

	pcap_dump((unsigned char *)dumper, &ph, start);
	/* FIXME: don't force a flush
	 * Instead, write a signal handler to flush and close
	 */
	pcap_dump_flush(dumper);
}

static u_char char_to_nibble(int byte)
{
	if ((byte >= 48) && (byte <= 57))
		return byte - 48;
	if ((byte >= 97) && (byte <= 102))
		return byte - 87;
	return 0xff;
}

int sniff_packets(FILE *input)
{
	u_char buf[SNAP_LEN], byte, corrected, *bp = &buf[0];
	int in, first_half = 1;

	while((in = fgetc(input)) != EOF) {
		/* A newline means the end of a packet */
		if (in == 0x0a) {
			dump_packet(buf, bp - &buf[0]);
			bp = &buf[0];
		} else {
			corrected = char_to_nibble(in);
			if (corrected == 0xff) {
				fprintf(stderr, "Dropping unknown nibble: 0x%x\n", in);
				first_half = 1;
				//return 0;
			} else if (first_half) {
				byte = corrected;
				first_half = 0;
			} else {
				byte |= (corrected << 4);
				*bp = byte;
				bp++;
				first_half = 1;
			}
		}
	}

	return 0;
}

static FILE *setup_serial(char *path)
{
	// Reset the device options
	struct termios options;
	FILE *input;
	int fd;

	input = fopen(path, "r");
	if(input == NULL)
		fprintf(stderr, "Cannot open serial device\n");

	fd = fileno(input);

	tcgetattr(fd, &options);

	options.c_oflag = 0;
	options.c_iflag = 0;
	options.c_iflag &= (IXON | IXOFF | IXANY);
	options.c_cflag |= CLOCAL | CREAD;
	options.c_cflag &= ~HUPCL;

	cfsetispeed(&options, B230400);
	cfsetospeed(&options, B230400);

	if (tcsetattr(fd, TCSANOW, &options) < 0) {
		fprintf(stderr, "SerialClient::SetOptions() failed to set serial device attributes");
		return NULL;
	}

	return input;
}

static void usage(void) {
	fprintf(stderr, "daisho-en-uart - Daisho ethernet tap over serial\n");
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "\t-h this help\n");
	fprintf(stderr, "\t-p <filename> PCAP file to write\n");
	fprintf(stderr, "\t-s <filename> file to read (may be a serial device)\n");
}

int main(int argc, char **argv) {
	int opt;
	struct stat buf;
	FILE *input = NULL, *output = NULL;

	while ((opt = getopt(argc,argv,"p:hs:")) != EOF) {
		switch(opt) {
		case 'p':
			output = fopen(optarg, "w");
			break;
		case 's':
			stat(optarg, &buf);
			if (S_ISCHR(buf.st_mode)) {
				input = setup_serial(optarg);
			} else {
				input = fopen(optarg, "r");
			}
			break;
		case 'h':
		default:
			usage();
			return 1;
		}
	}

	if (input == NULL) {
		fprintf(stderr, "No input file given, using stdin\n");
		input = stdin;
	}

	if (output == NULL) {
		fprintf(stderr, "No output file given, using stdout\n");
		output = stdout;
	}

	pcap_dumpfile = pcap_open_dead(DLT_EN10MB, SNAP_LEN);
	if (pcap_dumpfile == NULL)
		fprintf(stderr, "Unable to open pcap file for output\n");
	dumper = pcap_dump_fopen(pcap_dumpfile, output);
	pcap_dump_flush(dumper);

	if (dumper == NULL) {
		fprintf(stderr, "Unable to open pcap dumper for output\n");
		pcap_close(pcap_dumpfile);
		return 1;
	}

	sniff_packets(input);
	return 0;
}
