#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/sysinfo.h>
#include <unistd.h>

#include <assert.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <fcntl.h>

#define MAXLEN 128

struct M_Data {
	long length;
	char statement[MAXLEN];
};

int main()
{
	//mmap unexist file
	const char* name = "testfile";
	
	int fd = open(name, O_RDWR | O_CREAT | O_TRUNC, S_IRWXU);
	if(fd < 0)
	{
		printf("open file :%s error: %d\n", name, errno);
		return 1;
	}

	void *addr = mmap(NULL, sizeof(struct M_Data), PROT_READ | PROT_WRITE,
					 MAP_SHARED, fd, 0);

	if (addr == MAP_FAILED)
	{
		printf("mmap file :%s error: %d\n", name, errno);
		return -1;
	}

	int rst = posix_fallocate(fd, 0, 1024);
	printf("result, %d\n", rst);

	struct M_Data *data = (struct M_Data*)addr;
	data->length = MAXLEN;
	sprintf(data->statement, "Hello, the World!\0");

	rst = munmap(addr, sizeof(struct M_Data));

	close(fd);
	fd = open(name, O_RDONLY);
	addr = mmap(NULL, sizeof(struct M_Data) + 100, PROT_READ, MAP_SHARED, fd, 0);
	data = (struct M_Data*)addr;
	printf("Size is: %d, contenxt: %s, unmap result, %d\n", data->length, data->statement, rst);

	// read beyond file tail
	data = (struct M_Data*)((char*)addr + sizeof(struct M_Data));
	printf("Size is: %d\n", data->length);
}
