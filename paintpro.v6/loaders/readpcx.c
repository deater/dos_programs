/*-----------------------------------------------------------------------
	Warp-GGI

	General Graphics Interface demo
	Realtime picture 'gooing'

	readpcx.c : PCX files reader	

        PCX original code by some cow-orker i forgot :)
        Adapted and way optimized by Emmanuel Marty <emarty@mirus.fr>

	Feel free to reuse this for other GGI demos and projects.

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

int readPCX (char *name /*, struct raw_pict *rp*/ )
{
	FILE			*f;
	unsigned short		bytes;
	struct	pcx_header	header;
	unsigned int		i, j, c, err;
	unsigned int		width, height;
/*	ggi_color		*palette; */
	unsigned char			*fbuf, *lptr, *nextlptr, palbuf[4];
        char FileName[30],buffer[300];
        FILE *fff;
        unsigned int errorlev,xsize,ysize,numcolors;
	unsigned int q,y,numacross,second1,oldcol,x,col;
        unsigned int palette[256][3];
   
   
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
	   
/*	   
function Mode13SavePicPacked(x1,y1,x2,y2,numcolors:integer;where:word;filename:string):byte;

{**** Saves an image, with corners x1,y1 and x2,y2
      and number of colors NUMCOLORS, and at segment
      where ($A000 for vga) to the paintpro file
      filename ****}
    {x2 y2 should be plus one (320,200 not 319,199}

var buffer:array[0..2] of byte;
    header:string[15];
    f:file;
    col,x,y,xsize,ysize,i,oldcol,numacross:integer;
    byte1,byte2,byte3,temp:byte;
    r,g,b:byte;
    second1,zz:integer;

procedure integer23bytes(inter1,inter2:integer);
var temp1,temp2,temp3:integer;
    temp:byte;
begin
  {asm
    mov ax,inter1
    shl ax,1
      shl ax,1        this assembly will accomplish
      shl ax,1        what the below will.  Basically
      shl ax,1        it takes two, 16 bit integers,
    mov temp1,ah      strips off the top 4 bits of each,
    sub ah,ah         (makin two, 12 bit integers) and
    shr ax,1          joins these into three 8 bit bytes
      shr ax,1
      shr ax,1         for this assmebly to work, however
      shr ax,1        temp1,temp2, etc must be byte, not
    mov temp,al       integer
    mov ax,inter2
    mov temp3,al
    shr ax,1
      shr ax,1
      shr ax,1
      shr ax,1
    mov ah,temp
    shl ax,1
      shl ax,1        in the below, shl is shift left
      shl ax,1           (in C the equivelant is <<)
      shl ax,1        and shr is shift right ( >> )
    mov temp2,ah
  end;

  }
  temp1:=(inter1  AND $7FFF);
  temp1:=temp1 shr 4;
  temp3:=(inter2 AND $7FFF);
  temp2:= ((inter1 and $000F) shl 4)+ ((inter2 AND $0F00) shr 8);

    buffer[0]:=temp1;
    buffer[1]:=temp2;
    buffer[2]:=temp3;
    blockwrite(f,buffer,1);
end;


begin
  Mode13SavePicPacked:=0;    {*Clear the errors}
*/  
   strcpy(FileName,"out.ppp");
   fff=fopen(FileName,"wb");
   if (fff==NULL){
      printf("PPRO error... File \"%s\" not found.\n",FileName);
      exit(1);
    }

    strcpy(buffer,"PAINTPROV6.0"); 
    errorlev=fwrite(buffer,1,12,fff);
	   
    xsize=width;
    ysize=height;
    numcolors=256;

    buffer[0]=(((xsize/16)*256)/256);
    buffer[1]=(((xsize*4096)/256)+((ysize*16)/4096));
    buffer[2]=((ysize*256)/256);
	   
    buffer[3]=(((numcolors/16)*256)/256);
    buffer[4]=(((numcolors*4096)/256));
    buffer[5]=0;
    errorlev=fwrite(buffer,1,6,fff);
	       
    for(i=0;i<(numcolors-1);i++) { /* do {*Save the pallete (24 bit, rgb)}*/
       /*getpal(i,buffer[0],buffer[1],buffer[2]);*/
       buffer[0]=palette[i][0];    
       buffer[1]=palette[i][1];   
       buffer[2]=palette[i][2];
       errorlev=fwrite(buffer,1,3,fff);
    }
	   
  q=0;
  y=0;
  numacross=0;                          
  second1=0;                            
  oldcol=fbuf[q];
  while (y<=ysize) {
        x=0;
        while (x<=xsize) {
              col=fbuf[(y*xsize)+x];
	    
              if ((col==oldcol) && (numacross<2046)) numacross++;
              else {                     /*compresses 1 color stretches */
                   if (numacross==1) {
                      if (second1==0) {
                         second1=oldcol+2048;
                      }
                      else {
			 buffer[0]=(((second1/16)*256)/256);
			 buffer[1]=(((second1*4096)/256)+(((oldcol+2048)*16)/4096));
			 buffer[2]=(((oldcol+2048)*256)/256);
			 errorlev=fwrite(buffer,1,3,fff);
                         second1=0;
                      }

                   }
                   else {
                        if (second1!=0) {
			   buffer[0]=((((second1-2048)/16)*256)/256);
		           buffer[1]=((((second1-2048)*4096)/256)+((1*16)/4096));
		           buffer[2]=((1*256)/256);
		           errorlev=fwrite(buffer,1,3,fff);
		     	}
                        buffer[0]=(((oldcol/16)*256)/256);
		        buffer[1]=(((oldcol*4096)/256)+((numacross*16)/4096));
		        buffer[2]=((numacross*256)/256);
		        errorlev=fwrite(buffer,1,3,fff);
                        second1=0;
                   }
                   numacross=1;
              }
              x++;
              oldcol=col;
        }
        y++;
  }
	   buffer[0]=(((col/16)*256)/256);
	   buffer[1]=(((col*4096)/256)+((numacross*16)/4096));
	   buffer[2]=((numacross*256)/256);
	   errorlev=fwrite(buffer,1,3,fff);
	   
	   
	   
    	}
/*	else err = RPREAD_NOFILE;*/
        fclose(fff);
	return (err);
}

int main( int argc, char **argv)
{
   if (argc==2) {
      readPCX(argv[1]);
   }
   else printf("\nNeed to do 'readPCX filename'\n\n");
 return 0;  
}
