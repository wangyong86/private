#include <stdio.h>

typedef void (*fakefun)(void);

void func1() {
}

struct s{
	fakefun a;
	fakefun b;
	int c;
};

void func () {
	struct s s1 = {.b=func1, .a=func1, .c=10,};
	printf(" %d\n", s1.c);
}

int main(int argc, char **argv) {
	func();
}
