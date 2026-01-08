CC = gcc
CFLAGS = -O2 -Wall -g

all:	pcx2vga png2vga vga2png png2up up2pal

###

pcx2vga:		pcx2vga.o
			$(CC) -o pcx2vga pcx2vga.o $(LFLAGS)

pcx2vga.o:		pcx2vga.c
			$(CC) $(CFLAGS) -c pcx2vga.c
###

png2vga:		png2vga.o
			$(CC) -o png2vga png2vga.o $(LFLAGS) -lpng

png2vga.o:		png2vga.c
			$(CC) $(CFLAGS) -c png2vga.c

###

png2up:		png2up.o
			$(CC) -o png2up png2up.o $(LFLAGS) -lpng

png2up.o:		png2up.c
			$(CC) $(CFLAGS) -c png2up.c

###

up2pal:		up2pal.o
			$(CC) -o up2pal up2pal.o $(LFLAGS)

up2pal.o:		up2pal.c
			$(CC) $(CFLAGS) -c up2pal.c

###

vga2png:		vga2png.o
			$(CC) -o vga2png vga2png.o $(LFLAGS) -lpng

vga2png.o:		vga2png.c
			$(CC) $(CFLAGS) -c vga2png.c

###

#install:	
#		cp pcx2vga png2vga vga2png $(INSTALL_LOC)

clean:		
		rm -f *~ *.o pcx2vga png2vga vga2png png2up up2pal
