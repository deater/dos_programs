/* A Linux/SDL/C version of Hellmood's amazing 64B DOS Star Path Demo */

/* See https://hellmood.111mb.de//starpath_is_55_bytes.html */

/* This is a conversion to C I did in an attempt to see how it works */
/* and also to see if I could port any of this to the Apple II */

/* deater -- Vince Weaver -- vince@deater.net -- 19 February 2025 */

#include <stdio.h>
#include <unistd.h>

#include <SDL.h>

//#include "8086_emulator.h"
#include "vga_emulator.h"

static int paused=0;


int main(int argc, char **argv) {

	int frame,color,depth,x,y,yprime,xprime;
	int temp;

	set_default_pal();

	mode13h_graphics_init("star path simple",2);

	frame=0;

	while(1) {

	for(x=0;x<256;x++) {
		for(y=0;y<200;y++) {

			depth=14;	//  start ray depth at 14
L:
			yprime=y*depth;	// Y'=Y * current depth

			temp=x-depth;	// curve X by the current depth

			// if left of the curve, jump to "sky"
			if (temp&0x100) {

				color=27;	// is both the star color and
						// palette offset into sky

				// pseudorandom multiplication leftover DL added to
				// truncated pixel count
				// 1 in 256 chance to be a star
				if (((x+yprime)&0xff)!=0) {
					// if not, shift the starcolor and add scaled pixel count
					color=(color<<4)|(y>>4);
				}
			}
			else {
				// multiply X by current depth (into AH)
				xprime=temp*depth;

				// OR for geometry and texture pattern
				temp=((xprime)|(yprime))>>8;

				// get (current depth) + (current frame)
				// mask geometry/texture by time shifted depth
				color=temp&(depth+frame);

				// (increment depth by one)
				depth++;

				// ... to create "gaps"

				if ((color&0x10)==0) goto L;

				// if ray did not hit, repeat pixel loop
			}

			framebuffer_putpixel(x,y,color);
		}
	}
	usleep(10000);

	frame++;		// increment frame counter


	mode13h_graphics_update();

	while(paused) {
		while(graphics_input()==0);
		paused=0;
	}

	if (graphics_input()) {
		return 0;
	}

	}

	return 0;

}
