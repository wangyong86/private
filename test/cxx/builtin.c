#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, char * argv[])
{
    int i1 = 8;
    short i2 = 8;
    printf("first index of __builtin_ffs(int 4), %d\n", __builtin_ffs(i1));
    printf("first index of __builtin_ffs(short 4), %d\n", __builtin_ffs(i2));
}
