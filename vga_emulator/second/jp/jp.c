#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../dis/dis.h"
#include "../../vga_emulator/vga_emulator.h"

#include "asm.h"
#include "sin1024.h"

FILE	*f1;

#include "readp.h"

#include "icekngdm.h"

/* keyboard status flag */
/* insert/caps-lock/num-lock/scroll-lock/AKT/CTRL/L-shift/R-Shift */
//char *shiftstatus=(char *)0x0417;


//extern char pic[];

uint32_t vram=0xa0000000;

static unsigned char rowdata1[200][186];
static unsigned char rowdata2[200][186];
static unsigned char *row[400];

//static char pal2[768];
static unsigned char palette[768];
static unsigned char rowbuf[640];

static int framey1[200];
static int framey2[200];
static int framey1t[800];
static int framey2t[800];
static int lasty[400];
static int lasts[400];

static void scrolly(int y) {

	int a;

	a=y*80;


		// mov	dx,3d4h
		// mov	al,0dh
		// mov	ah,byte ptr a[0]
		// out	dx,ax
	outp(0x3d4,0x0d);
	outp(0x3d5,a&0xff);

		// mov	dx,3d4h
		// mov	al,0ch
		// mov	ah,byte ptr a[1]
		// out	dx,ax
	outp(0x3d4,0x0c);
	outp(0x3d5,((a>>8)&0xff));

}




int waitb(void) {
	return(dis_waitb());
}



void doit(void) {

	int frame=0;
	int a,b,c,y,xsc,y1=0,y2=0;

//	while (!dis_exit() && dis_musplus()<4) {
//	}

	while(!dis_exit() && frame<700) {

		/* change border color if scroll lock set? */
		/* probably doing debug timing */

//		if (*shiftstatus&16) setborder(0);

		c=waitb();

//		if (*shiftstatus&16) setborder(127);

		frame+=c;
		if (frame>511) {
			c=400;
		}
		else {
			y1=framey1t[frame]/16;
			y2=framey2t[frame]/16;
		}
		xsc=(400-(y2-y1))/8;

		for(y=0;y<400;y++) {
			if(y<y1 || y>=y2) {
				linezoom(vram+y*80,NULL,0);
			}
			else {
				b=(long)(y-y1)*400L/(long)(y2-y1);
				a=184+(sin1024[b*32/25]*xsc+32)/64;
				a&=~1;
				if (lasty[y]!=b || lasts[y]!=a) {
					linezoom(vram+y*80,row[b],a);
					lasty[y]=b;
					lasts[y]=a;
				}
			}
		}

		mode13h_graphics_update();

		if (graphics_input()) {
			return ;
		}


	}
}

int main(int argc, char **argv) {

	int frame,halt=0;
	int a,b,c,d,y,la;
	int y1,y2,y1a,y2a,mika;
//	int ysz,ysza,storea=0;

	dis_partstart();

	/* set up pointers? */
	for(a=0;a<200;a++) row[a]=rowdata1[a];
	for(a=0;a<200;a++) row[a+200]=rowdata2[a];

	frame=0;
	y=0;
	y1=0; y1a=500;
	y2=399*16; y2a=500;
	mika=1;


	for(frame=0;frame<200;frame++) {

		if (!halt) {
			y1+=y1a;
			y2+=y2a;

			y2a+=16;

			if (y2>400*16) {

				y2-=y2a;
				y2a=-y2a*mika/8;
				if (mika<4) mika+=3;
			}

			y1a+=16;

			la=a;
			a=(y2-y1)-400*16;

			if ((a&0x8000)^(la&0x8000)) {
				y1a=y1a*7/8;
			}
			y1a+=a/8;
			y2a-=a/8;
		}

		if (frame>90) {
			if (y2>=399*16) {

				y2=400*16;
				halt=1;
			}
			else {
				y2a=8;
			}
			y1=y2-400*16;
		}

		framey1[frame]=y1;
		framey2[frame]=y2;
	}

	for(a=0;a<800;a++) {
		b=a/4;
		c=a&3;
		d=3-c;
		framey1t[a]=(framey1[b]*d+framey1[b+1]*c)/3;
		framey2t[a]=(framey2[b]*d+framey2[b+1]*c)/3;
	}

	/* Init Mode 13h graphics */
	mode13h_graphics_init("jp",2);

	/* put it in 320x400 mode */
	inittwk();

	/* set border color? */

		// mov	dx,3c0h		; screen border color
		// mov	al,11h
		// out	dx,al

		// mov	al,255		; color 255?
		// out	dx,al

		// mov	al,20h		; colore 32?
		// out	dx,al

	/* read the palette from the picture */
	readp(palette,-1,ICEKNGDM_up);

	/* set color 64 to black? */
	palette[64*3+0]=0;
	palette[64*3+1]=0;
	palette[64*3+2]=0;



	/* ????? */
	for(y=0;y<400;y++) {
		readp(rowbuf,y,ICEKNGDM_up);
		memcpy(row[y],rowbuf+70,184);
		row[y][184]=65;
	}

	setpalarea(palette,0,256);

set_default_pal();

	/* get from color 0 to color 64 (special black?) */
	for(a=0;a<400;a++) {
		for(b=0;b<184;b++) if(row[a][b]==0) row[a][b]=64;
	}

	for(y=0;y<400;y++) lasty[y]=lasts[y]=-1;

	dis_waitb();

	scrolly(400);
	dis_waitb();



	for(y=0;y<400;y++) {
		linezoom(vram+y*80,row[y],184);
	}


	a=64; y=400*64;
	while(y>0) {
		y-=a;
		a+=6;
		if(y<0) y=0;
		scrolly(y/64);
		dis_waitb();
	}

//	storea=a;
	dis_waitb();

	doit();


	/* restore text mode? */

	//_asm mov ax,3
	//_asm int 10h
	//printf("%i\n",storea);

	return 0;
}
