CC = gcc
CFLAGS = -O2 -Wall -g

all:	png2cga cga2png cga_make_sprite cga_make_sprite_mask \
	png2collision png2priority

###

png2cga:		png2cga.o
			$(CC) -o png2cga png2cga.o $(LFLAGS) -lpng

png2cga.o:		png2cga.c
			$(CC) $(CFLAGS) -c png2cga.c

###

cga_make_sprite:		cga_make_sprite.o
			$(CC) -o cga_make_sprite cga_make_sprite.o $(LFLAGS) -lpng

cga_make_sprite.o:		cga_make_sprite.c
			$(CC) $(CFLAGS) -c cga_make_sprite.c

###

cga_make_sprite_mask:		cga_make_sprite_mask.o
			$(CC) -o cga_make_sprite_mask cga_make_sprite_mask.o $(LFLAGS) -lpng

cga_make_sprite_mask.o:		cga_make_sprite_mask.c
			$(CC) $(CFLAGS) -c cga_make_sprite_mask.c



###

cga2png:		cga2png.o
			$(CC) -o cga2png cga2png.o $(LFLAGS) -lpng

cga2png.o:		cga2png.c
			$(CC) $(CFLAGS) -c cga2png.c

###

png2collision:		png2collision.o
			$(CC) -o png2collision png2collision.o $(LFLAGS) -lpng

png2collision.o:		png2collision.c
			$(CC) $(CFLAGS) -c png2collision.c

###

png2priority:		png2priority.o
			$(CC) -o png2priority png2priority.o $(LFLAGS) -lpng

png2priority.o:		png2priority.c
			$(CC) $(CFLAGS) -c png2priority.c



###

#install:	
#		cp pcx2cga png2cga cga2png $(INSTALL_LOC)

clean:		
		rm -f *~ *.o pcx2cga png2cga cga2png cga_make_sprite cga_make_sprite_mask png2collision
