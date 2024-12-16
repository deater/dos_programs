/* Converts 140x192 8-bit PCX file with correct palette to Apple II HGR */

#define VERSION "0.0.1"

#include <stdio.h>	/* For FILE I/O */
#include <string.h>	/* For strncmp */
#include <fcntl.h>	/* for open()  */
#include <unistd.h>	/* for lseek() */
#include <sys/stat.h>	/* for file modes */
#include <stdlib.h>	/* free() */

#define PCX_UNKNOWN	0
#define PCX_8BIT	1
#define PCX_24BIT	2

/* If you want default black a different color try the below */
/* Useful if you are trying to xdraw to get red/blue */
#if 0
/* Default is BLACK0 */
#define DEFAULT_BLACK	-1
#else
/* DEFAULT is BLACK1 */
#define DEFAULT_BLACK	1
#endif

static int debug=0;

static int vmwGetPCXInfo(char *filename, int *xsize, int *ysize, int *type) {

	unsigned char pcx_header[128];
	int xmin,ymin,xmax,ymax,version=PCX_UNKNOWN,bpp,pcx_fd;
	int result;

	/* Open the file */
	pcx_fd=open(filename,O_RDONLY);

	if (pcx_fd<0) {
		fprintf(stderr,"ERROR!  File \"%s\" not found!\n",filename);
		return -1;
	}

	lseek(pcx_fd,0,SEEK_SET);

	result=read(pcx_fd,&pcx_header,128);
	if (result<0) {
		fprintf(stderr,"Error!  Could not read header from file %s\n",filename);
		return -1;
	}

	xmin=(pcx_header[5]<<8)+pcx_header[4];
	ymin=(pcx_header[7]<<8)+pcx_header[6];

	xmax=(pcx_header[9]<<8)+pcx_header[8];
	ymax=(pcx_header[11]<<8)+pcx_header[10];

	version=pcx_header[1];
	bpp=pcx_header[3];

	if (debug) {
		printf("Manufacturer: ");
		if (pcx_header[0]==10) printf("Zsoft\n");
		else printf("Unknown %i\n",pcx_header[0]);

		printf("Version: ");
		switch(version) {
			case 0: printf("2.5\n"); break;
			case 2: printf("2.8 w palette\n"); break;
			case 3: printf("2.8 w/o palette\n"); break;
			case 4: printf("Paintbrush for Windows\n"); break;
			case 5: printf("3.0+\n"); break;
			default: printf("Unknown %i\n",version);
		}
		printf("Encoding: ");
		if (pcx_header[2]==1) printf("RLE\n");
		else printf("Unknown %i\n",pcx_header[2]);

		printf("BitsPerPixelPerPlane: %i\n",bpp);
		printf("File goes from %i,%i to %i,%i\n",xmin,ymin,xmax,ymax);

		printf("Horizontal DPI: %i\n",(pcx_header[13]<<8)+pcx_header[12]);
		printf("Vertical   DPI: %i\n",(pcx_header[15]<<8)+pcx_header[14]);

		printf("Number of colored planes: %i\n",pcx_header[65]);
		printf("Bytes per line: %i\n",(pcx_header[67]<<8)+pcx_header[66]);
		printf("Palette Type: %i\n",(pcx_header[69]<<8)+pcx_header[68]);
		printf("Hscreen Size: %i\n",(pcx_header[71]<<8)+pcx_header[70]);
		printf("Vscreen Size: %i\n",(pcx_header[73]<<8)+pcx_header[72]);

	}

	*xsize=(xmax-xmin+1);
	*ysize=(ymax-ymin+1);

	if ((version==5) && (bpp==8) && (pcx_header[65]==3)) *type=PCX_24BIT;
	else if (version==5) *type=PCX_8BIT;
	else *type=PCX_UNKNOWN;

	close(pcx_fd);

	return 0;
}

static unsigned char colors[256];

static int vmwLoadPCX(char *filename, unsigned char *framebuffer)  {

	int pcx_fd;
	int x,i,numacross,xsize,ysize,xmin,ymin;
	unsigned int r,g,b;
	int xmax,ymax;
	unsigned char pcx_header[128];
	unsigned char temp_byte;
	int result;
	unsigned char *pointer=framebuffer;

	/* Open the file */
	pcx_fd=open(filename,O_RDONLY);

	if (pcx_fd<0) {
		fprintf(stderr,"ERROR!  File \"%s\" not found!\n",filename);
		return -1;
	}

	/*************** DECODE THE HEADER *************************/
	result=read(pcx_fd,&pcx_header,128);
	if (result<0) {
		fprintf(stderr,"ERROR opening header of file %s\n",filename);
	}

	xmin=(pcx_header[5]<<8)+pcx_header[4];
	ymin=(pcx_header[7]<<8)+pcx_header[6];

	xmax=(pcx_header[9]<<8)+pcx_header[8];
	ymax=(pcx_header[11]<<8)+pcx_header[10];

	xsize=((xmax-xmin)+1);
	ysize=((ymax-ymin)+1);

	x=0;

	while (x<xsize*ysize) {

		/* read a byte */
		result=read(pcx_fd,&temp_byte,1);

		/* if > 0xc0, then it's a RLE byte */
		if (0xc0 == (temp_byte&0xc0)) {
			numacross=temp_byte&0x3f;
			result=read(pcx_fd,&temp_byte,1);
			for(i=0;i<numacross;i++) {
				*pointer=temp_byte;
				pointer++;
				x++;
			}
		}
		else {
			*pointer=temp_byte;
			pointer++;
			x++;
		}
	}

	/*Load Palette*/

	result=lseek(pcx_fd,-769,SEEK_END);

	result=read(pcx_fd,&temp_byte,1);
	if (temp_byte!=12) {
		fprintf(stderr,"Error!  No palette found!\n");
		return -1;
	}

	for(i=0;i<255;i++) {
		result=read(pcx_fd,&temp_byte,1);
		r=temp_byte;
		result=read(pcx_fd,&temp_byte,1);
		g=temp_byte;
		result=read(pcx_fd,&temp_byte,1);
		b=temp_byte;

#if 0
	int colors[8]={	0, /* black 0 */
			1, /* purple  */
			2, /* green   */
			3, /* white 0 */
			0, /* black 1 */
			1, /* blue */
			2, /* orange */
			3, /* white */
	};
#endif

		if ((r==0x00) && (g==0x00) && (b==0x00)) colors[i]=0; /* black */
		else
		if ((r==0xff) && (g==0xff) && (b==0xff)) colors[i]=3; /* white */
		else
		if ((r==0x1b) && (g==0x9a) && (b==0xfe)) colors[i]=0x81; /* blue */
		else
		if ((r==0xe4) && (g==0x34) && (b==0xfe)) colors[i]=0x41; /* purple */
		else
		if ((r==0xcd) && (g==0x5b) && (b==0x1)) colors[i]=0x82; /* orange */
		else
		if ((r==0x1b) && (g==0xcb) && (b==0x1)) colors[i]=0x42; /* green */
		else fprintf(stderr,"Unknown color %i %x %x %x\n",i,r,g,b);

//		printf("%i: 0x%x %x %x\n",i,r,g,b);

	}

	close(pcx_fd);

	return 0;
}




static int make_bw_image(unsigned char *in_framebuffer,
				unsigned char *out_framebuffer,
				int xsize, int ysize) {

	short fourteen_bits;

	int i,yoffset=0;
	int y,x;
	unsigned char byte1,byte2;

	int page,block,leaf;

	unsigned char *pcx,*hgr;

	pcx=in_framebuffer;
	hgr=out_framebuffer;

	for(y=0;y<ysize;y++) {
		for(x=0;x<20;x++) {

			fourteen_bits=0;

			for(i=0;i<14;i++) {
				fourteen_bits|= ((colors[(*pcx)&0x7]&0x1)<<i);
				pcx++;
			}
			byte1=(fourteen_bits&0x7f)|(0<<7);
			byte2=((fourteen_bits>>7)&0x7f)|(0<<7);

			page=(y%8);
			block=((y/8)%8);
			leaf=(y/64);

			yoffset=(page*1024) + (block*128) + (leaf*40);

//			printf("%d %d = %x %x %x\n",x,y,fourteen_bits,yoffset,
//				yoffset+(x*2));

			hgr=out_framebuffer+yoffset+(x*2);

			*hgr=byte1;
			*(hgr+1)=byte2;
		}
	}
	return 0;
}

static int make_color_image(unsigned char *in_framebuffer,
				unsigned char *out_framebuffer,
				int xsize, int ysize) {

	short fourteen_bits;

	int i,pal[2],yoffset=0;
	int y,x;
	unsigned char byte1,byte2;

	int page,block,leaf;
	unsigned char *pcx,*hgr;

#if 0
	unsigned char *pointer=in_framebuffer;

	for(y=0;y<ysize;y++) {
		for(x=0;x<xsize;x++) {
			printf("%1x",*pointer);
			pointer++;
		}
		printf("\n");
	}
#endif

	pcx=in_framebuffer;
	hgr=out_framebuffer;

	for(y=0;y<ysize;y++) {
		for(x=0;x<20;x++) {

			fourteen_bits=0;
			pal[0]=0; pal[1]=0;

			for(i=0;i<7;i++) {
				fourteen_bits|= ((colors[(*pcx)&0x7]&0x3)<<(i*2));

				/* choose which palette */
				/* can't have colors 1/2 in same run as 4/5 */
				/* If our graphic does, we vote for which to */
				/* Use based on which occurs more */

				/* if black or white, no change */
				/* if low, 1-0 = add 1 */
				/* if high, 0-1 = minus 1 */
				pal[i/4]+= (colors[*pcx]&0x80) -
						(colors[*pcx]&0x40);
				pcx++;
			}
			if (pal[0]==0) pal[0]=DEFAULT_BLACK;
			if (pal[1]==0) pal[1]=DEFAULT_BLACK;

			byte1=(fourteen_bits&0x7f)|((pal[0]>0)<<7);
			byte2=((fourteen_bits>>7)&0x7f)|((pal[1]>0)<<7);

			page=(y%8);
			block=((y/8)%8);
			leaf=(y/64);

			yoffset=(page*1024) + (block*128) + (leaf*40);

//			printf("%d %d = %x %x %x\n",x,y,fourteen_bits,yoffset,
//				yoffset+(x*2));

			hgr=out_framebuffer+yoffset+(x*2);

			*hgr=byte1;
			*(hgr+1)=byte2;
		}
	}
  	return 0;
}

static void print_help(char *name,int version) {

	printf("\npcx2hgr version %s\n",VERSION);

	if (version) exit(1);

	printf("\nUsage: %s [-r] [-s] PCXFILE\n\n",name);
	printf("\t[-r] raw, don't prepend with BLOAD addr/size\n");
	printf("\t[-s] short, leave off bottom text area\n");
	printf("\n");

	exit(1);
}


int main(int argc, char **argv) {

	int xsize=0,ysize=0,type;
	unsigned char *in_framebuffer;
	unsigned char *out_framebuffer;
	int raw=0;
	int c;

	char *filename;

	/* Parse command line arguments */

	while ( (c=getopt(argc, argv, "hvr") ) != -1) {

		switch(c) {

                        case 'h':
                                print_help(argv[0],0);
				break;
                        case 'v':
                                print_help(argv[0],1);
				break;
                        case 'r':
				raw=1;
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

	vmwGetPCXInfo(filename,&xsize,&ysize,&type);

	in_framebuffer=calloc(xsize*ysize,sizeof(unsigned char));
	if (in_framebuffer==NULL) {
		fprintf(stderr,"Error allocating memory!\n");
		return -1;
	}

	vmwLoadPCX(filename,in_framebuffer);

	out_framebuffer=calloc(8192,sizeof(unsigned char));
	if (out_framebuffer==NULL) {
		fprintf(stderr,"Error allocating memory!\n");
		return -1;
	}

	if ((ysize==160) || (ysize=192)) {
		/* HGR or HGR2 */
	}
	else {
		fprintf(stderr,"Warning, possibly truncating due to ysize: %d\n",ysize);
	}

	if (xsize==140) {
		make_color_image(in_framebuffer,out_framebuffer,xsize,ysize);
	}
	else if (xsize==280) {
		make_bw_image(in_framebuffer,out_framebuffer,xsize,ysize);
	}
	else {
		fprintf(stderr,"Error!  PCX file wrong xsize %d\n",xsize);
	}


	/* Last 8 bytes are ignored anyway; by not saving them we can fit */
	/* in 33 disk sectors rather than 34				  */
	int file_size=8184;

	if (!raw) {
		unsigned char header[4];

		/* assume HGR page 1 */
		int offset=8192;

		header[0]=offset&0xff;
		header[1]=(offset>>8)&0xff;
		header[2]=file_size&0xff;
		header[3]=(file_size>>8)&0xff;

		fwrite(header,sizeof(unsigned char),4,stdout);
	}

	/* Don't need the last 8 bytes; makes it fit in one fewer disk sectors */
	fwrite(out_framebuffer,sizeof(unsigned char),file_size,stdout);

	free(out_framebuffer);
	free(in_framebuffer);

	return 0;

}
