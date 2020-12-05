/* simulate 80x25 cga text mode */

/* 80x25x2 bytes, char/attribute starting at 0xb8000 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <SDL.h>

#include "cga_sim.h"

#include "vga_font.h"

/* 40 column only for now */
#define TEXT_XSIZE	80
#define TEXT_YSIZE	25
#define TEXT_X_SCALE	9
#define TEXT_Y_SCALE	16

static int xsize=TEXT_XSIZE*TEXT_X_SCALE;
static int ysize=TEXT_YSIZE*TEXT_Y_SCALE;

//static int debug=0;

static SDL_Surface *sdl_screen=NULL;

unsigned char ram[80*25*2];

int grsim_input(void) {

	SDL_Event event;
	int keypressed;


	while ( SDL_PollEvent(&event)) {

		switch(event.type) {

		case SDL_KEYDOWN:
			keypressed=event.key.keysym.sym;
			switch (keypressed) {

			case SDLK_ESCAPE:
				return 27;
			case 'a'...'z':
			case 'A'...'Z':
				return keypressed;
			case SDLK_UP:
				return 11;
			case SDLK_DOWN:
				return 10;
			case SDLK_RIGHT:
				return 21;
			case SDLK_LEFT:
				return 8;
			default:
				printf("Unknown %d\n",keypressed);
				return keypressed;
			}
			break;


		case SDL_JOYBUTTONDOWN:
		case SDL_JOYAXISMOTION:
			printf("Joystick!\n");
			break;

		default:
			printf("Unknown input action!\n");
			break;

		}
	}

	return 0;
}

static unsigned int color[16]={
	0,		/*  0 black */
	0x0000aa,	/*  1 d. blue */
	0x00aa00,	/*  2 d. green */
	0x00aaaa,	/*  3 cyan */
	0xaa0000,	/*  4 red */
	0xaa00aa,	/*  5 purple */
	0xaa5500,	/*  6 brown */
	0xaaaaaa,	/*  7 light grey */
	0x555555,	/*  8 dark grey */
	0x5555ff,	/*  9 l blue */
	0x55ff55,	/* 10 l green */
	0x55ffff,	/* 11 l cyan */
	0xff5555,	/* 12 l red */
	0xff55ff,	/* 13 l purple */
	0xffff55,	/* 14 yellow */
	0xffffff,	/* 15 white */
};


static void draw_text(unsigned int *out_pointer,int text_start, int text_end) {

	int bit_set,ch,fg_color,bg_color;
	int xx,yy,i,j;
	unsigned int *t_pointer;

	t_pointer=out_pointer+(text_start*80*TEXT_Y_SCALE*TEXT_X_SCALE);

	for(yy=text_start;yy<text_end;yy++) {
		for(j=0;j<TEXT_Y_SCALE;j++) {
			for(xx=0;xx<TEXT_XSIZE;xx++) {

				ch=ram[yy*160+xx*2];
				fg_color=(ram[yy*160+xx*2+1])&0xf;
				bg_color=(ram[yy*160+xx*2+1])>>4;
				//if (ch!=0) printf("Printing: %c at %d %d\n",ch,
				//	xx,yy);

				for(i=0;i<TEXT_X_SCALE;i++) {

				if (i==0) {
					bit_set=0;
					if ((ch>=0xc0) && (ch<=0xdf)) {
						bit_set=(default_font[ch][j])&(1<<(8-1));
					}
				}
				else {
					bit_set=(default_font[ch][j])&(1<<(8-i));
				}
				if (bit_set) {
					*t_pointer=color[fg_color];
				}
				else {
					*t_pointer=color[bg_color];
				}

				t_pointer++;

				}
			}
		}
	}

}

int grsim_update(void) {

	unsigned int *t_pointer;

	/* point to SDL output pixels */
	t_pointer=((Uint32 *)sdl_screen->pixels);

	draw_text(t_pointer,0,TEXT_YSIZE);

	SDL_UpdateRect(sdl_screen, 0, 0, xsize, ysize);

	return 0;
}

int grsim_init(void) {

	int mode;
	int x;

	mode=SDL_SWSURFACE|SDL_HWPALETTE|SDL_HWSURFACE;

	if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
		fprintf(stderr,
			"Couldn't initialize SDL: %s\n", SDL_GetError());
		return -1;
	}

	/* Clean up on exit */
	atexit(SDL_Quit);

	/* assume 32-bit color */
	sdl_screen = SDL_SetVideoMode(xsize, ysize, 32, mode);
	printf("Setting up %d x %d 32-bit screen\n",xsize,ysize);

	if ( sdl_screen == NULL ) {
		fprintf(stderr, "ERROR!  Couldn't set %dx%d video mode: %s\n",
			xsize,ysize,SDL_GetError());
		return -1;
	}

	SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);

	/* Init screen */
	for(x=0;x<80*25*2;x++) ram[x]=0;

	return 0;
}

