#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <malloc.h>
#include <math.h>

#include "8086_emulator.h"
#include "vga_emulator.h"
#include "sin1024.h"

#define	MAXDOTS	1024

#define BOTTOM 8000

short gravitybottom=BOTTOM;

short bpmin=30000;
short bpmax=-30000;
short gravity=0;
short dotnum=0;
short gravityd=16;

//???,-1280,-960,-640,-320};

short rows[200]; // all zero

//short dot[MAXDOTS][8];	// x,y,z,oldposshadow,oldpos,-,-,-

struct {
	short	x;	// 0
	short	y;	// 2
	short	z;	// 4
	short	old1;	// 6
	short	old2;	// 8
	short	old3;	// 10
	short	old4;	// 12
	short	yadd;	// 14
} dot[MAXDOTS];


//dot dw	MAXDOTS dup(0,0,0,0,0,0,0,0) ;x,y,z,oldposshadow,oldpos,-,-,-


short rotsin=0;
short rotcos=0;


char *bgpic;


int depthtable1[128];
int depthtable2[128];
int depthtable3[128];
int depthtable4[128];

void drawdots(void) {
	int temp32,eax;

				//	CBEG
	ax=0xa000;			// mov	ax,0a000h
	es=ax;				// mov	es,ax
	ax=cs;				// mov	ax,cs
	ds=ax;				// mov	ds,ax

	fs=bgpic[2];			// mov	fs,cs:_bgpic[2]
	cx=dotnum;			// mov	cx,cs:_dotnum
	si=0;				// mov	si,OFFSET dot

label1:
	push(cx);			//push	cx
	ax=dot[si].x;			// mov	ax,ds:[si+0] ;X
	imul_16(rotsin);		// imul	ds:_rotsin
	ax=ax;				// mov	ax,ax
	cx=dx;				// mov	cx,dx
	ax=dot[si].z;			// mov	ax,ds:[si+4] ;Z
	imul_16(rotcos);		// imul	ds:_rotcos
	ax=ax-bx;			// sub	ax,bx
	dx=dx-cx;			// sub	dx,cx
	bp=dx;				// mov	bp,dx
	bp=bp+9000;			// add	bp,9000

	ax=dot[si].x;			// mov	ax,ds:[si+0] ;X
	imul_16(rotcos);		// imul	ds:_rotcos
	bx=ax;				// mov	bx,ax
	cx=dx;				// mov	cx,dx
	ax=dot[si].z;			// mov	ax,ds:[si+4] ;Z
	imul_16(rotsin);		// imul	ds:_rotsin

	temp32=ax+bx;			// add	ax,bx
	ax=ax+bx;			//
	dx=dx+cx;			// adc	dx,cx
	if (temp32&(1<<16)) dx=dx+1;


	ax=(ax>>8)|(dx<<8);		// shrd	ax,dx,8
	dx=(dx>>8)&0xff;		// sar	dx,8

	bx=ax;				// mov	bx,ax
	cx=dx;				// mov	cx,dx
	ax=(ax>>3)|(dx<<13);		// shrd	ax,dx,3

	dx=dx>>3;			// sar	dx,3
	temp32=ax+bx;			// add	ax,bx
	ax=ax+bx;
	dx=dx+cx;			// adc	dx,cx
	if (temp32&(1<<16)) dx=dx+1;

	idiv_16(bp);			// idiv bp
	ax=ax+160;			// add	ax,160
	push(ax);			// push	ax
	if (ax>319) goto label2;	// cmp	ax,319
					// ja	@@2

	/* shadow */

	ax=0;				// xor	ax,ax
	dx=8;				// mov	dx,8
	idiv_16(bp);			// idiv	bp
	ax=ax+100;			// add	ax,100
	if (ax>199) goto label2;	// cmp	ax,199
					// ja	@@2
	bx=ax;				// mov	bx,ax
	bx=bx<<1;			// shl	bx,1
	bx=rows[bx];			// mov	bx,ds:_rows[bx]
	ax=pop();			// pop	ax
	bx=bx+ax;			// add	bx,ax
	push(ax);			// push	ax

	/* erase old */
	di=dot[si].old1;		// mov	di,ds:[si+6]
	ax=bgpic[di];			// mov	ax,fs:[di]
	framebuffer[di]=ax;		// mov	es:[di],ax
	ax=87+87*256;			// mov	ax,87+87*256
	framebuffer[bx]=ax;		// mov	word ptr es:[bx],ax
	dot[si].old1=bx;		// mov	ds:[si+6],bx

	/* ball */

	ax=gravity;			// mov	ax,ds:_gravity
	dot[si].yadd+=ax;		// add	ds:[si+14],ax
	ax=dot[si].y;			// mov	ax,ds:[si+2] ;Y
	ax+=dot[si].yadd;		// add	ax,ds:[si+14]
	if (ax<gravitybottom) goto label4; //cmp	ax,ds:_gravitybottom
					// jl	@@4

	push(ax);			// push	ax

	ax=dot[si].yadd;		// mov	ax,ds:[si+14]
	ax=-ax;				// neg	ax
	imul_16(gravityd);		// imul	cs:_gravityd
	ax=ax>>4;			// sar	ax,4
	dot[si].yadd=ax;		// mov	ds:[si+14],ax
	ax=pop();			// pop	ax
	ax+=dot[si].yadd;		// add	ax,ds:[si+14]

label4:
	dot[si].y=ax;			// mov	ds:[si+2],ax
	if (ax&0x8000) {		// cwd
		dx=0xffff;
	}
	else {
		dx=0;
	}

	dx=(dx<<6)|(ax>>10);		// shld	dx,ax,6
	ax=ax<<6;			// shl	ax,6

	idiv_16(bp);			// idiv	bp
	ax=ax+100;			// add	ax,100
	if (ax>199) goto label3;	// cmp	ax,199
					// ja	@@3
	bx=ax;				// mov	bx,ax
	bx=bx<<1;			// shl	bx,1
	bx=rows[bx];			// mov	bx,ds:_rows[bx]

	ax=pop();			// pop	ax
	bx=bx+ax;			// add	bx,ax

	di=dot[si].old2;		// mov	di,ds:[si+8]
	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=di+320;			// add	di,320
	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=di+320;			// add	di,320
	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

				//;;	add	di,320
				//;;	mov	eax,fs:[di]
				//;;	mov	es:[di],eax

	bp=bp>>6;		// shr	bp,6
	bp=bp&(~3);		// and	bp,not 3

	if (bp>=bpmin) goto label_t1;	// cmp	bp,cs:_bpmin
					// jge	@@t1
	bpmin=bp;			// mov	cs:_bpmin,bp
label_t1:
	if (bp<=bpmax) goto label_t2;	// cmp	bp,cs:_bpmax
					// jle	@@t2
	bpmax=bp;			// mov	cs:_bpmax,bp
label_t2:
	eax=depthtable1[bp];		// mov	ax,word ptr ds:_depthtable1[bp]
					// mov	word ptr es:[bx+1],ax
	framebuffer[bx+1]=(eax>>0)&0xff;
	framebuffer[bx+2]=(eax>>8)&0xff;

	eax=depthtable2[bp];		// mov	eax,ds:_depthtable2[bp]
					// mov	dword ptr es:[bx+320],eax
	framebuffer[bx+320]=(eax>>0)&0xff;
	framebuffer[bx+321]=(eax>>8)&0xff;
	framebuffer[bx+322]=(eax>>16)&0xff;
	framebuffer[bx+323]=(eax>>24)&0xff;

	eax=depthtable3[bp];	// mov	ax,word ptr ds:_depthtable3[bp]
				// mov	word ptr es:[bx+641],ax
	framebuffer[bx+641]=(eax>>0)&0xff;
	framebuffer[bx+642]=(eax>>8)&0xff;
	dot[si].old2=bx;	// mov	ds:[si+8],bx


//labelz:
	cx=pop();		// pop	cx
	si=si+1;		// add	si,16	point to next dot
	cx=cx-1;
	if (cx!=0) goto label1;	// loop	@@1
label0:
	return;
				// @@0:	CEND

label2:
	di=dot[si].old2;		// mov	di,ds:[si+8]

	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=di+320;			// add	di,320

	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=di+320;

	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=dot[si].old1;		// mov	di,ds:[si+6]
	dot[si].old1=ax;		// mov	ds:[si+6],ax

	framebuffer[di]=bgpic[di];	// mov	ax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],ax

	bx=pop();			// pop	bx
	cx=pop();			// pop	cx
	si=si+1;			// add	si,16
	cx=cx-1;			// loop	@@1
	if (cx!=0) goto label1;
	goto label0;			// jmp	@@0

label3:
	di=dot[si].old2;		// mov	di,ds:[si+8]

	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=di+320;			// add	di,320

	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	di=di+320;			// add	di,320

	framebuffer[di]=bgpic[di];	// mov	eax,fs:[di]
	framebuffer[di+1]=bgpic[di+1];	// mov	es:[di],eax
	framebuffer[di+2]=bgpic[di+2];
	framebuffer[di+3]=bgpic[di+3];

	bx=pop();			// pop	bx
	cx=pop();			// pop	cx
	si=si+1;			// add	si,16
	cx=cx-1;			// loop	@@1
	if (cx!=0) goto label1;
	goto label0;			// jmp	@@0

}

void setpalette(char *pal) {

	printf("TODO: implement setpalette\n");
#if 0
	push	bp
	mov	bp,sp
	push	si
	push	di
	push	ds
	mov	si,[bp+6]
	mov	ds,[bp+8]
	mov	dx,3c8h
	mov	al,0
	out	dx,al
	inc	dx
	mov	cx,768
	rep	outsb
	pop	ds
	pop	di
	pop	si
	pop	bp
	ret
#endif
}

short _face[]={
	2248,-2306,0,		// from face.inc
	30000,30000,30000
};

/* wait for VGA border start */
int dis_waitb(void) {

// descr: Waits for border start
// waitb_1 PROC NEAR
//        call    checkkeys

//        IFDEF INDEMO
//        sti
//        mov     ax,cs:copperframecount
//@@v:    cmp     cs:copperframecount,ax
//        je      @@v
//@@q:    mov     ax,cs:copperframecount
//       mov     cs:copperframecount,0
//        ELSE

//        mov     dx,3dah
//@@1:    in      al,dx
//        test    al,8
//        jnz     @@1
//@@2:    in      al,dx
//        test    al,8
 //       jz      @@2

  //      mov     ax,1 ;number of frames taken            ;TEMP!

//        ENDIF
//        ret
//waitb_1 ENDP


	/* approximate by 70Hz sleep */
	usleep(14286);

	return 1;
}

int dis_exit(void) {
	return 0;
}

int dis_indemo(void) {
	return 0;
}



//char far *vram=(char far *)0xa0000000L;
unsigned char *vram=framebuffer;

char	pal[768];
char	pal2[768];

//extern sin1024[];

int	isin(int deg)
{
	return(sin1024[deg&1023]);
}

int	icos(int deg)
{
	return(sin1024[(deg+256)&1023]);
}



//extern int gravity;
//extern int gravitybottom;
//extern int gravityd;

void setborder(int color) {

	//printf("Setting border to %d\n",color);

	// to write attribute register:
	//	read/write address to $3c0
	//	data written to $3c0, read from $3c1
	// flip flop tracks if it's index/data, you reset that
	//	by reading $3da

	//mov	dx,3dah			// input status reg #1
	//in	al,dx			// resets index/addr flip-flop

	//mov	dx,3c0h			// attribute access
	//mov	al,11h+32		// $11=overscan (border color)
					// 32 is PAS bit
	//out	dx,al

	//mov	al,color
	//out	dx,al
}

int	cols[]={
0,0,0,
4,25,30,
8,40,45,
16,55,60};

int dottaul[1024];

int main(int argc,char **argv) {

//	int timer=30000;
	int dropper,repeat;
	int frame=0;
	int rota=-1*64;
//	int fb=0;
	int rot=0,rots=0;
	int a,b,c,d,i,j=0,mode;
	int grav,gravd;
	int f=0;

	//dis_partstart();

	dotnum=512;
	for(a=0;a<dotnum;a++) {
		dottaul[a]=a;
	}

	for(a=0;a<500;a++) {
		b=rand()%dotnum;
		c=rand()%dotnum;
		d=dottaul[b];
		dottaul[b]=dottaul[c];
		dottaul[c]=d;
	}

	dropper=22000;

	for(a=0;a<dotnum;a++) {
		dot[a].x=0;
		dot[a].y=2560-dropper;
		dot[a].z=0;
		dot[a].yadd=0;
	}
	mode=7;
	grav=3;
	gravd=13;
	gravitybottom=8105;
	i=-1;

	for(a=0;a<500;a++) { // scramble
		b=rand()%dotnum;
		c=rand()%dotnum;
		d=dot[b].x; dot[b].x=dot[c].x; dot[c].x=d;
		d=dot[b].y; dot[b].y=dot[c].y; dot[c].y=d;
		d=dot[b].z; dot[b].z=dot[c].z; dot[c].z=d;
	}

	/* setup rows lookup table */
	for(a=0;a<200;a++) {
		rows[a]=a*320;
	}

	set_default_pal();

	mode13h_graphics_init("dots");

//	set mode 13h
//	_asm mov ax,13h
//	_asm int 10h

	/* set palette address to 0 */
	outp(0x3c8,0);

	/* set up colors for first 64 colors */
	for(a=0;a<16;a++) {
		for(b=0;b<4;b++) {
			c=100+a*9;
			outp(0x3c9,cols[b*3+0]);
			outp(0x3c9,cols[b*3+1]*c/256);
			outp(0x3c9,cols[b*3+2]*c/256);
		}
	}

	/* set palette for color 255 */
	outp(0x3c8,255);

	/* some sort of purplish color? */
	outp(0x3c9,31);
	outp(0x3c9,0);
	outp(0x3c9,15);


	/* set colors starting from 64 ... 164 */
	/* looks like a grey gradient of some sort */
	outp(0x3c8,64);

	for(a=0;a<100;a++) {
		c=64-256/(a+4);
		c=c*c/64;
		outp(0x3c9,c/4);
		outp(0x3c9,c/4);
		outp(0x3c9,c/4);
	}

	/* read out the VGA card's idea of palette (?) */
	outp(0x3c7,0);
	for(a=0;a<768;a++) pal[a]=inp(0x3c9);

	/* clear palette to all 0 */
	/* this lets up setup background while not visible */
	outp(0x3c8,0);
	for(a=0;a<768;a++) outp(0x3c9,0);

	/* put grey gradient on bottom half of screen? */
	for(a=0;a<100;a++) {
		memset(vram+(100+a)*320,a+64,320);
	}

	/* set up depth table? */
	for(a=0;a<128;a++) {
		c=a-(43+20)/2;
		c=c*3/4;
		c+=8;
		if(c<0) c=0; else if(c>15) c=15;
		c=15-c;
		depthtable1[a]=0x202+0x04040404*c;
		depthtable2[a]=0x02030302+0x04040404*c;
		depthtable3[a]=0x202+0x04040404*c;
		//depthtable4[a]=0x02020302+0x04040404*c;
	}

	/* allocate space for background */
	//bgpic=halloc(64000L,1L);
	bgpic=calloc(64000L,1L);

	/* backup background */
	memcpy(bgpic,vram,64000);

	mode13h_graphics_update();

	/* Fade back in from palette */
	a=0;
	for(b=64;b>=0;b--) {
		for(c=0;c<768;c++) {
			a=pal[c]-b;
			if(a<0) a=0;
			pal2[c]=a;
		}
		/* wait for retrace (delay) */
		dis_waitb();
		dis_waitb();
		outp(0x3c8,0);
		for(c=0;c<768;c++) outp(0x3c9,pal2[c]);
		mode13h_graphics_update();
	}

	while(!dis_exit() && frame<2450) {

		/* code sets border color */
		/* then waits for it to end, as a timing thing? */
		setborder(0);

		/* when not in demo this defaults to 1? */
		repeat=dis_waitb();

		if(frame>2300) setpalette(pal2);

		setborder(1);

		if(dis_indemo()) {
			/* ?? music synchronization? */
//			a=dis_musplus();
//			if(a>-4 && a<0) break;
		}

		while(repeat--) {

		frame++;
		if(frame==500) f=0;
		i=dottaul[j];
		j++; j%=dotnum;
		if(frame<500) {
			dot[i].x=isin(f*11)*40;
			dot[i].y=icos(f*13)*10-dropper;
			dot[i].z=isin(f*17)*40;
			dot[i].yadd=0;
		}
		else if(frame<900) {
			dot[i].x=icos(f*15)*55;
			dot[i].y=dropper;
			dot[i].z=isin(f*15)*55;
			dot[i].yadd=-260;
		}
		else if(frame<1700) {
			a=sin1024[frame&1023]/8;
			dot[i].x=icos(f*66)*a;
			dot[i].y=8000;
			dot[i].z=isin(f*66)*a;
			dot[i].yadd=-300;
		}
		else if(frame<2360) {
				/*
				a=rand()/128+32;
				dot[i].y=8000-a*80;
				b=rand()&1023;
				a+=rand()&31;
				dot[i].x=sin1024[b]*a/3+(a-50)*7;
				dot[i].z=sin1024[(b+256)&1023]*a/3+(a-40)*7;
				dot[i].yadd=300;
				if(frame>1640 && !(frame&31) && grav>-2) grav--;
				*/
			dot[i].x=rand()-16384;
			dot[i].y=8000-rand()/2;
			dot[i].z=rand()-16384;
			dot[i].yadd=0;
			if(frame>1900 && !(frame&31) && grav>0) grav--;
		}
		else if(frame<2400) {
			a=frame-2360;
			for(b=0;b<768;b+=3) {
				c=pal[b+0]+a*3;
				if(c>63) c=63;
				pal2[b+0]=c;
				c=pal[b+1]+a*3;
				if(c>63) c=63;
				pal2[b+1]=c;
				c=pal[b+2]+a*4;
				if(c>63) c=63;
				pal2[b+2]=c;
			}
		}
		else if(frame<2440) {
			a=frame-2400;
			for(b=0;b<768;b+=3) {
				c=63-a*2;
				if(c<0) c=0;
				pal2[b+0]=c;
				pal2[b+1]=c;
				pal2[b+2]=c;
			}
		}
		if(dropper>4000) dropper-=100;

		rotcos=icos(rot)*64; rotsin=isin(rot)*64;
		rots+=2;

		if(frame>1900) {
			rot+=rota/64;
			rota--;
		}
		else rot=isin(rots);
		f++;
		gravity=grav;
		gravityd=gravd;
		}


		drawdots();

		mode13h_graphics_update();

		if (graphics_input()) {
	                return 0;
		}

	}

//	restores 80x25 color text mode
//	if (!dis_indemo()) {
//		_asm mov ax,3h
//		_asm int 10h
//	}
	return 0;
}
