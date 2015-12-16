
#
# Makefile for TINY
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc

CFLAGS = 

OBJS = main.o util.o scan.o parse.o

cminus_parser: $(OBJS)
	$(CC) $(CFLAGS) -g -o cminus_parser $(OBJS)

parse.o : parse.c globals.h
	$(CC) $(CFLAGS) -c parse.c

main.o: main.c globals.h util.h scan.h
	$(CC) $(CFLAGS) -c main.c

util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -c util.c

scan.o: scan.c scan.h util.h globals.h
	$(CC) $(CFLAGS) -c scan.c

clean:
	-rm tiny
	-rm tm
	-rm $(OBJS)

tm: tm.c
	$(CC) $(CFLAGS) tm.c -o tm

all: tiny tm

