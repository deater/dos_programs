CC = gcc
STRIP = strip
CFLAGS = -O2 -Wall

all:	rr.com	rr_256.com rr_small.com rr_tiny.com waitfor.com


###

waitfor.com:	waitfor.asm
	nasm waitfor.asm -fbin -o waitfor.com

###

rr_256.com:	rr_256.asm
	nasm rr_256.asm -fbin -o rr_256.com

###

rr_small.com:	rr_small.asm
	nasm rr_small.asm -fbin -o rr_small.com

###

rr_tiny.com:	rr_tiny.asm
	nasm rr_tiny.asm -fbin -o rr_tiny.com

###

rr.com:		rr.o.o
	dd if=rr.o.o of=rr.com bs=256 skip=1

rr.o.o:		rr.o
	objcopy -O binary rr.o rr.o.o

rr.o:		rr.s
	as --32 -R -o rr.o rr.s

###

install:	rr.com rr_small.com rr_tiny.com
	cp rr.com /home/vince/dos/dos/
	cp rr_small.com /home/vince/dos/dos/
	cp rr_tiny.com /home/vince/dos/dos/

zip:	rr.com
	zip

clean:	
	rm -f *~ *.o *.com

submit:	waitforit256.zip

waitforit256.zip:	waitfor.com README file_id.diz
	mkdir -p waitforit256
	cp waitfor.com ./waitforit256
	cp waitfor.asm ./waitforit256
	cp README ./waitforit256
	cp file_id.diz ./waitforit256
	cp wait_for_it.jpg ./waitforit256
	cp dosbox-0.74-3.conf ./waitforit256
	cp youtube.url.txt ./waitforit256
	zip -r waitforit256.zip waitforit256
