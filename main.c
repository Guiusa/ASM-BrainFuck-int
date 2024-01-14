#include "alloc.h"
#include "io.h"

void showUsage(){
	printStr("ERROR: Incorrect number of arguments\nUSAGE: >~ bf <source_file_name>\n");
}

int main (int argc, char** argv) {
	int r = 0;
	if(argc != 2){
		showUsage();
		return 1;
	}
	firstAlloc();
	char* a = (char *) allocBlk(80);

	fd k = openFile(argv[1]);
	if (!k){
		printStr("Impossible to open file ");
		printStr(argv[1]);
		printStr("\n");
		r = 1;
		goto free_all;
	}
	
	int c = readStr(a, 80, k);	
	if (!c){
		printStr("Impossible to read stream from file\n");
		r = 2;
		goto free_all;
	}
	printStr(a);


	free_all:
	closeFile(k);
	freeBlk(a);
	lastAlloc();
	return r;
}
