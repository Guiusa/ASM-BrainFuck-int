CC = gcc
CFLAGS = -g -Wall -no-pie -g
PROG = bf

all: $(PROG)

$(PROG): main.o alloc.o io.o
	$(CC) $(CFLAGS) -o $(PROG) main.o alloc.o io.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

alloc.o: alloc.s
	as alloc.s -o alloc.o -g

io.o: io.s
	as io.s -o io.o -g

purge:
	rm -rf *.o  $(PROG)
