CC = gcc
CFLAGS = -O2 -Wall -I../8086_emulator -I../vga_emulator

SDL_LIBS= `sdl-config --libs`
SDL_INCLUDE= `sdl-config --cflags`

all:	image_test

image_test:	image_test.o \
	../8086_emulator/8086_emulator.o \
	../vga_emulator/vga_emulator.o
	$(CC) -o image_test image_test.o \
		../8086_emulator/8086_emulator.o \
		../vga_emulator/vga_emulator.o \
		$(LFLAGS) $(SDL_LIBS)

image_test.o:	image_test.c image.h
	$(CC) $(CFLAGS) $(SDL_INCLUDE) -c image_test.c

###

image.h:	gp_hat_mcga.png
	../../utils/vga-utils/png2vga gp_hat_mcga.png > image.h

###

clean:	
	rm -f *~ *.o image_test image.h
