CC = gcc
CFLAGS = -O2 -Wall

all:	convert_qkumba LOADER.BAS

convert_qkumba:	convert_qkumba.o
	$(CC) $(LFLAGS) -o convert_qkumba convert_qkumba.o

convert_qkumba.o:	convert_qkumba.c
	$(CC) $(CFLAGS) -c convert_qkumba.c


install:	LOADER.BAS
	cp LOADER.BAS /home/vince/dos/dos

LOADER.BAS:	loader.bas
	todos < loader.bas > LOADER.BAS

clean:
	rm -f *~ *.o convert_qkumba

