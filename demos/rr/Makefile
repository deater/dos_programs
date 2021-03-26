CC = gcc
STRIP = strip
CFLAGS = -O2 -Wall

all:	rr.com

###

rr.com:		rr.o.o
	dd if=rr.o.o of=rr.com bs=256 skip=1

rr.o.o:		rr.o
	objcopy -O binary rr.o rr.o.o

rr.o:		rr.s
	as --32 -R -o rr.o rr.s

###

install:	rr.com
	cp rr.com /home/vince/dos/dos/

zip:	rr.com
	zip

clean:	
	rm -f *~ *.o *.com

