#include <stdio.h>
#include <stdlib.h>
#include <sys/sysinfo.h>
#include <unistd.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

/*
	1:) excessive memory usage(like memset) will squeeze system memory, evict
		page cache/buffer, etc.
	2:) furthermore, swap space will be used;
	3:) oom will killer dominant memory user
 */

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
	if ((fd = open(filename, O_RDONLY)) < 0)
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
	printf("filename:%s str:%s value:%d, strsize:%d\n", filename, buffer, *value, count);
	close(fd);

	return 0;
}
 
int readmemconf(vm *v)
{
	int rst1 = readint(omfile, &v->config);
	int rst2 = readint(omratio, &v->ratio);
	return rst1 < 0 ? rst1 : rst2;
}

int main()
{
	struct sysinfo info;
	vm conf = {2, 95};
	int rst = 0;
	if (rst = sysinfo(&info))
	{
		printf("get system info fail, error=%d\n", rst);
		return -1;
	}

	readmemconf(&conf);
	printf("Overcommit setting: level: %d ratio: %d\n", conf.config, conf.ratio);

	// malloc memory exceed physical value
	size_t size = info.totalram * 1.5;
	char *p = (char *) malloc(size);
	if (!p)
	{
		printf("Can't malloc size, size: %zu\n", size);
		return -1;
	}
	
	printf("malloc size: %zu MB\n", size / 1024 / 1024);
	

	memset(p, 0, size);
}
