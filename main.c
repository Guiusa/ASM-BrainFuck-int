#include "alloc.h"
#include "io.h"
#include <stdio.h>

int main (int argc, char** argv) {
	firstAlloc();
	
	char* a = (char *) allocBlk(100);
	readStr(a, 100);
	
	freeBlk(a);
	lastAlloc();
}
