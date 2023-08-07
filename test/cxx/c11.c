// Program Exit:
// 1) uncatched exception --> termiate --> abort()
// 2) exit(). all created object will be destruct and registered hook will be
//    called in reverse order;
// 3) quick_exit(). From c++11, terminate program without destruct object. But
//	  registered quick exit func will be called.

#include <stdio.h>
#include <stdlib.h>

void f1()
{
	puts("pushed first");
	fflush(stdout);
}

void f2()
{
	puts("pushed second");
	fflush(stdout);
}

_Noreturn void test_quick_exit()
{
	printf("quick_exit enabled\n");
	quick_exit(-1);
}

int main()
{
	at_quick_exit(f1);
	at_quick_exit(f2);
	test_quick_exit();
}
