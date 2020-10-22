/*-----------------------------------------------------------------------

 
 PCX code taken from the warp-ggi demo.
 
        PCX original code by some cow-orker i forgot :)
        Adapted and way optimized by Emmanuel Marty <emarty@mirus.fr>

	Released under GNU Public License
-----------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>

struct pcx_header {
	char       manufacturer;
	char       version;
	char       encoding;
	char       bits_per_pixel;
	unsigned short     xmin,ymin;
	unsigned short     xmax,ymax;
	unsigned short     hres;
	unsigned short     vres;

	char       palette16[48];
	char       reserved;
	char       color_planes;
	unsigned short     bytes_per_line;
	unsigned short     palette_type;
	char       filler [58];
};

int readPCX (char *name, char *FileName /*, struct raw_pict *rp*/ )
{
	FILE			*f;
	unsigned short		bytes;
	struct	pcx_header	header;
	unsigned int		i, j, c, err;
	unsigned int		width, height;
/*	ggi_color		*palette; */
	unsigned char			*fbuf, *lptr, *nextlptr, palbuf[4];
        char buffer[256];
        FILE *fff;
        unsigned int errorlev,xsize,ysize,numcolors,mask1,mask2;
	unsigned int q,y,numacross,second1,oldcol,x,col;
        unsigned int palette[256][3],x1,y1,bits_per_pixel,pixel_byte_size;
        unsigned char transparent_col[3],eight_bit_pal;
   
   err=0;
        
	if ( (f = fopen(name,"rb")) ) {
		fread ( (char*) &header, 1, sizeof (struct pcx_header), f);

		width  = header.xmax - header.xmin + 1;
		height = header.ymax - header.ymin + 1;
		bytes  = header.bytes_per_line;

		/*rp->width  = width;
		rp->height = height;
		rp->depth = 8;*/

		if ( (fbuf = (char *) malloc (width * height)) ) {
			/*rp->framebuf = (void *) fbuf;*/
			lptr = fbuf;

			for (i=0; i<height; ++i) {
				nextlptr = lptr + width;

				do {
					c = fgetc (f) & 0xFF;
					if ( (c & 0xC0) == 0xC0) {
						j = c & 0x3F;
						c = fgetc (f);
						while (j--)
							*lptr++ = c;
	    				}
	    				else *lptr++ = c;
	   			} while ( lptr < nextlptr);

				lptr = nextlptr;
	  		}

	  		if ( fgetc (f) == 12 ) {

					for (i = 0; i < 256; i++) {
						fread (palbuf, 1, 3, f);
						palette[i][0] = palbuf[0];
						palette[i][1] = palbuf[1];
						palette[i][2] = palbuf[2];
					}
				      
			}
				
			 
		
			/*else rp->clut = NULL;*/

			if (err) free (fbuf);
	 	}
		/*else err = RPREAD_NOMEM;*/
                
	 	fclose (f);
         	printf("width %i\nheight %i\n",width,height);
	   
/*SavePicSuperPacked(char *FileName, int x1, int y1, int width, int height
		     int eight_bit_pal, int bits_per_pixel, char *transparent_col
		     */
    x1=0; y1=0; eight_bit_pal=1; bits_per_pixel=8;	   
    transparent_col[0]=0xFF; transparent_col[1]=0xFF; transparent_col[2]=0xFF;
	   
    pixel_byte_size=bits_per_pixel/8;

    mask1=0xFF; mask2=0xFF00;	   
	   
    fff=fopen(FileName,"wb");
    if (fff==NULL){
       printf("PPRO error... File \"%s\" could not be opened.\n",FileName);
       return(1);
    }
	   
    if ((width>65535) || (height>65535)) {
       printf("PPRO error... Picture to be saved is too big.\n");
       return(2);
    }
   
    strcpy(buffer,"PAINTPROV7.0"); 
    errorlev=fwrite(buffer,1,12,fff);
	   
    buffer[0]=eight_bit_pal;
    buffer[1]=xsize&mask1;
    buffer[2]=(xsize&mask2)/256;
	   
    buffer[3]=ysize&mask1;
    buffer[4]=(ysize&mask2)/256;
    buffer[5]=bits_per_pixel;
    errorlev=fwrite(buffer,1,6,fff);
   	       
    if (eight_bit_pal) 	   
       for(i=0;i<(256);i++) { /* do {*Save the pallete (24 bit, rgb)}*/
       /*getpal(i,buffer[0],buffer[1],buffer[2]);*/
          buffer[0]=palette[i][0];    
          buffer[1]=palette[i][1];   
          buffer[2]=palette[i][2];
          errorlev=fwrite(buffer,1,3,fff);
       }
    /*
	printf("%i\n",sizeof(transparent_col));   
    if (sizeof(transparent_col)!=pixel_byte_size) 
       printf("PPRO warning... transparent pixel passed was wrong size\n");*/
    errorlev=fwrite(transparent_col,1,pixel_byte_size,fff);

	  
	   
    y=y1;
    numacross=0;                          
    second1=0;                            
    oldcol=fbuf[0];
    while (y<=height) {
       x=0;
       while (x<=width) {
          col=fbuf[(y*width)+x];
	  if (col==oldcol) {
	     if (second1!=0) {
		/*go through loop, writing all the x-1.  */
	     }
	     if (numacross>32767) {
		/*do something*/
	     }
	     else numacross++;
	  }
          else {                     /*compresses 1 color stretches */
             if (numacross==1) {
		numacross=0;
		second1++;
	     }
	     else {
		buffer[0]=(((second1/16)*256)/256);
		buffer[1]=(((second1*4096)/256)+(((oldcol+2048)*16)/4096));
		buffer[2]=(((oldcol+2048)*256)/256);
		errorlev=fwrite(buffer,1,3,fff);
                second1=0;
             }
	  }
          x++;
          oldcol=col;
       }
       y++;
       buffer[0]=(((col/16)*256)/256);
       buffer[1]=(((col*4096)/256)+((numacross*16)/4096));
       buffer[2]=((numacross*256)/256);
       errorlev=fwrite(buffer,1,3,fff);
    }
	   
/* END OF PAINT PRO PART */	   
	   
    	}
/*	else err = RPREAD_NOFILE;*/
        fclose(fff);
	return (err);
}

int main( int argc, char **argv)
{
   if (argc==3) {
      readPCX(argv[1],argv[2]);
   }
   else printf("\nNeed to do 'readPCX infile.pcx outfile.ppp'\n\n");
 return 0;  
}
