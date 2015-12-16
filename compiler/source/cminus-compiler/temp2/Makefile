#
# Makefile for TINY
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc

CFLAGS = 

OBJS = main.o util.o scan.o

cminus_yacc: main.o  util.o lex.yy.o y.tab.c
	$(CC) $(CFLAGS) main.o util.o lex.yy.o y.tab.c -g -o cminus_yacc -lfl


cminus_flex: main.o util.o lex.yy.o
	$(CC) $(CFLAGS) main.o util.o lex.yy.o -o cminus_flex -lfl

lex.yy.o: tiny.l scan.h util.h globals.h
	flex -o lex.yy.c tiny.l
	$(CC) $(CFLAGS) -c lex.yy.c -lfl
parse.o : parse.c
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

