#include "alloc.h"
#include "io.h"

int main (int argc, char** argv) {
	firstAlloc();
	char* a = (char *) allocBlk(80);

	int c = readStr(a, 80);
	if(c){
		printStr(a);
	} else {
		printStr("a não foi lido com sucesso\n");
	}

	freeBlk(a);
	lastAlloc();
	return c;
}
