CC = gcc
CFLAGS = -O2 -Wall -g -I../8086_emulator -I../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	glenz

###

glenz:	glenz_main.o ../vga_emulator/vga_emulator.o ../8086_emulator/8086_emulator.o
	$(CC) -o glenz glenz_main.o \
		../vga_emulator/vga_emulator.o \
		../8086_emulator/8086_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

glenz_main.o:	glenz_main.c ../vga_emulator/vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c glenz_main.c

###

clean:	
	rm -f *~ *.o glenz
