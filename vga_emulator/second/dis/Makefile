CC = gcc
CFLAGS = -O2 -Wall -g -I../../8086_emulator -I../../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	disc.o

###

disc.o:	disc.c dis.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c disc.c

###

clean:	
	rm -f *~ *.o
