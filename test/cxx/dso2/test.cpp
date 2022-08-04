#include <cerrno>
#include <cstdio>
#include <cstdlib>

#include "testdso.h"

void print_usage(void)
{
    printf("Usage: main SO_PATH/n");
}

int main(int argc, char* argv[])
{
    int rst = myadd(57, 3);

    printf("57 + 3 = %d\n", rst);

    return 0;
}
