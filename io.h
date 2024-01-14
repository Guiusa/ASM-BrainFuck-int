#define fd int
#define stdin 0
#define stdout 1

extern char BUFF[100];
int readStr(char* str, int s, fd fdesc);
void printStr(char* s); 
fd openFile(char* fileName);
void closeFile(fd fDesc);
