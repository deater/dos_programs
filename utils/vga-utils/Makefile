CC = gcc
CFLAGS = -O2 -Wall -g

all:	pcx2vga png2vga vga2png

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

vga2png:		vga2png.o
			$(CC) -o vga2png vga2png.o $(LFLAGS) -lpng

vga2png.o:		vga2png.c
			$(CC) $(CFLAGS) -c vga2png.c

###

#install:	
#		cp pcx2vga png2vga vga2png $(INSTALL_LOC)

clean:		
		rm -f *~ *.o pcx2vga png2vga vga2png


