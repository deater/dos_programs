CC = gcc
CFLAGS = -O2 -Wall

all:	convert_qkumba convert_tgreene LOADER.BAS LOADER2.BAS LOADER3.BAS QBASIC.BAS

convert_qkumba:	convert_qkumba.o
	$(CC) $(LFLAGS) -o convert_qkumba convert_qkumba.o

convert_qkumba.o:	convert_qkumba.c
	$(CC) $(CFLAGS) -c convert_qkumba.c

convert_tgreene:	convert_tgreene.o
	$(CC) $(LFLAGS) -o convert_tgreene convert_tgreene.o

convert_tgreene.o:	convert_tgreene.c
	$(CC) $(CFLAGS) -c convert_tgreene.c



install:	LOADER.BAS
	cp LOADER.BAS /home/vince/dos/dos

LOADER.BAS:	loader.bas
	todos < loader.bas > LOADER.BAS

LOADER2.BAS:	loader2.bas
	todos < loader2.bas > LOADER2.BAS

LOADER3.BAS:	loader3.bas
	todos < loader3.bas > LOADER3.BAS

QBASIC.BAS:	qbasic.bas
	todos < qbasic.bas > QBASIC.BAS

clean:
	rm -f *~ *.o convert_qkumba convert_tgreene

