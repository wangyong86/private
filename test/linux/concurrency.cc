/*
 * MMap Usage:
 * 1) Extend file size before mmap, otherwise, data after real length is invisible;
 * 2) offset must be page alignment;
 * 3) you can mmap a file/segment multi-times, for concurrnet access;
 * 4) fd may be released once after mmap has been setup;
 * 5) Bus error usually related to unginment memory access. (NOT relevant)
 */

#include "IOUtils.h"

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

#include <thread>
#include <vector>

#define MAXLEN 128
#define PAGESIZE 4096 

using namespace std;
using namespace ioutils;

typedef struct MData {
	long length;
	char statement[MAXLEN];
} MData;

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

	void *addr = mmap(NULL, sizeof(MData), PROT_READ | PROT_WRITE,
					 MAP_SHARED, fd, 0);

	if (addr == MAP_FAILED)
	{
		printf("mmap file :%s error: %d\n", name, errno);
		return -1;
	}

	int rst = posix_fallocate(fd, 0, 1024);
	printf("result, %d\n", rst);

	MData *data = (MData*)addr;
	data->length = MAXLEN;
	sprintf(data->statement, "Hello, the World!\0");

	rst = munmap(addr, sizeof(MData));

	close(fd);
	fd = open(name, O_RDONLY);
	addr = mmap(NULL, sizeof(MData) + 100, PROT_READ, MAP_SHARED, fd, 0);
	data = (MData*)addr;
	printf("Size is: %d, contenxt: %s, unmap result, %d\n", data->length, data->statement, rst);

	int length = sizeof(MData) + 200;
	void* addr1 = mmap(NULL, length, PROT_READ, MAP_SHARED, fd, 0);
	if (addr1 == MAP_FAILED)
	{
		printf("repeated mmap file will fail, filename: %s error: %d\n", name, errno);
		return -1;
	} else {
		printf("repeated mmap file will suceed, length is: %d filename: %s error: %d\n", length, name, errno);
		data = (MData*)addr1;
		printf("Size is: %d, contenxt: %s, unmap result, %d\n", data->length, data->statement, rst);
	}

	// read beyond file tail
	data = (MData*)((char*)addr + sizeof(MData));
	printf("Size is: %d\n", data->length);

	length = sizeof(MData) + 200;
	addr1 = mmap(NULL, length, PROT_READ, MAP_SHARED, fd, 12);
	if (addr1 == MAP_FAILED)
	{
		printf("mmap file without page alignment will fail, offset: %d, error should be 22, real is: %d\n", 12, errno);
		return -1;
	} else {
		printf("mmap file without page alignment will succeed, offset: %d\n", 12);
	}
}

void
ThreadRunner(TaskStruct *task, int threadsn, IOStatistics *stat, PerfTester *tester)
{ 
	// open file;
	const char* dir = "/home/wy/matrixdb/contrib/mars3/moduletest/data/mars3_100_";
	const int filenr = 10;
	int sn = std::rand() % 10 + 1;
	
	char filename[1024];
	snprintf(filename, 1024, "%s%d.dat");

		
	// mmap loop;
}

using ThreadFunc = std::function<void(int)>;

void Test(int threads)
{
	using namespace std::placeholders;

	vector<std::thread *> threads;
	for (int thdsn = 1; thdsn <= threadnr; thdsn++) {
		TaskStruct *task = tasks[thdsn - 1];
		ThreadFunc runner = std::bind(ThreadRunner, _1);
		std::thread *thd = new std::thread(runner, thdsn);
		threads.push_back(thd);
	}

	for (int thdsn = 1; thdsn <= threadnr; thdsn++) {
		threads[thdsn - 1]->join();
	}
}

int main() 
{
	Test(100);
}
