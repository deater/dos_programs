/* png2priority */

/* takes png file and generates the 80x200 priority file */
/* for use in the Peasant's Quest game */


#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#define PNG_WHOLETHING	0
#define PNG_ODDLINES	1
#define PNG_EVENLINES	2
#define PNG_RAW		3
#define PNG_NO_ADJUST	4

int loadpng(char *filename, unsigned char **image_ptr, int *xsize, int *ysize,
	int png_type);


/* Loads a 80x48 (or 40x48) PNG image into a 40x48 Apple II layout */
/* Also supports 320x200 for CGA*/
/* It's not interleaved like an actual Apple II */
/* But the top/bottom are pre-packed into a naive 40x24 array */

/* Note there's a hack to treat color 17 (0xf5ff00) as an alias for color 10 */
/*	for transparency reasons */

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include <png.h>

static int convert_color(int color, char *filename) {

	int c=0;

	switch(color) {
		case 0x000000:	c=0; break;	/* black */
		case 0xe31e60:	c=1; break;	/* magenta */
		case 0x604ebd:	c=2; break;	/* dark blue */
		case 0xff44fd:	c=3; break;	/* purple */
		case 0x00a360:	c=4; break;	/* dark green */
		case 0x9c9c9c:	c=5; break;	/* grey 1 */
		case 0x14cffd:	c=6; break;	/* medium blue */
		case 0xd0c3ff:	c=7; break;	/* light blue */
		case 0x607203:	c=8; break;	/* brown */
		case 0xff6a3c:	c=9; break;	/* orange */
		case 0x9d9d9d:	c=10; break;	/* grey 2 */
		case 0xffa0d0:	c=11; break;	/* pink */
		case 0x14f53c:	c=12; break;	/* bright green */
		case 0xd0dd8d:	c=13; break;	/* yellow */
		case 0x72ffd0:	c=14; break;	/* aqua */
		case 0xffffff:	c=15; break;	/* white */
		case 0xf5ff00:	c=10; break;	/* transparent */
		default:
			fprintf(stderr,"Unknown color %x, file %s\n",
				color,filename);
			return 16;
			break;
	}

	return c;
}

/* expects a PNG where the xsize is either 40 or 80 or 320 */
/* if it is 80, it skips every other */
/* if 320, it skips every 8 */

/* why do that?  when editing an image the aspect ratio looks better if */
/* it is an 80 wide picture */

/* xsize, ysize is the size of the result, not size of */
/* the input image */
int loadpng(char *filename, unsigned char **image_ptr, int *xsize, int *ysize,
	int png_type) {

	int x,y,ystart,yadd,xadd;
	int color;
	FILE *infile;
	int debug=0;
	unsigned char *image,*out_ptr;
	int width, height;
	int a2_color;

	png_byte bit_depth;
	png_structp png_ptr;
	png_infop info_ptr;
	png_bytep *row_pointers;
	png_byte color_type;

	unsigned char header[8];

        /* open file and test for it being a png */
        infile = fopen(filename, "rb");
        if (infile==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",filename);
		return -1;
	}

	/* Check the header */
        fread(header, 1, 8, infile);
        if (png_sig_cmp(header, 0, 8)) {
		fprintf(stderr,"Error!  %s is not a PNG file\n",filename);
		return -1;
	}

        /* initialize stuff */
        png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        if (!png_ptr) {
		fprintf(stderr,"Error create_read_struct\n");
		exit(-1);
	}

        info_ptr = png_create_info_struct(png_ptr);
        if (!info_ptr) {
		fprintf(stderr,"Error png_create_info_struct\n");
		exit(-1);
	}

	png_init_io(png_ptr, infile);
	png_set_sig_bytes(png_ptr, 8);

	png_read_info(png_ptr, info_ptr);

	width = png_get_image_width(png_ptr, info_ptr);
	height = png_get_image_height(png_ptr, info_ptr);

	/* get the xadd */
	if (width==80) {
		if (png_type==PNG_NO_ADJUST) {
			*xsize=80;
			xadd=1;
		}
		else {
			*xsize=40;
			xadd=2;
		}
		yadd=1;
	}
	else if (width==320) {
		*xsize=80;
		xadd=4;
		yadd=1;
	}
	else {
		fprintf(stderr,"Unsupported width %d\n",width);
		return -1;
	}

	if ((png_type==PNG_WHOLETHING) || (png_type==PNG_NO_ADJUST)) {
		*ysize=height;
		ystart=0;
		yadd*=1;
	}
	else {
		fprintf(stderr,"Unknown PNG type\n");
		return -1;
	}

	color_type = png_get_color_type(png_ptr, info_ptr);
	bit_depth = png_get_bit_depth(png_ptr, info_ptr);

//	if (debug) {
		printf("PNG: width=%d height=%d depth=%d\n",width,height,bit_depth);
		if (color_type==PNG_COLOR_TYPE_RGB) printf("Type RGB\n");
		else if (color_type==PNG_COLOR_TYPE_RGB_ALPHA) printf("Type RGBA\n");
		else if (color_type==PNG_COLOR_TYPE_PALETTE) printf("Type palette\n");
		printf("Generating output size %d x %d\n",*xsize,*ysize);
//	}

//        number_of_passes = png_set_interlace_handling(png_ptr);
	png_read_update_info(png_ptr, info_ptr);

	fprintf(stderr,"Rowbytes: %ld\n",png_get_rowbytes(png_ptr,info_ptr));

	row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
	for (y=0; y<height; y++) {
		/* FIXME: do we ever free these? */
		row_pointers[y] = (png_byte*)
			malloc(png_get_rowbytes(png_ptr,info_ptr));
	}

	png_read_image(png_ptr, row_pointers);

	fclose(infile);

	/* FIXME: this should be 40x24 max??? */
	image=calloc(width*height,sizeof(unsigned char));
	if (image==NULL) {
		fprintf(stderr,"Memory error!\n");
		return -1;
	}
	out_ptr=image;

	if (color_type==PNG_COLOR_TYPE_RGB_ALPHA) {
		if (debug) fprintf(stderr,"PNG_COLOR_TYPE_RGB_ALPHA\n");
		fprintf(stderr,"Width=%d, xadd=%d, yadd=%d\n",
				width,xadd,yadd);

		for(y=ystart;y<height;y+=yadd) {

			for(x=0;x<width;x+=xadd) {

				/* top color */
				color=	(row_pointers[y][x*4]<<16)+
					(row_pointers[y][x*4+1]<<8)+
					(row_pointers[y][x*4+2]);
				if (debug) {
					fprintf(stderr,"%x ",color);
				}

				a2_color=convert_color(color,filename);
				if (a2_color>15) {
					fprintf(stderr,
						"Unknown color at %d,%x\n",
						x,y);
				}

				*out_ptr=a2_color;
				out_ptr++;
			}
			if (debug) printf("\n");

		}

	}
	else if (color_type==PNG_COLOR_TYPE_PALETTE) {
		if (debug) {
			fprintf(stderr,"PNG_COLOR_TYPE_PALETTE\n");
			fprintf(stderr,"y: %d to %d step %d\n",ystart,height,yadd);
			fprintf(stderr,"x: %d to %d step %d\n",0,width,xadd);
		}
		for(y=ystart;y<height;y+=yadd) {
			for(x=0;x<width;x+=xadd) {

				if (bit_depth==8) {
					/* top color */
					a2_color=row_pointers[y][x];
					if (a2_color==16) {
						a2_color=10;
					}
					if (a2_color>16) {
						fprintf(stderr,"Error color %d\n",a2_color);
					}

					if (debug) {
						printf("%x",a2_color);
					}

					*out_ptr=a2_color;
					out_ptr++;
				}
				else if (bit_depth==4) {
					/* top color */
					a2_color=row_pointers[y][x/2];
					if (x%2==0) {
						a2_color=(a2_color>>4);
					}
					a2_color&=0xf;

					*out_ptr=a2_color;
					out_ptr++;

				}
			}
			if (debug) printf("\n");
		}
	}
	else if (color_type==PNG_COLOR_TYPE_RGB) {
		if (debug) fprintf(stderr,"PNG_COLOR_TYPE_RGB\n");
		fprintf(stderr,"Width=%d, xadd=%d, yadd=%d\n",
				width,xadd,yadd);

		for(y=ystart;y<height;y+=yadd) {
			for(x=0;x<width;x+=xadd) {

				/* top color */
				color=	(row_pointers[y][x*3]<<16)+
					(row_pointers[y][x*3+1]<<8)+
					(row_pointers[y][x*3+2]);
				if (debug) {
					printf("t (%d %d) 0x%x ",
						x,xadd,color);
				}

				a2_color=convert_color(color,filename);
				if (a2_color>15) {
					fprintf(stderr,
						"Unknown color at %d,%d\n",
						x,y);
				}

				/* bottom color */
				color=	(row_pointers[y+1][x*3]<<16)+
					(row_pointers[y+1][x*3+1]<<8)+
					(row_pointers[y+1][x*3+2]);
				if (debug) {
					printf("b0x%x ",color);
				}

				a2_color|=(convert_color(color,filename)<<4);

				*out_ptr=a2_color;
				out_ptr++;
			}
			if (debug) printf("\n");
		}
	}
	else {
		fprintf(stderr,"Unknown color type\n");
		exit(-1);
	}

	*image_ptr=image;

	return 0;
}



/* Converts a PNG to a GR file you can BLOAD to 0x400		*/
/* HOWEVER you *never* want to do this in real life		*/
/* as it will clobber important values in the memory holes	*/

int main(int argc, char **argv) {

	int row=0;
	int col=0;
//	int x;

	unsigned char *image;
	int xsize,ysize;
	FILE *outfile;

	if (argc<3) {
		fprintf(stderr,"Usage:\t%s PRIORITY OUTFILE\n\n",argv[0]);
		exit(-1);
	}

	outfile=fopen(argv[2],"w");
	if (outfile==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",argv[2]);
		exit(-1);
	}

	/*****************/
	/* load priority */
	if (loadpng(argv[1],&image,&xsize,&ysize,PNG_WHOLETHING)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	fprintf(stderr,"Loaded priority image %s, %d by %d\n",
		argv[2],xsize,ysize);

	int temp;
	for(row=0;row<200;row++) {
		for(col=0;col<80;col++) {
			temp=((image[(row*xsize)+col])&0xff);
			fputc( temp,outfile);
		}
	}

	fclose(outfile);

	return 0;
}
