#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "readp.h"

static int debug=1;

/* for ICEKNGDM.UP */

//struct st_readp {
//	int16_t	magic;	0xfcfd
//	int16_t	width;	0x0140 = 320
//	int16_t	height;	0x0190 = 400
//	int16_t	colors;	0x0100 = 256
//	int16_t	add;	0x0031 = 49?
//};

/* 16 bytes header */
/* colors*3 palette */
/* add*16 -> start of data? seems to take you to 16-byte padded area*/

/* read a row from the image */
/* if row is -1 then copy the palette */

/* row starts with 2-byte pointer to next row */

/* Does RLE */

void readp(unsigned char *dest, int row, unsigned char *src) {

	int16_t bytes;//,a,b;
	struct st_readp hdr;

	hdr.magic=(src[1]<<8)+src[0];
	hdr.width=(src[3]<<8)+src[2];
	hdr.height=(src[5]<<8)+src[4];
	hdr.colors=(src[7]<<8)+src[6];
	hdr.add=(src[9]<<8)+src[8];

	if (debug) {
		fprintf(stderr,"Looking for row: %d Header: magic %hx, %hd x %hd\n",
		row,hdr.magic,hdr.width,hdr.height);
	}

	if (hdr.magic!=0xfcfd) {
		fprintf(stderr,"Error! Invalid UP magic %x\n",hdr.magic);
		return;
	}

	/* if row == -1 then read palette */
	/* looks like it starts at src+16? */

	if(row==-1) {
		if (debug) {
			fprintf(stderr,"Copying palette\n");
		}

		memcpy(dest,src+16,hdr.colors*3);
		if (debug) {
			fprintf(stderr,"0=%d,%d,%d 1=%d,%d,%d\n",
				dest[0],dest[1],dest[2],
				dest[3],dest[4],dest[5]);
		}
		return;
	}

	/* return early if requested row more than height */
	if(row>=hdr.height) return;

	/* skip the header / palette */
	src+=hdr.add*16;

	/* navigate to the proper row */
	while(row) {
		if (debug) printf("row: %d srcadd: %x src: %p\n",row,*(int16_t *)src,src);

		/* grab two bytes to next row, and add it in */
		/* note: probably not endian safe */
		src+=*(int16_t *)src;

		/* need to add two more to skip the address */
		src+=2;
		if (debug) printf("row: %d src: %p\n",row,src);
		row--;
	}

	/* get count of bytes in line */
	bytes=*(int16_t *)src;

	/* skip to the actual source */
	src+=2;

	uint8_t ah,al;
	int src_ptr=0,dest_ptr=0;

//		push	si			// save si
//		push	ds			// save ds
//		push	di			// save di
//		push	es			// save es
//		mov	cx,bytes		// put byte count into cx
//		lds	si,src			// load ds:si with src
//		add	cx,si			// cx points to end?
//		les	di,dest			// load es:di with dest
	l1:

		if (dest_ptr<0) {
			fprintf(stderr,"URGHURGH\n");
			exit(1);
		}

		if (dest_ptr>640) {
			fprintf(stderr,"URGHURGH2 %d\n",dest_ptr);
			exit(1);
		}

		al=src[src_ptr];		// mov	al,ds:[si]
		src_ptr++;			// inc	si

//		or	al,al			// set flags
		if (!(al&0x80)) goto l2;		// jns	l2
						//   jump if not sign (not neg)
						// if positive goto l2
		ah=al;				// mov	ah,al
		ah=ah&0x7f;			// clear sign
						// and	ah,7fh
		al=src[src_ptr];		// mov	al,ds:[si]
		src_ptr++;			// inc	si
	l4:
		dest[dest_ptr]=al;		// mov	es:[di],al
		dest_ptr++;			// inc	di
		ah--;				// dec	ah
		if (ah!=0) goto l4;		// jnz	l4
		if (src_ptr<bytes) goto l1;	// cmp	si,cx
						// jb	l1 (jump if below)
		goto l3;			// jmp	l3
	l2:
		dest[dest_ptr]=al;		// mov	es:[di],al
		dest_ptr++;			// inc	di
		if (src_ptr<bytes) goto l1;
						// cmp	si,cx
						// jb	l1

	l3:
//		pop	es
//		pop	di
//		pop	ds
//		pop	si

}
