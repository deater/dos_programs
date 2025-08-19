CC = gcc
CFLAGS = -O2 -Wall -g

all:	bin2pas

###

bin2pas:		bin2pas.o
			$(CC) -o bin2pas bin2pas.o $(LFLAGS) -lpng

bin2pas.o:		bin2pas.c
			$(CC) $(CFLAGS) -c bin2pas.c

#install:	
#		cp pcx2cga bin2pas cga2png $(INSTALL_LOC)

clean:		
		rm -f *~ *.o bin2pas

