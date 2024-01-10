#include "alloc.h"
#include "io.h"
#include <stdio.h>

int main (int argc, char** argv) {
	firstAlloc();
	char* a = (char *) allocBlk(80);
	printf("%p\n", BUFF);
	printf("%p\n", a);

	int c = readStr(a, 10);
	printStr(a);

	freeBlk(a);
	lastAlloc();
	return c;
}
