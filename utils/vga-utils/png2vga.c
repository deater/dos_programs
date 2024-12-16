/* Converts 320x200 256-color PNG file to mode13h */

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

static unsigned char vga_ram[65536];
static struct vga_palette vga_pal[256];
static int num_colors=0;

static int debug=0;

#define OUTPUT_C	0
#define OUTPUT_ASM	1
#define OUTPUT_RAW	2
#define OUTPUT_PASCAL	3


int lookup_color(int r,int g,int b) {
	int i;

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

	printf("\npng2hgr version %s\n",VERSION);

	if (version) exit(1);

	printf("\nUsage: %s [-r] [-s] PNGFILE\n\n",name);
	printf("\t[-r] raw, don't prepend with BLOAD addr/size\n");
	printf("\t[-s] short, leave off bottom text area\n");
	printf("\n");

	exit(1);
}




int main(int argc, char **argv) {

	int xsize=0,ysize=0;
	int c,x;
	unsigned char *image;
	char *filename;

	/* Parse command line arguments */

	while ( (c=getopt(argc, argv, "hvd") ) != -1) {

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

	memset(vga_ram,0,65536);
	memset(vga_pal,0,256*sizeof(struct vga_palette));


	if (loadpng(filename,&image,&xsize,&ysize)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	memcpy(vga_ram,image,320*200);

	fprintf(stderr,"Loaded image %d by %d, %d colors\n",
		xsize,ysize,num_colors);

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
