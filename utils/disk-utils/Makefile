CC = gcc
CFLAGS = -O2 -Wall -g

all:	mkwad

###

mkwad:		mkwad.o
	$(CC) -o mkwad mkwad.o $(LFLAGS)

mkwad.o:		mkwad.c
	$(CC) $(CFLAGS) -c mkwad.c


#install:	
#	cp pcx2cga mkwad cga2png $(INSTALL_LOC)

clean:		
	rm -f *~ *.o pcx2cga mkwad

