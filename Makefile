CC = gcc
CFLAGS = -g -Wall -no-pie
PROG = bf

all: $(PROG)

test: test.o alloc.o io.o interpreter.o
	$(CC) $(CFLAGS) -o test test.o alloc.o io.o interpreter.o

test.o: test.c
	$(CC) $(CFLAGS) -c test.c -o test.o

$(PROG): main.o alloc.o io.o interpreter.o
	$(CC) $(CFLAGS) -o $(PROG) main.o alloc.o io.o interpreter.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

alloc.o: alloc.s
	as alloc.s -o alloc.o -g

io.o: io.s
	as io.s -o io.o -g

interpreter.o: interpreter.s
	as interpreter.s -o interpreter.o -g

purge:
	rm -rf *.o  $(PROG) test
