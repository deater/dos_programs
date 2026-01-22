/* Grabs part of 320x200 8-bit PNG file with correct palette */
/* Makes "sprites" suitable for CGA */

#define VERSION "0.0.1"

#include <stdio.h>	/* For FILE I/O */
#include <string.h>	/* For strncmp */
#include <fcntl.h>	/* for open()  */
#include <unistd.h>	/* for lseek() */
#include <sys/stat.h>	/* for file modes */
#include <stdlib.h>	/* free() */

#include <png.h>

#define OUTPUT_C	0
#define OUTPUT_ASM	1
#define OUTPUT_RAW	2
#define OUTPUT_PASCAL	3

static unsigned char cga_ram[16384];
static int which_pal=0;
static int output_type=OUTPUT_PASCAL;

static int debug=0;


int lookup_color(int r,int g,int b) {

	int color=0,rgb;

	rgb=(r<<16)|(g<<8)|b;

	if (debug) printf("Looking for color %d,%d,%d\n", r,g,b);

	switch(rgb) {
		case 0x000000:	color=0; break;		/* black */

		/* palette 0 low intensity */
		case 0x00aa00:	color=1; break;		/* green */
		case 0xaa0000:	color=2; break;		/* red */
		case 0xaa5500:	color=3; break;		/* brown */

		/* palette 0 high intensity */
		case 0x55ff55:	color=1; break;		/* bright green */
		case 0xff5555:	color=2; break;		/* bright red */
		case 0xffff55:	color=3; break;		/* yellow */

		/* palette 1 low intensity */
		case 0x00aaaa:	color=1; break;		/* cyan */
		case 0xaa00aa:	color=2; break;		/* magenta */
		case 0xaaaaaa:	color=3; break;		/* light grey */

		/* palette 1 high intensity */
		case 0x55ffff:	color=1; break;		/* bright cyan */
		case 0xff55ff:	color=2; break;		/* bright magenta */
		case 0xffffff:	color=3; break;		/* white */

		/* mode 5 low intensity */
//		case 0x00aaaa:	color=1; break;		/* cyan */
//		case 0xaa0000:	color=2; break;		/* red */
//		case 0xaaaaaa:	color=3; break;		/* light grey */

		/* mode 5 high intensity */
//		case 0x55ffff:	color=1; break;		/* bright cyan */
//		case 0xff5555:	color=2; break;		/* bright red */
//		case 0xffffff:	color=3; break;		/* white */

	}

	return color;
}




/* expects a 320x200 PNG */
int loadpng(char *filename,
		unsigned char **image_ptr, int *xsize, int *ysize) {

	int x,y;
	int color;
	FILE *infile;
	unsigned char *image,*out_ptr;
	int width, height;

	png_byte bit_depth;
	png_structp png_ptr;
	png_infop info_ptr;
	png_bytep *row_pointers;
	png_byte color_type;
	int row_bytes,bytes_per_pixel;

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
	*xsize=width;
	*ysize=height;

	color_type = png_get_color_type(png_ptr, info_ptr);
	bit_depth = png_get_bit_depth(png_ptr, info_ptr);

	if (width!=320) {
		fprintf(stderr,"Unknown width %d\n",width);
		return -1;
	}

	if (height!=200) {
		fprintf(stderr,"Unknown height %d\n",height);
		return -1;
	}

	image=calloc(width*height,sizeof(unsigned char));
	if (image==NULL) {
		fprintf(stderr,"Error allocating image\n");
		return -1;
	}

	if (debug) {
		fprintf(stderr,"PNG: width=%d height=%d depth=%d\n",
				width,height,bit_depth);
		if (color_type==PNG_COLOR_TYPE_RGB) {
			fprintf(stderr,"Type RGB\n");
		}
		else if (color_type==PNG_COLOR_TYPE_RGB_ALPHA) {
			fprintf(stderr,"Type RGBA\n");
		}
		else if (color_type==PNG_COLOR_TYPE_PALETTE) {
			fprintf(stderr,"Type palette\n");
		}
	}

	/* If palette, expand to RGB automatically */
	if (color_type == PNG_COLOR_TYPE_PALETTE) {
		png_set_expand(png_ptr);
	}

	png_read_update_info(png_ptr, info_ptr);


	row_bytes = png_get_rowbytes(png_ptr, info_ptr);
	// *pChannels = (int)png_get_channels(png_ptr, info_ptr);
	bytes_per_pixel=row_bytes/width;

	if (debug) {
		fprintf(stderr,"Rowbytes=%d bytes per pixel=%d\n",
				row_bytes,row_bytes/width);
	}

	row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
	for (y=0; y<height; y++) {
		row_pointers[y] = (png_byte*)malloc(row_bytes);
	}

	png_read_image(png_ptr, row_pointers);

	png_read_end(png_ptr, NULL);

	fclose(infile);

	out_ptr=image;

	for(y=0;y<height;y++) {
		for(x=0;x<width;x++) {

			color=lookup_color(
				row_pointers[y][x*bytes_per_pixel],
				row_pointers[y][x*bytes_per_pixel+1],
				row_pointers[y][x*bytes_per_pixel+2]);

			*out_ptr=color;
			out_ptr++;
		}
	}

	*image_ptr=image;

	return 0;
}







/* Converts a PNG to RAW 8K Hires Image */


static void print_help(char *name,int version) {

	printf("\n%s version %s\n",VERSION,name);

	if (version) exit(1);

	printf("\nUsage: %s [-h] [-v] [-d] [-s] [-l label] PNGFILE x1 y1 x2 y2\n\n",name);
	printf("\t[-d] debug\n");
	printf("\t[-h] help\n");
	printf("\t[-b] version\n");
	printf("\t[-s] emit size of sprite before the data\n");
	printf("\t[-l label] for the sprite\n");
	printf("\n");

	exit(1);
}

static int hgr_offset_table[48]={
	0x0000,0x0080,0x0100,0x0180,0x0200,0x0280,0x0300,0x0380,
	0x0028,0x00A8,0x0128,0x01A8,0x0228,0x02A8,0x0328,0x03A8,
	0x0050,0x00D0,0x0150,0x01D0,0x0250,0x02D0,0x0350,0x03D0,
};

static int hgr_offset(int y) {

	int temp,temp2,address;
	temp=y/8;
	temp2=y%8;

	temp2=temp2*0x400;

	address=hgr_offset_table[temp]+temp2;

	return address;
}


int main(int argc, char **argv) {

	int xsize=0,ysize=0;
	int printsize=0,mask_offset=0,total_bytes=0;
	int c,x,y;
	unsigned char *image;
	char label_string[BUFSIZ];

	int x1,y1,x2,y2;

	int xs;

	char *filename;

	strncpy(label_string,"sprite",BUFSIZ);

	/* Parse command line arguments */

	while ( (c=getopt(argc, argv, "hvdmsl:") ) != -1) {

		switch(c) {

                        case 'h':
                                print_help(argv[0],0);
				break;
                        case 'v':
                                print_help(argv[0],1);
				break;
			case 'd':
				debug=1;
				break;
			case 's':
				printsize=1;
				break;
			case 'm':
				mask_offset=1;
				break;
			case 'l':
				strncpy(label_string,optarg,BUFSIZ-1);
				break;
			default:
				print_help(argv[0],0);
				break;
		}
	}

	if (argc-optind<5) {
		printf("ERROR: Was expecting filename and co-ords!\n");
		//printf("\targc=%d optind=%d\n",argc,optind);
		exit(1);
	}

	filename=strdup(argv[optind]);

	x1=atoi(argv[optind+1]);
	y1=atoi(argv[optind+2]);
	x2=atoi(argv[optind+3]);
	y2=atoi(argv[optind+4]);

	memset(cga_ram,0,16384);

	if (loadpng(filename,&image,&xsize,&ysize)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	fprintf(stderr,"Loaded image %d by %d\n",xsize,ysize);

	int c1,c2,c3,c4,color;

	/* 2 bits-per-pixel for color */
	/* even rows start at offset 0, odd rows at offset 8192 */

	for(y=0;y<200;y++) {
		for(x=0;x<320/4;x++) {
			c1=image[(y*320)+(x*4)+0];
			c2=image[(y*320)+(x*4)+1];
			c3=image[(y*320)+(x*4)+2];
			c4=image[(y*320)+(x*4)+3];
                        color=(c1<<6)|(c2<<4)|(c3<<2)|c4;
			cga_ram[(0x2000*(y&1))+((y/2)*80)+x]=color;
		}
	}

	fprintf(stderr,"Loaded image %d by %d, Palette %d\n",
		xsize,ysize,which_pal);





	if (x1%7) {
		fprintf(stderr,"Warning!  x1 should be a multiple of 7\n");
	}

	xs=(x2/7-x1/7);
	if (!((x2%7==0)&&(x1%7==0))) xs++;

	total_bytes=(xs*(y2-y1));
//	if (printsize) total_bytes+=2;
//	if (mask_offset) total_bytes+=2;

	printf("; %d %d %d %d\n",x1,y1,x2,y2);
	printf("; total bytes: %d\n",total_bytes);
	printf("%s:\n",label_string);


	if (printsize) {

		printf("\t.byte $%02X,$%02X\n",
				xs,y2-y1);
	}

	if (mask_offset) {
		printf("\t.byte $%02X,$%02X\n",
				total_bytes&0xff,
				total_bytes>>8);
	}

	for(y=y1;y<y2;y++) {
		printf("\t.byte ");
		for(x=x1/7;x<=x2/7;x++) {
			printf("$%02X",cga_ram[hgr_offset(y)+x]);
			if (x!=x2/7) printf(",");
		}
		printf("\n");
	}

	return 0;
}
