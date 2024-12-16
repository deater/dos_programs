CC = gcc
CFLAGS = -O2 -Wall -g

#SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	vga_emulator.o

###

vga_emulator.o:	vga_emulator.c vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c vga_emulator.c

###

clean:	
	rm -f *~ *.o
