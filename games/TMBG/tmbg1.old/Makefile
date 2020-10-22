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
C_OPTS =
L_OPTS = -lj -lvga -lvgagl

######################################################################
#         THERE IS NO NEED TO EDIT ANYTHING BELOW THIS LINE          #
######################################################################

all:	tmbg1

clean:
	rm -f *.o

tmbg1:	tmbg1.o svmwgraph.o
	$(CC) $(C_OPTS) -o tmbg1 tmbg1.o svmwgraph.o $(L_OPTS)

tmbg1.o:	tmbg1.c svmwgraph.h
	$(CC) $(C_OPTS) -c tmbg1.c  

svmwgraph.o:	svmwgraph.c svmwgraph.h
	$(CC) $(C_OPTS) -c svmwgraph.c
