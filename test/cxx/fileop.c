#include <stdio.h>
#include <stdlib.h>
#include <sys/sysinfo.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// read /proc file is recommendated way to obtain system parameter
const char *omfile = "/proc/sys/vm/overcommit_memory";
const char *omratio = "/proc/sys/vm/overcommit_ratio";

#define MAXLEN 100

// getenv, from stdlib
void getpath()
{
	printf("system path is: %s\n", getenv("PATH"));
}

typedef struct vm {
	int config;
	int ratio; // percentage	
}vm;

int readint(const char* filename, int *value)
{
	int fd = 0;
	char buffer[MAXLEN];

	// O_RDONLY, O_WRONLY, O_RDWR
	// O_APPEND, O_APPEND, O_ASYNC, O_SYNC, O_CREAT, O_CLOEXEC, O_DIRECT
	// O_LARGEFILE, O_NOATIME
	if ((fd = open(omfile, O_RDONLY)) < 0)
	{
		printf("open file %s failed, error is: %d\n", fd);
		return -1;
	}

	// max 10 chars
	int count = pread(fd, buffer, 10, 0);
	if (count <= 0)
	{
		printf("read file %s failed, is empty\n");
		close(fd);
		return -1;
	}

	buffer[count] = 0;
	*value = atoi(buffer);
	close(fd);

	return 0;
}
 
int readmemconf(vm *v)
{
	int rst1 = readint(omfile, &v->config);
	int rst2 = readint(omratio, &v->ratio);
	return rst1 < 0 ? rst1 : rst2;
}

int malloc_test_once(size_t size)
{
	char * p = (char *) malloc (size);
	if (p != NULL)
		printf("malloc half memory %ld is successful\n", size);
	else
		printf("malloc half memory %ld is failed\n", size);
	free(p);
	return p ? 0 : -1;
}

int malloc_test(size_t size)
{
	long s = size;
	while(1)
	{
		if (malloc_test_once(s) < 0)
			s /= 2;
		else
			return 1;
	}
}

int main()
{
	struct sysinfo info;
	vm conf;
	int rst = 0;
	if (rst = sysinfo(&info))
	{
		printf("get system info fail, error=%d\n", rst);
		return -1;
	}

	// malloc
	printf("all system memory is: %ld bytes\n", info.totalram);
	if (readmemconf(&conf) < 0)
		return -1;

	// only malloc half of physical memory	
	size_t size = info.totalram * conf.ratio / conf.config;
	malloc_test(size);
		
	getpath();
}
