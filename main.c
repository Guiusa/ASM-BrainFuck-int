#include "alloc.h"
#include "io.h"

int main (int argc, char** argv) {
	firstAlloc();
	
	char* a = (char *) allocBlk(100);
	readStr(a, 100);
	printStr(a);

	freeBlk(a);
	lastAlloc();
}
