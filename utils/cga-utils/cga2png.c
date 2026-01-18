/* Convert a 16k CGA image into a PNG file */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>

#include <png.h>

#define VERSION "0.0.1"

static int debug=1;

#define PALETTE_SPICY_CHIPOLTE	0
#define PALETTE_COOL_RANCH	1
/* FIXME: other variants with high/low intensity */
/* and also custom background colors */

#define PAL_LENGTH	4


static void print_help(char *name,int version) {

	printf("\npng2hgr version %s\n",VERSION);

	if (version) exit(1);

	printf("\nUsage: %s [-d] [-f] [-t] PNGFILE\n\n",name);
	printf("\t[-d] debug\n");
	printf("\t[-p X] use palette X (0=r/g/y, 1=c/p/w)\n");
        printf("\n");

        exit(1);
}



int main(int argc, char **argv) {

	int fd;
	char *filename,*output_filename;
	char screen[16384];
	FILE *output;
	int width=320,height=200,y,x;
	png_byte color_type=PNG_COLOR_TYPE_PALETTE;
	png_byte bit_depth=8;

	png_structp png_ptr;
	png_infop info_ptr;
//	int number_of_passes;
	png_bytep *row_pointers;
	png_colorp palette;
	png_color *col;

	int c,length;
	int which_palette=PALETTE_COOL_RANCH;

	/* Parse command line arguments */

	while ( (c=getopt(argc, argv, "hdp:") ) != -1) {

		switch(c) {
			case 'd':
				debug=1;
				break;
			case 'h':
				print_help(argv[0],0);
				break;
			case 'v':
				print_help(argv[0],1);
				break;
			case 'p':
				which_palette=strtod(optarg,NULL);
				break;
			default:
				print_help(argv[0],0);
				break;
		}
	}

	if (optind>=argc) {
		printf("ERROR: Was expecting filename!\n");
		exit(1);
	}

	filename=strdup(argv[optind]);

	if (optind+1>=argc) {
		length=strlen(argv[optind])+5;
		output_filename=calloc(length,1);
		strncpy(output_filename,argv[optind],length);
		strncat(output_filename,".png",5);
	}
	else {
		output_filename=strdup(argv[optind+1]);
	}

	fd=open(filename,O_RDONLY);
	if (fd<0) {
		printf("Error opening %s! %s\n",filename,strerror(errno));
		return -1;
	}
	read(fd,screen,16384);
	close(fd);


	output = fopen(output_filename, "wb");
	if (output==NULL) {
		printf("Error opening %s, %s\n",output_filename,strerror(errno));
		return -1;
	}

	/* initialize */
	png_ptr = png_create_write_struct(
			PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

        if (png_ptr==NULL) {
		fprintf(stderr,"Error!  png_create_write_struct() failed\n");
		return -1;
	}

        info_ptr = png_create_info_struct(png_ptr);
        if (info_ptr==NULL) {
		fprintf(stderr,"Error!  png_create_info_struct() failed\n");
		return -1;
	}

//	setjmp(png_jmpbuf(png_ptr));

	png_init_io(png_ptr, output);

        /* write header */
//	setjmp(png_jmpbuf(png_ptr));

	png_set_IHDR(png_ptr, info_ptr, width, height,
			bit_depth, color_type, PNG_INTERLACE_NONE,
			PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

//	png_write_info(png_ptr, info_ptr);

	/* set palette */
	palette = (png_colorp)png_malloc(png_ptr,
		PAL_LENGTH * (sizeof (png_color)));


	if (which_palette == PALETTE_COOL_RANCH) {
		/* 0: black 0 */
		col=&palette[0];
		col->red=0;
		col->green=0;
		col->blue=0;

		/* 1: cyan */
		col=&palette[1];
		col->red=0x55;
		col->green=0xff;
		col->blue=0xff;

		/* 2: magenta */
		col=&palette[2];
		col->red=0xff;
		col->green=0x55;
		col->blue=0xff;

		/* 3: white */
		col=&palette[3];
		col->red=0xff;
		col->green=0xff;
		col->blue=0xff;
	}
	else {
		/* 0: black 0 */
		col=&palette[0];
		col->red=0;
		col->green=0;
		col->blue=0;

		/* 1: green */
		col=&palette[1];
		col->red=0x55;
		col->green=0xff;
		col->blue=0x55;

		/* 2: red */
		col=&palette[2];
		col->red=0xff;
		col->green=0x55;
		col->blue=0x55;

		/* 3: yellow */
		col=&palette[3];
		col->red=0xff;
		col->green=0xff;
		col->blue=0x55;
	}

	/* ... Set palette colors ... */
	png_set_PLTE(png_ptr, info_ptr, palette, PAL_LENGTH);

	png_write_info(png_ptr, info_ptr);



	row_pointers = (png_bytep*)malloc(sizeof(png_bytep) * height);

	for(y=0;y<height;y++) {
		row_pointers[y]=malloc(width);
	}

	/*********************************************/
	/* do the actual conversion                  */
	/*********************************************/

	int color;

	for(y=0;y<height/2;y++) {

		for(x=0;x<80;x++) {
			/* even lines */
			color=screen[(y*80)+x];

			row_pointers[y*2][(x*4)+0]=(color>>6)&0x3;
			row_pointers[y*2][(x*4)+1]=(color>>4)&0x3;
			row_pointers[y*2][(x*4)+2]=(color>>2)&0x3;
			row_pointers[y*2][(x*4)+3]=(color>>0)&0x3;

			/* odd lines */
			color=screen[8192+(y*80)+x];

			row_pointers[(y*2)+1][(x*4)+0]=(color>>6)&0x3;
			row_pointers[(y*2)+1][(x*4)+1]=(color>>4)&0x3;
			row_pointers[(y*2)+1][(x*4)+2]=(color>>2)&0x3;
			row_pointers[(y*2)+1][(x*4)+3]=(color>>0)&0x3;

		}
	}

        png_write_image(png_ptr, row_pointers);


	png_write_end(png_ptr, NULL);

	/* cleanup heap allocation */
	for (y=0; y<height; y++) {
		free(row_pointers[y]);
	}
	free(row_pointers);

	fclose(output);

	return 0;
}
