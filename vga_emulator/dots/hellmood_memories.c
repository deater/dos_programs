/* A Linux/SDL/C version of Hellmood's amazing 256B DOS Memories Demo */

/* See http://www.sizecoding.org/wiki/Memories for a rundown on how it works */

/* This is a conversion to C I did in an attempt to see how it works */
/* and also to see if I could port any of this to the Apple II */

/* x86 has amazing code density with powerful instructions */
/*	stos, mul, div, FPU, lots of 1-byte instructions */
/* and old x86 hardware made it really easy to program with limited code */
/*     VGA/MCGA Mode13h (320x200 256 colors linear framebuffer) */
/*     soundblaster MIDI with only a few out instructions */

/* Anyway this is a rough attempt to getting things going in C */
/* The last effect (ocean) is doing lots of sketchy stuff and */
/* depending a bit on undefined behavior so it's hit or miss */
/* whether it will work for you */

/* deater -- Vince Weaver -- vince@deater.net -- 23 April 2020 */

#include <stdio.h>
#include <unistd.h>

#include <SDL.h>

#include "8086_emulator.h"
#include "vga_emulator.h"

static int paused=1;

	/* tilted plane */
	/* DH=Y, DL=X */
static void fx0(void) {

	char ah,al,dh,dl;
	unsigned short temp;

	ax=0x1329;	// mov ax,0x1329	init

	al=ax&0xff; ah=(ax>>8)&0xff;
	dl=dx&0xff; dh=(dx>>8)&0xff;


	dh=dh+al;	// add dh,al	; prevent divide overflow
	div_8(dh);	// div dh	; reverse divide AL=C/Y'

	dx=((dh&0xff)<<8)|dl;

	temp=ax;
	ax=dx; dx=temp;	// xchg dx,ax	; DL=C/Y' AL=X

	dl=dx&0xff; dh=(dx>>8)&0xff;

	imul_8(dl);	// imul dl
	dx=dx-bp;	// sub dx,bp
	dl=dx&0xff;

	ah=(ax>>8)&0xff;
	ah=ah^dl;	// xor ah,dl
	al=ah;		// mov al,ah
	ax=((ah&0xff)<<8)|(al&0xff);

	ax&=0xff1c;	// and al,4+8+16
}

/* circles? */
/* DH=Y, DL=X */
static void fx1(void) {

	int temp;
	char al,dh,ah;

		// mov al,dh	; get Y in AL
	al=(dx>>8)&0xff;
		// sub al,100	; align Y vertically
	al=al-100;
	ax=ax&0xff00;
	ax=ax|al;
		// imul al	; AL=Y*Y
	imul_8(al);
		// xchg dx,ax	; Y*Y/256 in DH, X in AL
	temp=ax;
	ax=dx;
	dx=temp;
		// imul al	; AL=X*X
	imul_8(ax&0xff);
		// add dh,ah	; DH=X*X+Y*Y/256
	dh=(dx>>8)&0xff;
	ah=(ax>>8)&0xff;
	dh=dh+ah;
		// mov al,dh	; AL = X*X+Y*Y/256
	al=dh;

	dx=dx&0xff;
	dx|=(dh<<8);
	ax=(ah<<8)|(al&0xff);

		// add ax,bp	; offset color by time
	ax=ax+bp;
		// and al,8+16	; select special rings
	ax=ax&0xff18;
}

/* checkers */
static void fx2(void) {
	int temp;
	unsigned char al;

	temp=ax;
	ax=dx; dx=temp;	// xchg dx,ax
	ax=ax-bp;	// sub ax,bp
	temp=((ax>>8)&0xff)^(ax&0xff);
	ax=ax&0xff00;
	ax|=temp;	// xor al,ah
	ax|=0xdb;	// or al,0xdb
	al=ax&0xff;
	al=al+0x13;
	ax=ax&0xff00;
	ax=ax|al;	// add al,13h
			// ret

}


/* parallax checkrboard */
static void fx3(void) {

	cx=bp;		// mov cx,bp ; set init point to time
	bx=-16;		// mov bx,-16 ; limit to 16 iterations
fx3L:
	cx=cx+di;	// add cx, di ; offset by screenpointer
	ax=819;		// mov ax,819 ; magic, related to Rrrola
	imul_16(cx);	// imul cx ; get X',Y' in DX
	cf=dx&1;	// ror dx,1 ; set carry flag on "hit"
	dx=dx>>1;
	if (cf) {
		dx|=0x8000;
	}
	else {
		dx&=0x7fff;
	}

	bx++;		// inc bx ; increment iteration count
	if (bx==0) zf=1;// does not affect carry flag
	else zf=0;
			// ja fx3L ; loop until "hit" or "iter=max"
			// jump above, if cf==0 and zf==0
	if ((cf==0) && (zf==0)) goto fx3L;

	ax=bx+31;	// lea ax,[bx+32] ; map value to standard gray scale
	//printf("%d %d\n",ax,bx);
}

/* sierpinski rotozoomer */
static void fx4(void) {

	unsigned char dl,dh,bh,al;
	dl=dx&0xff;	dh=(dx>>8)&0xff;

	cx=bp-2048;	// lea cx,[bp-2048] ; center time to pass zero
	cx=cx<<3;	// sal cx,3 ; speed up by factor of 8!
	ax=(dh&0xff);	// movzx ax,dh ; get X into AL
			// movsx dx,dl ; get Y into DL
	if (dl&0x80) {
		dx|=0xff00;
	}
	else {
		dx&=0x00ff;
	}

	bx=ax;		// mov bx,ax   ; save X in BX
	imul_16_bx(cx);	// imul bx,cx  ; BX=X*T

	/* bl=bx&0xff;	*/ bh=(bx>>8)&0xff;
	dl=dx&0xff;	dh=(dx>>8)&0xff;

	bh=bh+dl;	// add bh,dl   ; bh=x*t/256+Y

	imul_16_dx(cx);	// imul dx,cx  ; dx=Y*T

	dl=dx&0xff;	dh=(dx>>8)&0xff;

			// sub al,dh   ; al=X-Y*T/256
	al=ax&0xff;	// ah=(ax>>8)&0xff;
	al=al-dh;

			// and al,bh   ; AL=(X-Y*T/256)&(x*T/256+Y)
	al=al&bh;
	al=al&252;	// and al,252  ; thicker sierpinksi
	if (al==0) zf=1;
	else zf=0;
	cf=0; of=0;
			// salc	       ; set pixel value to black
	if (cf==0) al=0;
	else al=0xff;

/* NOTE: remove the line below and the background becomes a rainbow */
	ax=al;
			// jnz fx4q    ; leave black if not sierpinksi
	if (zf==0) goto fx4q;

	ax=ax&0xff00;	// mov al,0x2a ; otherwise: a nice orange
	ax|=0x2a;
fx4q:
	;
}


/* raycast bent tunnel */
static void fx5(void) {

	unsigned char al,cl;
	unsigned short temp;

	cx=cx&0xff00;
	cx|=(-9&0xff);	// mov cl,-9	; start with depth 9 (moves backwards)
fx5L:
	cl=cx&0xff;

	push(dx);	// push dx ; save DX, destroyed inside loop
	al=(dx>>8)&0xff;// mov al,dh ; get Y into AL
	al-=100;	// sub al,100 ; centering Y manually

	ax=ax&0xff00;
	ax|=(al&0xff);

	imul_8(cl);	// imul cl	; multiply AL=Y by current distance to get projection
			// xchg ax,dx ; gt X into AL while saving DX
	temp=ax;
	ax=dx;
	dx=temp;

	al=ax&0xff;
	al+=cl;		// add al,cl  ; add distance to projection (bend right)

	ax=ax&0xff00;
	ax|=(al&0xff);
	imul_8(cl);	// imul cl	; multiply AL=X by the current projection
	al=(dx>>8)&0xff;// mov al,dh  ; get projection(1) in AL
	al^=(ax>>8);	// xor al,ah ; combine with projection(2)
	al+=4;		// add al,4  ; center the walls around 0
	if (al&-8) {	// test al,-8 ; test if the wall is hit
		zf=0;
	}
	else {
		zf=1;
	}

	dx=pop();	// pop dx (restore dx)
	cx&=0xff00;
	cx|=(cl&0xff);
	cx--;
	if ((cx!=0) && (zf==1)) goto fx5L;
			// loopz fx5L (repeat until "hit" or "iter=max"

	cx=cx-bp;	// sub cx,bp ; offset depth by time
	al^=(cx&0xff);	// xor al,cl ; XOR pattern for texture
//	ah=al/6;
	al=al%6;	// aam 6	; irregular pattern with MOD 6
	al+=20;		// add al,20	; offset into grayscale pattern
	ax=al&0xff;
}

/* ocean night */
static void fx6(void) {
	char dh;
	double f;
	int edx;
	char scratch[64];

	memset(scratch,0,64);

	// bx coming in is the address of the effect
	// this is a guess, too lazy to hexdump
	bx=0x1d5;

	// si=?? based on sound playing?
	// ax (sky color) is ?

	dh=dx>>8;
			// sub dh,120 ; check if pixel in the sky
	dh=dh-120;
	sf=!!(dh&0x80);
			// js fx6q    ; quit if that's the case
	if (sf) goto fx6q;

	dx&=0xff;
	dx|=dh<<8;

		// mov [bx+si],dx	; move xy to memory location
		// fild word [bx+si]	; read as integer put into ST(0)
		// fidivr dword [bx+si] ; reverse divide by constant
		// Divide m32int by ST(0) and store result in ST(0)
		// fstp dword [bx+si-1] ; store result as floating point
		// mov ax,[bx+si]	; get result into ax

	memcpy(&scratch[32],&dx,sizeof(short));
	f=dx;
	memcpy(&edx,&scratch[32],sizeof(int));
	f=edx/f;
	memcpy(&scratch[31],&f,sizeof(double));
	memcpy(&ax,&scratch[32],sizeof(short));




	ax+=bp;		// add ax,bp ; modify color by time
	ax&=0xff80;	// and al,128 ; threshold into two bands
	ax--;		// dec ax ; beautify colors to blue/black
fx6q:	;
}


int main(int argc, char **argv) {

	int temp;

	set_default_pal();

	mode13h_graphics_init("memories");

	di=0; // ??

	ax=0x13;		// mov al,0x13
				// int 0x10 ; set 320x200x256 color mode
	bp=ax;			// xchg bp,ax ; set bp to 0x13

	push(0xa000-10);	// write screen address to es
	es=pop();		// pop es
	ax=0x251c;		// mov ax,0x251c param for timer interrupt
	dx=0xdead;		// mov dl, timer set up timer interrupt
				// int 0x21

top:
	ax=0xcccd;		// load rrrola constant
	mul_16(di);		// multiply
	temp=(ax&0xff)+((ax>>8)&0xff);	// add al,ah
	ax=ax&0xff00;
	ax|=(temp&0xff);
	ax=ax&0xff;		// xor ah,ah
	ax=ax+bp;		// add ax,bp
	ax=ax>>9;		// shr	ax,9
	ax=ax&0xff0f;		// and al,15
	temp=ax;		// xchg bx,ax
	ax=bx;
	bx=temp;
	bx=bx&0xff;		// mov bh,1
	bx|=1<<8;
//	printf("%x: bx\n",bx);
				// mov bl,[byte bx+table]
				// call bx
	switch (bx&0xff) {
		case 0:	fx2(); break;
		case 1:	fx1(); break;
		case 2: fx0(); break;
		case 3: fx3(); break;
		case 4: fx4(); break;
		case 5: fx5(); break;
		case 6: fx6(); break;
		case 7: goto end;
		default: printf("Trying effect %d\n",bx&0xff);
	}
				// stosb
	framebuffer_write_20bit((es<<4)+di, ax&0xff);
	di++;

//	printf("Writing %d to %x (%x:%x)\n",ax&0xff,(es<<4)+di,es,di);
	di++;			// inc di
	di++;			// inc di
	if (di!=0) goto top;
//	printf("Done frame\n");
	mode13h_graphics_update();

	// timer emulate
	usleep(10000);
	bp=bp+1;
				// mov al,tempo
				// out 40h,al (set timing?)
				// in al,0x60 read keyboad
				// dec al
	while(paused) {
		while(graphics_input()==0);
		paused=0;
	}

	if (graphics_input()) {
		return 0;
	}

				// jnz top

	goto top;
end:

	return 0;
}
