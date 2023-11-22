CC = gcc
CFLAGS = -O2 -Wall -g

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	dots hellmood_memories

###

dots:	dots.o vga_emulator.o 8086_emulator.o
	$(CC) -o dots dots.o vga_emulator.o 8086_emulator.o $(LFLAGS) $(SDL_LIBS)

dots.o:	dots.c vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c dots.c

###

hellmood_memories:	hellmood_memories.o 8086_emulator.o vga_emulator.o
	$(CC) -o hellmood_memories hellmood_memories.o 8086_emulator.o vga_emulator.o $(LFLAGS) $(SDL_LIBS)

hellmood_memories.o:	hellmood_memories.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c hellmood_memories.c

###

8086_emulator.o:	8086_emulator.c 8086_emulator.h
	$(CC) $(CFLAGS) -c 8086_emulator.c

###

vga_emulator.o:	vga_emulator.c vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c vga_emulator.c

###

clean:	
	rm -f *~ *.o dots hellmood_memories
