CC = gcc
CFLAGS = -Wall -O2 -g

all:	mist

###

mist:	mist.o \
	level_mist.o
	$(CC) -o mist mist.o level_mist.o $(LFLAGS)

###

mist.o:	mist.c zp.h
	$(CC) $(CFLAGS) -c mist.c

###

level_mist.o:	level_mist.c zp.h
	$(CC) $(CFLAGS) -c level_mist.c

####

graphics_title/title_graphics.inc:
	cd graphics_title && make

graphics_mist/mist_graphics.inc:
	cd graphics_mist && make

graphics_octagon/octagon_graphics.inc:
	cd graphics_octagon && make

books/octagon_books.inc:
	cd books && make

graphics_viewer/viewer_graphics.inc:
	cd graphics_viewer && make

graphics_meche/meche_graphics.inc:
	cd graphics_meche && make

graphics_selena/selena_graphics.inc:
	cd graphics_selena && make

graphics_cabin/cabin_graphics.inc:
	cd graphics_cabin && make

graphics_channel/channel_graphics.inc:
	cd graphics_channel && make

graphics_stoney/stoney_graphics.inc:
	cd graphics_stoney && make

graphics_dentist/dentist_graphics.inc:
	cd graphics_dentist && make

graphics_generator/generator_graphics.inc:
	cd graphics_generator && make

graphics_arbor/arbor_graphics.inc:
	cd graphics_arbor && make

graphics_nibel/nibel_graphics.inc:
	cd graphics_nibel && make

graphics_dni/dni_graphics.inc:
	cd graphics_dni && make

graphics_ship/ship_graphics.inc:
	cd graphics_ship && make

graphics_sub/sub_graphics.inc:
	cd graphics_sub && make


####

clean:		
	rm -f *~ *.o mist
	cd graphics_title && make clean
	cd graphics_mist && make clean
	cd graphics_octagon && make clean
	cd books && make clean
	cd graphics_viewer && make clean
	cd graphics_meche && make clean
	cd graphics_selena && make clean
	cd graphics_cabin && make clean
	cd graphics_channel && make clean
	cd graphics_stoney && make clean
	cd graphics_dentist && make clean
	cd graphics_generator && make clean
	cd graphics_arbor && make clean
	cd graphics_nibel && make clean
	cd graphics_dni && make clean
	cd graphics_ship && make clean
	cd graphics_sub && make clean

