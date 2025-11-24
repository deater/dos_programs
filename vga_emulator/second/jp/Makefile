CC = gcc
CFLAGS = -O2 -Wall -g -I../../8086_emulator -I../../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	jp

###

jp:	jp.o asm.o readp.o sin1024.o \
	../dis/disc.o \
	../../vga_emulator/vga_emulator.o ../../8086_emulator/8086_emulator.o
	$(CC) -o jp jp.o asm.o readp.o sin1024.o \
		../dis/disc.o \
		../../vga_emulator/vga_emulator.o \
		../../8086_emulator/8086_emulator.o \
		$(LFLAGS) $(SDL_LIBS)
####

icekngdm.h:	ICEKNGDM.up
	xxd -i ICEKNGDM.up > icekngdm.h

###

../dis/disc.o:	
	cd ../dis && make

####

asm.o:	asm.c asm.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c asm.c

jp.o:	jp.c ../../vga_emulator/vga_emulator.h icekngdm.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c jp.c

readp.o:	readp.c readp.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c readp.c

sin1024.o:	sin1024.c sin1024.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c sin1024.c

###

clean:	
	rm -f *~ *.o jp
