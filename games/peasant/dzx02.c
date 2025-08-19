/*
 * De-compressor for ZX02 files
 * (c) 2022 DMSC
 * Code under MIT license, see LICENSE file.
 *
 * modified to be as simple as possible (vince weaver)
 * assumes only one buffer of size (here 128k?)
 */

#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Input / Output buffer size. */
/* 128k? */

#define BUF_SIZE (1 << 17)

static uint8_t bitr;      // bit reserve
static uint8_t extra_bit; // extra bit to inject
static uint16_t offset;   // last offset
static uint16_t ipos;     // input position
static uint16_t opos;     // output position

static uint8_t output[BUF_SIZE]; // output data
static uint8_t input[BUF_SIZE];  // input data

static uint8_t get_byte(void) {

    ipos = ipos + 1;

    return input[ipos-1];
}

static uint8_t get_bit(void) {

	uint8_t bit,c;

	if (extra_bit) {
		bit = extra_bit & 1;
		extra_bit = 0;
	} else {
		if (bitr == 0x80) {
			c = get_byte();
			bit = (c & 0x80) != 0;
			bitr = (c << 1) | 1;
		} else {
			bit = (bitr & 0x80) != 0;
			bitr = (bitr << 1);
		}
	}
	return bit;
}

static void put_byte(uint8_t b) {

    output[opos] = b;
    opos = opos + 1;

}

/* Reads interlaced elias code */
static uint16_t get_elias(void) {

	uint16_t ret = 1;
	uint8_t i,b;

	for (i = 0; i <= 8; i++) {

		b = get_bit();
		if (b == 0) return ret;

		ret = (ret << 1) | get_bit();

		if (ret > 0x100) return 0;

	}

	return 0;
}

static void decode_literal(void) {

	uint8_t c;

	uint16_t len = get_elias();

	if (!len) return;

	while (len--) {
		c = get_byte();
		put_byte(c);
	}
}

static void decode_match(int len_add) {

	uint16_t len = get_elias() + len_add;
	uint16_t pos = opos;

	if (len > 0x100) {
		len = len & 0xFF;
	}
	pos = pos - offset - 1;

	if (!len) return;

	while (len--) {
		put_byte(output[pos]);
		pos = pos + 1;
	}
}

static int decode_offset(void) {

	uint16_t msb = get_elias();
	uint16_t off;

	if ((msb & 0xFF) == 0) return 1;

	msb = msb - 1;

	off = get_byte();

	// las bit in offset LSB is used as next bit to be read:
	extra_bit = 2 | (off & 1);
	offset = (msb << 7) | (off >> 1);

	return 0;
}

static int decode_loop(void) {

	uint16_t state = 0; /* LITERAL */

	while (1) {
		switch (state) {
			case 0:		/* Decode literal value: */
				decode_literal();
				if (get_bit()) state = 2;
				else state = 1;
				break;
			case 2:		/* Decode new offset: */
				if (decode_offset()) {
					return 1; /*  implies we are done */
				}
				decode_match(1);

				if (get_bit()) state = 2;
				else state = 0;
				break;
			case 1:		/*  Decode repeated offset: */
				decode_match(0);
				if (get_bit()) state = 2;
				else state = 0;
				break;
		}
	}
}

/* Decompress file */
int decompress(void) {

	opos = 0;
	bitr = 0x80;
	ipos = 0;

	decode_loop();

	fwrite(output, opos, 1, stdout);

	return 0;
}

int main(int argc, char **argv) {

	FILE *in;        // input file

	if (argc<2) {
		fprintf(stderr,"Error: no filename\n");
		return -1;
	}

	in = fopen(argv[1], "rb");
	if (in==NULL) {
		fprintf(stderr,"Error opening %s\n",argv[1]);
		return -1;
	}

	// Read "full" input
	fread(input, 1, BUF_SIZE, in);

	decompress();

	return 0;
}
