#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

void main(int argc, char **argv)
{
	if (argc != 2)
	{
		printf("must has a parameter which is errno\n");
		exit(1);
	}

	errno = atoi(argv[1]);
	printf("errno:%d ", errno);
	fflush(stdout);
	perror(NULL);
}
