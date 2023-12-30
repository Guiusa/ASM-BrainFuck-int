#include "alloc.h"
#include "string.h"
#include <stdio.h>
int main (int argc, char** argv) {
	firstAlloc();
	
	char* a = (char *) allocBlk(9);
	a = "guiusepe\n";
	printStr(a);
	
	freeBlk(a);
	lastAlloc();
}
