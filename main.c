#include "alloc.h"
#include "io.h"
#define ENTRY_SIZE 5000

void showUsage(){
	printStr("ERROR: Incorrect number of arguments\nUSAGE: >~ bf <source_file_name>\n");
}

int main (int argc, char** argv) {
	firstAlloc();
	char* a = (char *) allocBlk(ENTRY_SIZE);
	int r = 0;
	fd k;

	if(argc > 2){
		showUsage();
		return 1;
	} else if(argc == 2) {
		k = openFile(argv[1]);
		if (!k){
			printStr("Impossible to open file ");
			printStr(argv[1]);
			printStr("\n");
			r = 1;
			goto free_all;
		}
		if (!readStr(a, ENTRY_SIZE, k)){
			printStr("Impossible to read stream from file\n");
			r = 2;
			goto free_all;
		}
	} else readStr(a, ENTRY_SIZE, stdin);
	
	printStr(a);


	free_all:
	if(k) closeFile(k);
	freeBlk(a);
	lastAlloc();
	return r;
}
