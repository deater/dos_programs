##############################################################
#  Makefile for They Might Be Game  -- by Vince Weaver       #
#                                                            #
#  Written on Linux 2.1.35                                   #
#                                                            #
#  To modify for your configuration, add or remove the #     #
#                                                            #
##############################################################

#Your compiler.  If gcc doesn't work, try CC
CC = gcc
#CC = cc

#For Linux
#
C_OPTS = -Wall
L_OPTS = -lj -lvga 

#For X/Unix
#C_OPTS =
#L_OPTS = -L/usr/X11R6/lib -lxj -lX11

#For DJGPP
#C_OPTS =
#L_OPTS = -lj


######################################################################
#         THERE IS NO NEED TO EDIT ANYTHING BELOW THIS LINE          #
######################################################################

all:	tmbg1

clean:
	rm -f *.o
	rm -f tmbg1
	
tmbg1:	tmbg1.o svmwgrph.o play.o
	$(CC) $(C_OPTS) -o tmbg1 tmbg1.o svmwgrph.o play.o $(L_OPTS)

tmbg1.o:	tmbg1.c svmwgrph.h
	$(CC) $(C_OPTS) -c tmbg1.c  

svmwgrph.o:	svmwgrph.c svmwgrph.h
	$(CC) $(C_OPTS) -c svmwgrph.c

play.o:	play.c
	$(CC) $(C_OPTS) -c play.c
