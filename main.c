#include "alloc.h"
#include "io.h"
#define ENTRY_SIZE 5000
#define STRIP_SIZE 10000

void showUsage(){
	printStr("ERROR: Incorrect number of arguments\nUSAGE: >~ bf <source_file_name>\n");
}

int main (int argc, char** argv) {
	firstAlloc();
	char* file = (char *) allocBlk(ENTRY_SIZE);
	int r = 0;
	fd file_p;
// tries to read file in argv[1], then read from stdin #########################
	if(argc > 2){
		showUsage();
		return 1;
	} else if(argc == 2) {
		file_p = openFile(argv[1]);
		if (!file_p){
			printStr("Impossible to open file ");
			printStr(argv[1]);
			printStr("\n");
			r = 1;
			goto free_all;
		}
		if (!readStr(file, ENTRY_SIZE, file_p)){
			printStr("Impossible to read stream from file\n");
			r = 2;
			goto free_all;
		}
	} else readStr(file, ENTRY_SIZE, stdin);
//##############################################################################

	char* strip = (char *) allocBlk(STRIP_SIZE);
	char* print_buff = (char *) allocBlk(100);
	


	free_all:
	if(strip) freeBlk(strip);
	if(file_p) closeFile(file_p);
	freeBlk(file);
	lastAlloc();
	return r;
}
