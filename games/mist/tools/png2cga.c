#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "loadpng.h"

/* Converts an Apple II Lores PNG to a CGA file */
/* this creates two files, one that is attributes and one that is data */
/* for our purposes the entire data is going to be char 220 */

static int color_map[16]={
		/* apple 2		CGA */
	0,	/* 0 BLACK	->	0 Black */
	4,	/* 1 RED	->	4 Red */
	1,	/* 2 D BLUE	->	1 D Blue */
	5,	/* 3 PURPLE	->	5 Purple */
	2,	/* 4 D GREEN	->	2 D Green */
	8,	/* 5 GREY1	->	8 D Grey */
	3,	/* 6 M Blue	->	3 Cyan */
	7,	/* 7 L Blue	->	7 Grey */
	6,	/* 8 Brown	->	6 Brown */
	12,	/* 9 Orange	->	12 L Red */
	8,	/* 10 Grey2 (transparent)	*/
	13,	/* 11 Pink	->	13 Pink */
	10,	/* 12 L. Green	->	10 L Green */
	14,	/* 13 Yellow	-> 	14 Yellow */
	11,	/* 14 Aqua	->	11 L Cyan */
	15,	/* 15 White	->	15 White */
};

int main(int argc, char **argv) {

	int row=0;
	int col=0;
	int x,i;
	unsigned char out_buffer[80*25];
	int top_color,bottom_color,color;

	unsigned char *image;
	int xsize,ysize;
	FILE *outattr,*outdata;

	char attr_filename[256];
	char data_filename[256];

	if (argc<3) {
		fprintf(stderr,"Usage:\t%s INFILE OUTBASE\n\n",argv[0]);
		exit(-1);
	}

	sprintf(attr_filename,"%s.attr",argv[2]);
	sprintf(data_filename,"%s.data",argv[2]);

	outdata=fopen(data_filename,"w");
	if (outdata==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",data_filename);
		exit(-1);
	}

	/* all 220 */
	for(i=0;i<80*25;i++) {
		fputc(220,outdata);
	}

	fclose(outdata);


	outattr=fopen(attr_filename,"w");
	if (outattr==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",attr_filename);
		exit(-1);
	}

	if (loadpng(argv[1],&image,&xsize,&ysize,PNG_WHOLETHING)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	fprintf(stderr,"Loaded image %d by %d\n",xsize,ysize);

	memset(out_buffer,0,80*25);

	for(row=0;row<24;row++) {
		for(col=0;col<40;col++) {
			top_color=color_map[(image[row*xsize+col])&0xf];
			bottom_color=color_map[(image[row*xsize+col])>>4];
			color=(top_color<<4)|bottom_color;

			/* 40 -> 80, two consecutive */
			out_buffer[(row*80)+(col*2)]=color;
			out_buffer[(row*80)+(col*2)+1]=color;
		}
	}

	for(x=0;x<80*25;x++) fputc( out_buffer[x],outattr);

	fclose(outattr);

	return 0;
}
