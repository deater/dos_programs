CC = gcc
STRIP = strip
CFLAGS = -O2 -Wall

all:	raster.com

raster.com:	      raster.o.o
		      dd if=raster.o.o of=raster.com bs=256 skip=1

raster.o.o:	      raster.o
		      objcopy -O binary raster.o raster.o.o

raster.o:	      raster.s
		      as --32 -R -o raster.o raster.s

install:	raster.com
	cp raster.com /home/vince/dos/dos/

clean:	
	rm -f *.o raster
