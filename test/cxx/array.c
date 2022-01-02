#include <stdio.h>
int mock_pipe(int fd[2])
{
	fd[0]=1;
	fd[1]=2;
	return 0;
}

int main(int argc, char* argv[])
{
	int fds[2]={0,0};
	mock_pipe(fds);
	printf("Original:%d;After call func, value is:%d\n", 0, fds[1]);
	return 0;
}
