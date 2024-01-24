#include "interpreter.h"

int main() {
	int a;
	a = 25;
	push(&a);
	int b;
	b = *(pop());

	return b;
}
