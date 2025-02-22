/* deater -- Vince Weaver -- vince@deater.net -- 22 February 2025 */

#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

#include <SDL.h>

#include "8086_emulator.h"
#include "vga_emulator.h"

#include "image.h"

int main(int argc, char **argv) {

	int i,fd;

	if (argc<2) {
		fprintf(stderr,"Usage: %s raw_image\n",argv[0]);
		return -1;
	}

	fd=open(argv[1],O_RDONLY);
	if (fd<0) {
		fprintf(stderr,"Error opening %s: %s\n",argv[1],strerror(errno));
		return -1;
	}

	read(fd,framebuffer,65536);


	close(fd);


	set_default_pal();

	mode13h_graphics_init("image_viewer",2);

//	memcpy(framebuffer,image,65536);

	mode13h_graphics_update();

top:

	if (graphics_input()) {
		return 0;
	}

goto top;

	return 0;
}
