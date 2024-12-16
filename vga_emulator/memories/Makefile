CC = gcc
CFLAGS = -O2 -Wall -I../8086_emulator -I../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	hellmood_memories

hellmood_memories:	hellmood_memories.o \
	../8086_emulator/8086_emulator.o \
	../vga_emulator/vga_emulator.o
	$(CC) -o hellmood_memories hellmood_memories.o \
		../8086_emulator/8086_emulator.o \
		../vga_emulator/vga_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

hellmood_memories.o:	hellmood_memories.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c hellmood_memories.c

clean:	
	rm -f *~ *.o hellmood_memories
