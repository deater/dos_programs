CC = gcc
CFLAGS = -O2 -Wall -g -I../8086_emulator -I../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	glenz

###

glenz:	glenz_main.o \
	disc.o glenz_zoomer.o math.o mathsin.o sin1024.o vec.o \
	../vga_emulator/vga_emulator.o ../8086_emulator/8086_emulator.o
	$(CC) -o glenz glenz_main.o \
		disc.o glenz_zoomer.o math.o mathsin.o sin1024.o vec.o \
		../vga_emulator/vga_emulator.o \
		../8086_emulator/8086_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

glenz_main.o:	glenz_main.c ../vga_emulator/vga_emulator.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c glenz_main.c

disc.o:	disc.c dis.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c disc.c

glenz_zoomer.o:	glenz_zoomer.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c glenz_zoomer.c

math.o:	math.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c math.c

mathsin.o:	mathsin.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c mathsin.c

sin1024.o:	sin1024.c
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c sin1024.c

vec.o:	vec.c vec.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c vec.c

###

clean:	
	rm -f *~ *.o glenz
