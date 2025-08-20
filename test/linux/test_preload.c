#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main()
{
	int fd = open("./test_preload.out", O_CREAT|O_RDWR);
	write(fd, "hello, the world", 20);
	close(fd);
}
