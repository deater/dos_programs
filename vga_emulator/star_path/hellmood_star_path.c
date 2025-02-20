/* A Linux/SDL/C version of Hellmood's amazing 64B DOS Star Path Demo */

/* See https://hellmood.111mb.de//starpath_is_55_bytes.html */

/* This is a conversion to C I did in an attempt to see how it works */
/* and also to see if I could port any of this to the Apple II */

/* deater -- Vince Weaver -- vince@deater.net -- 19 February 2025 */

#include <stdio.h>
#include <unistd.h>

#include <SDL.h>

#include "8086_emulator.h"
#include "vga_emulator.h"

static int paused=0;


int main(int argc, char **argv) {

	int temp;
	unsigned char temp8;

	set_default_pal();

	mode13h_graphics_init("star path",2);

	si=0;
	cx=0;
	bx=0;

	ax=0x13;	// mov al,0x13
				// mode 13h, 320x200 pixels, 256 colors
B:
	dx=0;		// cwd
				// erase DX for pixel setting (AH = 0x0C/0x00)

	int10h(ax,cx,dx);
			// int 0x10
				// set graphic mode (AH = 0x00)
				// set pixel (AH = 0x0C)
				//  (cx,dx)=al
X:
	bx=bx&0xff00;
	bx|=0x0d;	// mov bl,0xD
				//  start ray depth at 14
L:
	ax=0xcccc;	// mov ax,0xcccc
				// "Rrrola constant" to convert screen
				//  pointer to coordinates

	mul_16(cx);	// mul cx
				// Getting X,Y in DL,DH

	ax=ax&0xff00;
	ax|=((dx>>8)&0xff);
			// mov al,dh
				// getting Y into AL
	mul_8(bx&0xff);
			// mul bl
				// multiply Y by current depth (into AH)
	temp=dx;
	dx=ax;
	ax=temp;
			// xchg ax,dx
				// store Y' into DH, get X into AL

	temp=ax&0xff;
	temp-=(bx&0xff);
	ax&=0xff00;
	ax|=(temp&0xff);
			//sub al,bl
				// curve X by the current depth
	if (temp&0x100) goto W;
			//jc W
				// if left of the curve, jump to "sky"
	mul_8(bx&0xff);
			//mul bl
				// multiply X by current depth (into AH)

	ax=ax&0xff00;
	ax|=((dx>>8)&0xff);
			//mov al,dh
				// get Y' in AL (now AL,AH = Y',X')

	temp=((ax>>8)|(ax&0xff));
	ax&=0xff00;
	ax|=(temp&0xff);
			// or al,ah
				// OR for geometry and texture pattern
	dx=bx+si;
			// lea dx,[bx+si]
				// get (current depth) + (current frame count) in DX (DL)

	bx++;		//inc bx
				// (increment depth by one)

	temp=ax&dx;
	ax=ax&0xff00;
	ax|=(temp&0xff);
			//and al,dl
				// mask geometry/texture by time shifted depth...
	temp=ax&16;
			//test al,16
				// ... to create "gaps"
	if (temp==0) goto L;
			//jz L
				// if ray did not hit, repeat pixel loop
	goto Q;		//jmp short Q
				// jump over the sky ^^

W:
	ax=ax&0xff00;
	ax|=27;		//mov al,27
				// is both the star color and palette offset into sky

	temp8=cx&0xff;
	temp8+=(dx&0xff);
	dx=dx&0xff00;
	dx|=temp8;
			//add dl,cl
				// pseudorandom multiplication leftover DL added to

	if (temp8==0) goto Q;
			//jz Q
				// truncated pixel count, 1 in 256 chance to be a star *

A:
	shld_ax_cx(4);	// shld ax,cx,4
				// if not, shift the starcolor and add scaled pixel count

Q:
	ax=ax&0xff;
	ax|=0x0c<<8;	// mov ah,0x0C
				// AH = 0xC sets a pixel when int 10h is called

	cx--;
	if (cx!=0) goto B;
			// loop B
				// repeat for 64k pixels

	si++;		// inc si
			// increment frame counter


	mode13h_graphics_update();

	while(paused) {
		while(graphics_input()==0);
		paused=0;
	}

	if (graphics_input()) {
		return 0;
	}

	goto B;			// jmp short B
				// rinse and repeat

	return 0;

}


