CC = gcc
CFLAGS = -O2 -Wall -g

#SDL_LIBS= `sdl-config --libs`
#SDL_INCLUDE= `sdl-config --cflags`

all:	8086_emulator.o

###

8086_emulator.o:	8086_emulator.c 8086_emulator.h
	$(CC) $(CFLAGS) -c 8086_emulator.c

###

clean:	
	rm -f *~ *.o
