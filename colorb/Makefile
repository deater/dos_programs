CC = gcc
STRIP = strip
CFLAGS = -O2 -Wall

all:	raster.com colorb.com

raster.com:	      raster.o.o
		      dd if=raster.o.o of=raster.com bs=256 skip=1

raster.o.o:	      raster.o
		      objcopy -O binary raster.o raster.o.o

raster.o:	      raster.s
		      as --32 -R -o raster.o raster.s

###

colorb.com:	      colorb.o.o
		      dd if=colorb.o.o of=colorb.com bs=256 skip=1

colorb.o.o:	      colorb.o
		      objcopy -O binary colorb.o colorb.o.o

colorb.o:	      colorb.s
		      as --32 -R -o colorb.o colorb.s

###

install:	raster.com colorb.com
	cp raster.com colorb.com /home/vince/dos/dos/

zip:	colorb.com
	zip

clean:	
	rm -f *~ *.o raster colorb
