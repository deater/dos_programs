/* Converts 320x400 256-color PNG to the UP format used by second reality */

#define VERSION "0.0.1"

#include <stdio.h>	/* For FILE I/O */
#include <string.h>	/* For strncmp */
#include <fcntl.h>	/* for open()  */
#include <unistd.h>	/* for lseek() */
#include <sys/stat.h>	/* for file modes */
#include <stdlib.h>	/* free() */

#include <png.h>

struct vga_palette {
	unsigned char r;
	unsigned char g;
	unsigned char b;
};

static unsigned char vga_ram[65536*4];	// unchained mode, 4 planes
static struct vga_palette vga_pal[256];
static int num_colors=0;
static int six_bit_palette=0;

static int debug=0;

#define OUTPUT_C	0
#define OUTPUT_ASM	1
#define OUTPUT_RAW	2
#define OUTPUT_PASCAL	3


/* on disk format */
/*	assumes little-endian */

/* 10 bytes in size */
struct st_readp {
	int16_t magic;		// 0xfcfd
	int16_t width;		// 0x0140 = 320
	int16_t height;		// 0x0190 = 400
	int16_t colors;		// 0x0100 = 256
	int16_t add;		// 0x0031 = 49?
};

#define HEADER_SIZE	16

int write_up(unsigned char *image,int xsize, int ysize) {

	int i;
	int colors=256;		/* hard coded? */
	struct st_readp header;
	unsigned char raw_header[HEADER_SIZE];
	unsigned char pal_entry[3];

	/* write header */

	memset(raw_header,0,HEADER_SIZE);

	header.magic=0xfcfd;
	header.width=xsize;
	header.height=ysize;
	header.colors=256;
	header.add=49;

	raw_header[0]=header.magic&0xff;
	raw_header[1]=(header.magic>>8)&0xff;
	raw_header[2]=header.width&0xff;
	raw_header[3]=(header.width>>8)&0xff;
	raw_header[4]=header.height&0xff;
	raw_header[5]=(header.height>>8)&0xff;
	raw_header[6]=header.colors&0xff;
	raw_header[7]=(header.colors>>8)&0xff;
	raw_header[8]=header.add&0xff;
	raw_header[9]=(header.add>>8)&0xff;

	fwrite(raw_header,HEADER_SIZE,1,stdout);

	/* write palette */

	for(i=0;i<colors;i++) {
		/* VGA has 6-bit rather than 8-bit colors */
		pal_entry[0]=vga_pal[i].r>>2;
		pal_entry[1]=vga_pal[i].g>>2;
		pal_entry[2]=vga_pal[i].b>>2;
		fwrite(pal_entry,3,1,stdout);
	}

	return 0;
}


#if 0
static int write_raw(unsigned char *image,int xsize, int ysize) {

	int x;

	/* dump palette r */
	printf("unsigned char pal_r[256]={\n");
	for(x=0;x<256;x++) {
		if (x%8==0) printf("\t");
		printf("0x%02X,",vga_pal[x].r);
		if (x%8==7) printf("\n");
	}
	printf("};\n");

	/* dump palette g */
	printf("unsigned char pal_g[256]={\n");
	for(x=0;x<256;x++) {
		if (x%8==0) printf("\t");
		printf("0x%02X,",vga_pal[x].g);
		if (x%8==7) printf("\n");
	}
	printf("};\n");

	/* dump palette b */
	printf("unsigned char pal_b[256]={\n");
	for(x=0;x<256;x++) {
		if (x%8==0) printf("\t");
		printf("0x%02X,",vga_pal[x].b);
		if (x%8==7) printf("\n");
	}
	printf("};\n");

	/* dump image */

	printf("unsigned char image[65536]={\n");
	for(x=0;x<65536;x++) {
		if (x%8==0) printf("\t");
		printf("0x%02X,",vga_ram[x]);
		if (x%8==7) printf("\n");
	}
	printf("};\n");

	return 0;
}
#endif


static int read_palette(png_structp png_ptr,
			png_infop info_ptr) {

	int num_palette,i;
	png_colorp palette;

	png_get_PLTE(png_ptr, info_ptr,
		&palette,&num_palette);

	fprintf(stderr,"Found %d colors in palette\n",num_palette);

	num_colors=256;

	for(i=0;i<num_palette;i++) {
//		fprintf(stderr,"%d: %x %x %x\n",i,
//			palette[i].red,palette[i].green,palette[i].blue);

		vga_pal[i].r=palette[i].red;
		vga_pal[i].g=palette[i].green;
		vga_pal[i].b=palette[i].blue;

	}

	return 0;
}

static int lookup_color(int raw_r,int raw_g,int raw_b) {

	int i,r,g,b;

	if (six_bit_palette) {
		r=raw_r>>2;
		g=raw_g>>2;
		b=raw_b>>2;
	}
	else {
		r=raw_r;
		g=raw_g;
		b=raw_b;
	}

	if (debug) printf("Looking for color %d,%d,%d (in set of %d)\n",
		r,g,b,num_colors);

	for(i=0;i<num_colors;i++) {
		if (debug) printf("\tdoes it match color %d (%d, %d, %d)\n",
			i,vga_pal[i].r,vga_pal[i].g,vga_pal[i].b);

		if ((vga_pal[i].r==r) &&
			(vga_pal[i].g==g) &&
			(vga_pal[i].b==b)) {
			if (debug) {
				printf("\tFound color %d\n",i);
			}

			return i;
		}
	}

	if (num_colors==256) {
		fprintf(stderr,"ERROR! Too many colors!\n");
		return 0;
	}

	/* not found */

	vga_pal[num_colors].r=r;
	vga_pal[num_colors].g=g;
	vga_pal[num_colors].b=b;

	if (debug) printf("\tnot found, allocating color %d (%d, %d, %d)\n",
		num_colors,r,g,b);

	num_colors++;
	return num_colors-1;
}

/* expects a 320x400 PNG */
static int loadpng(char *filename,
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

	if (height!=400) {
		fprintf(stderr,"Unknown height %d\n",height);
		return -1;
	}

	image=calloc(width*height,sizeof(unsigned char));
	if (image==NULL) {
		fprintf(stderr,"Error allocating image\n");
		return -1;
	}

	if (1) {
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

			read_palette(png_ptr,info_ptr);
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






static void print_help(char *name,int version) {

	printf("\npng2up version %s\n",VERSION);

	if (version) exit(1);

	printf("\nUsage: %s [-v] [-h] [-w] PNGFILE\n\n",name);
	printf("\t[-w] write out 8-bit palette instead of 6-bit\n");
	printf("\n");

	exit(1);
}




int main(int argc, char **argv) {

	int xsize=0,ysize=0;
	int c;
	unsigned char *image;
	char *filename;

	/* Parse command line arguments */

	while ( (c=getopt(argc, argv, "hvdw") ) != -1) {

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
			case 'w':
				six_bit_palette=0;
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

	memset(vga_ram,0,65536*4);
	memset(vga_pal,0,256*sizeof(struct vga_palette));


	if (loadpng(filename,&image,&xsize,&ysize)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	fprintf(stderr,"Loaded image %d by %d, %d colors\n",
		xsize,ysize,num_colors);

	write_up(image,xsize,ysize);

	return 0;
}
