CC = gcc
CFLAGS = -O2 -Wall -g -I../8086_emulator -I../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	dots dots_small

###

dots_small:	dots_small.o \
	../vga_emulator/vga_emulator.o \
	../8086_emulator/8086_emulator.o
	$(CC) -o dots_small dots_small.o \
		../vga_emulator/vga_emulator.o \
		../8086_emulator/8086_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

dots_small.o:	dots_small.c ../vga_emulator/vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c dots_small.c

###

dots:	dots.o ../vga_emulator/vga_emulator.o ../8086_emulator/8086_emulator.o
	$(CC) -o dots dots.o \
		../vga_emulator/vga_emulator.o \
		../8086_emulator/8086_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

dots.o:	dots.c ../vga_emulator/vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c dots.c

###

clean:	
	rm -f *~ *.o dots dots_small
