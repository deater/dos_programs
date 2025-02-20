/* deater -- Vince Weaver -- vince@deater.net -- 15 December 2024 */

#include <stdio.h>
#include <unistd.h>

#include <SDL.h>

#include "8086_emulator.h"
#include "vga_emulator.h"

#include "image.h"

int main(int argc, char **argv) {

	int i;

	set_default_pal();

	mode13h_graphics_init("image_viewer",2);

	for(i=0;i<256;i++) {
		set_pal(i,pal_r[i]<<2,pal_g[i]<<2,pal_b[i]<<2);
	}

	memcpy(framebuffer,image,65536);

	mode13h_graphics_update();

top:

	if (graphics_input()) {
		return 0;
	}

goto top;

	return 0;
}
