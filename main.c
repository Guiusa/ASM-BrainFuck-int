#include "alloc.h"
#include "string.h"

int main (int argc, char** argv) {
	firstAlloc();
	
	char* a = "guiusepe2\n";
	printar(a);

	lastAlloc();
}
