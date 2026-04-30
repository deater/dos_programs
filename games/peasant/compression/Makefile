CC = gcc
STRIP = strip
CFLAGS = -O2 -Wall

C_EXTRA = --32
L_EXTRA = -melf_i386


all:	zx02.i386
#  zx02.i8086

###

zx02.i8086:	zx02.i8086.o
	$(CROSS)$(LD) $(L_EXTRA) -o zx02.i8086 zx02.i8086.o

zx02.i8086.o:	zx02.i8086.s
	$(CROSS)$(AS) $(C_EXTRA) -o zx02.i8086.o zx02.i8086.s

###

zx02.i386:	zx02.i386.o
	$(CROSS)$(LD) $(L_EXTRA) -o zx02.i386 zx02.i386.o

zx02.i386.o:	zx02.i386.s
	$(CROSS)$(AS) $(C_EXTRA) -o zx02.i386.o zx02.i386.s

####

clean:
	rm -f zx02.i386 *.o *~



