#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <math.h>

#include "vga_emulator.h"
#include "sin1024.h"

#if 0
//extern int face[];

//extern int bpmin,bpmax;

//extern char *bgpic;
//extern int rotsin,rotcos;
//extern int rows[];
//extern long depthtable1[];
//extern long depthtable2[];
//extern long depthtable3[];
//extern long depthtable4[];

//extern int dotnum;

//extern void drawdots(void);
#endif


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
	short	x;
	short	y;
	short	z;
	short	old1;
	short	old2;
	short	old3;
	short	old4;
	short	yadd;
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

#if 0
	CBEG
	mov	ax,0a000h
	mov	es,ax
	mov	ax,cs
	mov	ds,ax
	mov	fs,cs:_bgpic[2]
	mov	cx,cs:_dotnum
	mov	si,OFFSET dot
@@1:	push	cx

	mov	ax,ds:[si+0] ;X
	imul	ds:_rotsin
	mov	ax,ax
	mov	cx,dx
	mov	ax,ds:[si+4] ;Z
	imul	ds:_rotcos
	sub	ax,bx
	sub	dx,cx
	mov	bp,dx
	add	bp,9000
	
	mov	ax,ds:[si+0] ;X
	imul	ds:_rotcos
	mov	bx,ax
	mov	cx,dx
	mov	ax,ds:[si+4] ;Z
	imul	ds:_rotsin
	add	ax,bx
	adc	dx,cx
	shrd	ax,dx,8
	sar	dx,8
	
	mov	bx,ax
	mov	cx,dx
	shrd	ax,dx,3
	sar	dx,3
	add	ax,bx
	adc	dx,cx
	
	idiv	bp
	add	ax,160
	push	ax
	cmp	ax,319
	ja	@@2
	
	;shadow

	xor	ax,ax
	mov	dx,8
	idiv	bp
	add	ax,100
	cmp	ax,199
	ja	@@2
	mov	bx,ax
	shl	bx,1
	mov	bx,ds:_rows[bx]
	pop	ax
	add	bx,ax
	push	ax
	
	mov	di,ds:[si+6]
	mov	ax,fs:[di]
	mov	es:[di],ax
	mov	ax,87+87*256
	mov	word ptr es:[bx],ax
	mov	ds:[si+6],bx
	
	;ball
	
	mov	ax,ds:_gravity
	add	ds:[si+14],ax
	mov	ax,ds:[si+2] ;Y
	add	ax,ds:[si+14]
	cmp	ax,ds:_gravitybottom
	jl	@@4
	push	ax
	mov	ax,ds:[si+14]
	neg	ax
	imul	cs:_gravityd
	sar	ax,4
	mov	ds:[si+14],ax
	pop	ax
	add	ax,ds:[si+14]
@@4:	mov	ds:[si+2],ax
	cwd
	shld	dx,ax,6
	shl	ax,6
	idiv	bp
	add	ax,100
	cmp	ax,199
	ja	@@3
	mov	bx,ax
	shl	bx,1
	mov	bx,ds:_rows[bx]
	pop	ax
	add	bx,ax

	mov	di,ds:[si+8]
	mov	eax,fs:[di]
	mov	es:[di],eax
	add	di,320
	mov	eax,fs:[di]
	mov	es:[di],eax
	add	di,320
	mov	eax,fs:[di]
	mov	es:[di],eax
;	add	di,320
;	mov	eax,fs:[di]
;	mov	es:[di],eax
	shr	bp,6
	and	bp,not 3
	
	cmp	bp,cs:_bpmin
	jge	@@t1
	mov	cs:_bpmin,bp
@@t1:	cmp	bp,cs:_bpmax
	jle	@@t2
	mov	cs:_bpmax,bp
@@t2:
	mov	ax,word ptr ds:_depthtable1[bp]
	mov	word ptr es:[bx+1],ax
	mov	eax,ds:_depthtable2[bp]
	mov	dword ptr es:[bx+320],eax
	mov	ax,word ptr ds:_depthtable3[bp]
	mov	word ptr es:[bx+641],ax
	mov	ds:[si+8],bx

@@z:	pop	cx
	add	si,16
	loop	@@1
@@0:	CEND

@@2:	mov	di,ds:[si+8]
	mov	eax,fs:[di]
	mov	es:[di],eax
	add	di,320
	mov	eax,fs:[di]
	mov	es:[di],eax
	add	di,320
	mov	eax,fs:[di]
	mov	es:[di],eax
	mov	di,ds:[si+6]
	mov	ds:[si+6],ax
	mov	ax,fs:[di]
	mov	es:[di],ax
	pop	bx
	pop	cx
	add	si,16
	loop	@@1
	jmp	@@0
@@3:	mov	di,ds:[si+8]
	mov	eax,fs:[di]
	mov	es:[di],eax
	add	di,320
	mov	eax,fs:[di]
	mov	es:[di],eax
	add	di,320
	mov	eax,fs:[di]
	mov	es:[di],eax
	pop	bx
	pop	cx
	add	si,16
	loop	@@1
	jmp	@@0
#endif
}

void _setpalette(void) {
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

void outp(int x, int y) {

}

int inp(int addr) {
	return 0;
}

int dis_waitb(void) {
	return 0;
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

	printf("Setting border to %d\n",color);

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

	int timer=30000;
	int dropper,repeat;
	int frame=0;
	int rota=-1*64;
	int fb=0;
	int rot=0,rots=0;
	int a,b,c,d,i,j,mode;
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

	for(a=0;a<200;a++) {
		rows[a]=a*320;
	}

	set_default_pal();

	mode13h_graphics_init("dots");

//	set mode 13h
//	_asm mov ax,13h
//	_asm int 10h

	outp(0x3c8,0);
	for(a=0;a<16;a++) for(b=0;b<4;b++)
	{
		c=100+a*9;
		outp(0x3c9,cols[b*3+0]);
		outp(0x3c9,cols[b*3+1]*c/256);
		outp(0x3c9,cols[b*3+2]*c/256);
	}
	outp(0x3c8,255);
	outp(0x3c9,31);
	outp(0x3c9,0);
	outp(0x3c9,15);
	outp(0x3c8,64);
	for(a=0;a<100;a++)
	{
		c=64-256/(a+4);
		c=c*c/64;
		outp(0x3c9,c/4);
		outp(0x3c9,c/4);
		outp(0x3c9,c/4);
	}
	outp(0x3c7,0);
	for(a=0;a<768;a++) pal[a]=inp(0x3c9);
	outp(0x3c8,0);
	for(a=0;a<768;a++) outp(0x3c9,0);
	for(a=0;a<100;a++)
	{
		memset(vram+(100+a)*320,a+64,320);
	}
	for(a=0;a<128;a++)
	{
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
	//bgpic=halloc(64000L,1L);
	bgpic=calloc(64000L,1L);
	memcpy(bgpic,vram,64000);
	a=0;
	for(b=64;b>=0;b--)
	{	
		for(c=0;c<768;c++)
		{
			a=pal[c]-b;
			if(a<0) a=0;
			pal2[c]=a;
		}
		dis_waitb();
		dis_waitb();
		outp(0x3c8,0);
		for(c=0;c<768;c++) outp(0x3c9,pal2[c]);
	}

	while(!dis_exit() && frame<2450)
	{
		//setborder(0);
		repeat=dis_waitb();
//		if(frame>2300) setpalette(pal2);
		//setborder(1);
		if(dis_indemo())
		{
//			a=dis_musplus();
//			if(a>-4 && a<0) break;
		}
		while(repeat--)
		{
			frame++;
			if(frame==500) f=0;
			i=dottaul[j];
			j++; j%=dotnum;
			if(frame<500)
			{
				dot[i].x=isin(f*11)*40;
				dot[i].y=icos(f*13)*10-dropper;
				dot[i].z=isin(f*17)*40;
				dot[i].yadd=0;
			}
			else if(frame<900)
			{
				dot[i].x=icos(f*15)*55;
				dot[i].y=dropper;
				dot[i].z=isin(f*15)*55;
				dot[i].yadd=-260;
			}
			else if(frame<1700)
			{	
				a=sin1024[frame&1023]/8;
				dot[i].x=icos(f*66)*a;
				dot[i].y=8000;
				dot[i].z=isin(f*66)*a;
				dot[i].yadd=-300;
			}
			else if(frame<2360)
			{
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
			else if(frame<2400)
			{
				a=frame-2360;
				for(b=0;b<768;b+=3)
				{
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
			else if(frame<2440)
			{
				a=frame-2400;
				for(b=0;b<768;b+=3)
				{
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
			if(frame>1900) 
			{
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
