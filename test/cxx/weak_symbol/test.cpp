/*
 * This binary test link order to verify symbol visibility:
 * symbol in .o will be prefered
 * symbol in .so will be prefered by link order
 * 
 * conjecture:
 *  symbol in the same so will be used in high priority
 */
 #include <stdio.h>
#include "inner.h"

extern "C" {
int add_local(int a, int b)
{
	return a + b;
}
}

int main(int argc, char *argv[])
{
	int rst = add_local(10, 20);
	printf("result is: %d\n", rst);
}
