#include ../Makefile.inc

CC = gcc
CFLAGS = -g -Wall -O2

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	png2cga mist_poc


###

loadpng.o:	loadpng.c loadpng.h
	$(CC) $(CFLAGS) -c loadpng.c

rle_common.o:	rle_common.c rle_common.h
	$(CC) $(CFLAGS) -c rle_common.c
###

png2cga:		png2cga.o loadpng.o
	$(CC) $(LFLAGS) -o png2cga png2cga.o loadpng.o -lpng

png2cga.o:		png2cga.c loadpng.h
	$(CC) $(CFLAGS) -c png2cga.c

###

cga_sim.o:		cga_sim.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c cga_sim.c

###

mist_poc:		mist_poc.o cga_sim.o
	$(CC) $(LFLAGS) -o mist_poc mist_poc.o cga_sim.o $(SDL_LIBS)

mist_poc.o:		mist_poc.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c mist_poc.c


#install:	
#		cp png2gr png2gr_text png2rle png2lz4 png_to_40x48d png_to_40x96 png2sixbitmap png2sixrle png2sixrle2 png2fourrle png2six80 $(INSTALL_LOC)

clean:		
		rm -f *~ *.o png2cga cga_sim mist_poc
