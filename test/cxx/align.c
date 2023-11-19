/*
 * This test show gcc with x86-64 can access data of non-cache line aligned
 * style
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void nonalign_access()
{
	char * p = (char *)malloc(100);
	long int addr = (long int)p;
	addr = ((addr + 63) / 64 ) * 64 + 62;
	char * q = (char *)addr;

	int m = *(int *)q;
	printf("non-aligned int access is ok? %d, addr is %x, malloc addr:%x\n",
		   m, q, p);
}


int main(int argc, char * argv[])
{
	nonalign_access();
}

