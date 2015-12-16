#
# Makefile for TINY
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc

CFLAGS = 

OBJS = main.o util.o scan.o parse.o analyze.o symtab.o cgen.o code.o

cminus: $(OBJS)
	$(CC) -o cminus  $(OBJS) 

parse.o : parse.c parse.h globals.h
	$(CC) $(CFLAGS) -g -c parse.c

cgen.o : cgen.c symtab.h code.h cgen.h
	$(CC) $(CFLAGS) -g -c cgen.c

code.o : code.c globals.h code.h
	$(CC) $(CFLAGS) -g -c code.c

symtab.o : symtab.c globals.h symtab.h
	$(CC) $(CFLAGS) -g -c symtab.c

analyze.o : analyze.c analyze.h globals.h symtab.h
	$(CC) $(CFLAGS) -g -c analyze.c
	
main.o: main.c globals.h util.h scan.h
	$(CC) $(CFLAGS) -g -c main.c

util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -g -c util.c

scan.o: scan.c scan.h util.h globals.h
	$(CC) $(CFLAGS) -c scan.c

clean:
	-rm tiny
	-rm tm
	-rm $(OBJS)

tm: tm.c
	$(CC) $(CFLAGS) tm.c -o tm

all: tiny tm

