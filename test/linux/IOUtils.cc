/*-------------------------------------------------------------------------
 *
 * FileUtils.cc
 *	  Wrapper for Local File Operations
 *
 *
 * Copyright (c) 2021-Present yMatrix, Inc.
 *
 * TODO: refine error handing
 *
 *-------------------------------------------------------------------------
 */
#include "IOUtils.h"

#include <cassert>
#include <cerrno>
#include <cstring>

#include <fcntl.h>
#include <sys/mman.h>

namespace ioutils {

static const int kMaxRetryNum = 3;
static const int kSleepTimeInUsec = 100;

// Assert wrapper
#define MxAssertVar(cond, fmt, ...) \
    if (!(cond)) \
    {\
        printf("Cond:(%s) file:%s line:%d " fmt, \
                #cond, __FILE__, __LINE__, __VA_ARGS__);\
        assert(cond); \
    }

#define MxAssert(cond, msg) \
    if (!(cond)) \
    {\
        printf("Cond:(%s) file:%s line:%d: msg:%s\n", \
                #cond, __FILE__, __LINE__, msg);\
        assert(cond); \
    }

#define MxALIGN_LOWER(item, align) (((item) / (align)) * (align))
#define MxALIGN(item, align) ((((item) + (align) - 1) / (align)) * (align))

ssize_t
MxPread(int fd, void *buf, size_t count, off_t offset)
{
	ssize_t finish = count;

	while (count > 0) {
		int ret = pread(fd, buf, count, offset);
		if (ret == -1) {
		 	if (errno == EINTR || errno == EAGAIN) {
				usleep(kSleepTimeInUsec);
				continue;
			}
			else
				return -1;
		}
		
		count -= ret;
		if (ret > 0 && count > 0) {
			offset += ret;
			buf = (void *)((char*) buf + ret);
		}
	}

	return finish;	
}

ssize_t
MxPWrite(int fd, const void *buf, size_t count, off_t offset)
{
	ssize_t written = count;

	while (count > 0) {
		int ret = pwrite(fd, buf, count, offset);
		if (ret == -1) {
		 	if (errno == EINTR || errno == EAGAIN) {
				usleep(kSleepTimeInUsec);
				continue;
			}
			else
				return -1;
		}
		
		count -= ret;
		if (ret > 0 && count > 0) {
			offset += ret;
			buf = (void *)((char*) buf + ret);
		}
	}

	return written;	
}

int
MxFallocate(int fd, off_t offset, off_t len)
{
#if defined(__linux__)
	return posix_fallocate(fd, offset, len);
#else

	MxAssert(offset % kPageSize == 0, "offset must be page-aligned");
	MxAssert(len % kPageSize == 0, "length must be page-aligned");

	int length = len;
	size_t pos = offset; 
	int ret = 0;
	char buffer[kPageSize];
	memset(buffer, 0, kPageSize);

	while (length > 0) {
		ret = MxPWrite(fd, buffer, pos, kPageSize);
		if (ret >= 0) {
			length -= kPageSize;
			pos += kPageSize;
		} else
			break;
	}

	return ret > 0 ? 0 : errno;
#endif
}

int
MxMsync(void *addr, off_t len, int flags)
{
	int ret = 0;

	while (true) {
		ret = msync(addr, len, flags);
		if (ret == 0)
			break;

		if (ret == -1 && !(errno == EBUSY || errno == EINTR))
			break;

		usleep(kSleepTimeInUsec);
	}

	if (ret == -1 && (errno == EINVAL || ret == ENOMEM))
		MxAssertVar(false, "Msync failed, errno: %d", errno);

	return ret;
}

int
MxFStat(int fd, struct stat *buf)
{
	int ret = 0;

	while (true) {
		ret = fstat(fd, buf);
		if (ret < 0 && errno == EINTR) {
			usleep(kSleepTimeInUsec);
			continue;
		} else
			break;
	}

	return ret == 0 ? 0 : -errno;
}

int
MxStat(const char *pathname, struct stat *buf)
{
	int ret = 0;

	while (true) {
		ret = stat(pathname, buf);
		if (ret < 0 && errno == EINTR) {
			usleep(kSleepTimeInUsec);
			continue;
		} else
			break;
	}

	return ret == 0 ? 0 : -errno;
}

int64_t
MxGetFileLength(int fd)
{
	struct stat st;
	int ret = MxFStat(fd, &st);
	if (ret >= 0)
		return st.st_size;
	else
		return ret;
}

bool
MxFileExist(const char *pathname)
{
	struct stat st;
	int ret = MxStat(pathname, &st);
	return (ret == 0);
}

int
MxOpen(const char *pathname, int flags, mode_t mode)
{
	int fd = 0;

	while (true) {
		fd = open(pathname, flags, mode);
		if (fd < 0 && errno == EINTR) {
			usleep(kSleepTimeInUsec);
			continue;
		} else {
			break;
		}
	}

	return fd < 0 ? -errno : fd;
}

int
MxClose(int fd)
{
	int ret = 0;

	while (true) {
		ret = close(fd);
		if (ret < 0 && errno == EINTR) {
			usleep(kSleepTimeInUsec);
			continue;
		} else {
			break;
		}
	}
	
	return ret;
}

void *
MxMmap(void *addr, size_t length, int prot, int flags,
                  int fd, off_t offset)
{
	void *ret = MAP_FAILED;
	int retrytimes = kMaxRetryNum;

	while (retrytimes -- > 0) {
		ret = mmap(addr, length, prot, flags, fd, offset);
		if (ret == MAP_FAILED && errno == EAGAIN) {
			usleep(kSleepTimeInUsec);
			continue;
		}
	}

	return ret;
}

int
MxMunmap(void *addr, size_t length)
{
	int ret = -1;
	int retrytimes = kMaxRetryNum;

	while (retrytimes -- > 0) {
		ret = munmap(addr, length);
		if (ret == -1 && errno == EAGAIN) {
			usleep(kSleepTimeInUsec);
			continue;
		}
	}

	assert(ret == 0);
	return ret;
}

int
MxRemove(const char *pathname)
{
	return remove(pathname);
}

} // namespace ioutils
