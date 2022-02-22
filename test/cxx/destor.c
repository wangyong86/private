#include <stdio.h>
#include <stdlib.h>

void func1(void);
void func2(void);

int main() {
	atexit(func1);
	atexit(func2);
}

void func1(void) {
	printf("Func1 is exiting...\n");
}

void func2(void) {
	printf("Func2 is exiting...\n");
}
