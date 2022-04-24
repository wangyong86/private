#include <iostream>

using namespace std;

extern "C" {
typedef void (*fakefun)(void);

void func1() {
}

struct s{
	fakefun a;
	fakefun b;
	int c;
};

void func () {
	struct s s1 = {.a=func1, .b=func1, .c=10,};
	//struct s s1 = {.b=func1, .a=func1, .c=10,};
	printf(" %d\n", s1.c);
}
};

int main(int argc, char **argv) {
//	func();
	std::cout << "hello, the world" << std::endl;
}
