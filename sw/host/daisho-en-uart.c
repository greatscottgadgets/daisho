
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <pcap.h>
#include <stdio.h>

static pcap_t *pcap_dumpfile;
static pcap_dumper_t *dumper;

/* default snap length (maximum bytes per packet to capture) */
#define SNAP_LEN 1518

void dump_packet(u_char *pkt_data, int packet_length) {

	struct pcap_pkthdr ph;
	struct timeval ts;
	u_char *start;
	gettimeofday(&ts, NULL);

	/* Find start of frame delimiter */
	for(start=pkt_data; *start!=0xd5 && start-pkt_data < packet_length; ++start);
	++start;

	if((start-pkt_data) >= packet_length) {
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

u_char char_to_nibble(int byte) {
	if((byte >= 48) && (byte <= 57))
		return byte - 48;
	if((byte >= 97) && (byte <= 102))
		return byte - 87;
	return 0xff;
}

int sniff_packets(FILE *input) {
	u_char buf[SNAP_LEN], byte, corrected, *bp = &buf[0];
	int in, first_half = 1;

	while((in=fgetc(input)) != EOF) {
		/* A newline means the end of a packet */
		if(in == 0x0a) {
			dump_packet(buf, bp - &buf[0]);
			bp = &buf[0];
		} else {
			corrected = char_to_nibble(in);
			if(corrected == 0xff) {
				fprintf(stderr, "Dropping unknown nibble: 0x%x\n", in);
				first_half = 1;
				return 0;
			}
			else if(first_half) {
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

void usage() {
	fprintf(stderr, "daisho-en-uart - Daisho ethernet tap over serial\n");
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "\t-h this help\n");
	fprintf(stderr, "\t-p <filename> PCAP file to write\n");
	fprintf(stderr, "\t-s <filename> file to read (may be a serial device)\n");

}

int main(int argc, char **argv) {
	int opt;
	FILE *input;

	while ((opt=getopt(argc,argv,"p:hs:")) != EOF) {
		switch(opt) {
		case 'p':
			pcap_dumpfile = pcap_open_dead(DLT_EN10MB, SNAP_LEN);
			if (pcap_dumpfile == NULL)
				fprintf(stderr, "Unable to open pcap file for output\n");
			dumper = pcap_dump_open(pcap_dumpfile, optarg);
			pcap_dump_flush(dumper);
			if (dumper == NULL) {
				fprintf(stderr, "Unable to open pcap dumper for output\n");
				pcap_close(pcap_dumpfile);
				return 1;
			}
			break;
		case 's':
			input = fopen(optarg, "r");
			break;
		case 'h':
		default:
			usage();
			return 1;
		}
	}

	if(input==NULL) {
		fprintf(stderr, "No input file given, using stdin\n");
		input = stdin;
	}
	
	sniff_packets(input);
	return 0;
}
