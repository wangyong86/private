#include "testdso.h"

extern "C" {
int myadd(int a, int b)
{
    return a + b;
}
}
