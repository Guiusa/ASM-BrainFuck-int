CC = gcc
CFLAGS = -g -Wall -no-pie -g
PROG = bf

all: $(PROG)

$(PROG): main.o alloc.o string.o
	$(CC) $(CFLAGS) -o $(PROG) main.o alloc.o string.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

alloc.o: alloc.s
	as alloc.s -o alloc.o -g

string.o: string.s
	as string.s -o string.o -g

purge:
	rm -rf *.o  $(PROG)
