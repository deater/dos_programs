CC = gcc
CFLAGS = -O2 -Wall -g -I../../8086_emulator -I../../vga_emulator

PNG2UP = ../../../utils/vga-utils/png2up

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	jp

###

jp:	jp.o asm.o readp.o sin1024.o zoom.o \
	../dis/disc.o \
	../../vga_emulator/vga_emulator.o ../../8086_emulator/8086_emulator.o
	$(CC) -o jp jp.o asm.o readp.o sin1024.o zoom.o  \
		../dis/disc.o \
		../../vga_emulator/vga_emulator.o \
		../../8086_emulator/8086_emulator.o \
		$(LFLAGS) $(SDL_LIBS)
####

ICEKNGDM.up: ICEKNGDM.png
	$(PNG2UP) ICEKNGDM.png > ICEKNGDM.up

icekngdm.h:	ICEKNGDM.up
	xxd -i ICEKNGDM.up > icekngdm.h

###

../dis/disc.o:	
	cd ../dis && make

###

make_zoom.o:	make_zoom.c
	$(CC) $(CFLAGS) -c make_zoom.c

make_zoom:	make_zoom.o
	$(CC) $(LFLAGS) -o make_zoom make_zoom.o

zoom.c:	make_zoom
	./make_zoom
####

asm.o:	asm.c asm.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c asm.c

jp.o:	jp.c ../../vga_emulator/vga_emulator.h icekngdm.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c jp.c

readp.o:	readp.c readp.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c readp.c

sin1024.o:	sin1024.c sin1024.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c sin1024.c

zoom.o:	zoom.c zoom.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c zoom.c

###

clean:	
	rm -f *~ *.o *.up jp
