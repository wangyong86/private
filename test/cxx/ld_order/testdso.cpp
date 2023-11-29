#include "testdso.h"

extern "C" {
int add_local(int a, int b)
{
	return a + b;
}

int myadd(int a, int b)
{
    return add_local(a, b);
}
}
