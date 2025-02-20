CC = gcc
CFLAGS = -O2 -Wall -I../8086_emulator -I../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	hellmood_star_path star_path_simple

###

hellmood_star_path:	hellmood_star_path.o \
	../8086_emulator/8086_emulator.o \
	../vga_emulator/vga_emulator.o
	$(CC) -o hellmood_star_path hellmood_star_path.o \
		../8086_emulator/8086_emulator.o \
		../vga_emulator/vga_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

hellmood_star_path.o:	hellmood_star_path.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c hellmood_star_path.c

###

star_path_simple:	star_path_simple.o \
	../vga_emulator/vga_emulator.o
	$(CC) -o star_path_simple star_path_simple.o \
		../vga_emulator/vga_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

star_path_simple.o:	star_path_simple.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c star_path_simple.c

###


clean:	
	rm -f *~ *.o hellmood_star_path star_path_simple
