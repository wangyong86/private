/*-------------------------------------------------------------------------
 *
 * FileUtils.h
 *	  Wrapper for Local File Operations
 *
 *
 * Copyright (c) 2021-Present yMatrix, Inc.
 *
 *
 *-------------------------------------------------------------------------
 */
#pragma once

#include <cstddef>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define BytesInKB 1024
#define BytesInMB (BytesInKB * 1024)
#define BytesInGB (BytesInMB * 1024)
#define BytesInTB (BytesInGB * 1024)
#define BytesInEB (BytesInTB * 1024)

namespace ioutils {

extern int MmapSyncMode;

// TODO(wy): read from specific filesystem
const size_t kPageSize = 4096;

int MxOpen(const char *pathname, int flags, mode_t mode = S_IRWXU);

int MxClose(int fd);

int MxRemove(const char *pathname);

ssize_t MxPread(int fd, void *buf, size_t count, off_t offset);

ssize_t MxPWrite(int fd, const void *buf, size_t count, off_t offset);

int MxMsync(void *addr, off_t len, int flags);

int MxStat(const char *pathname, struct stat *buf);

int MxFStat(int fd, struct stat *buf);

/*!
 * In accordance to posix_fallocate: returns zero on success, or an error
 * number on failure.
 */
int MxFallocate(int fd, off_t offset, off_t len);

void *MxMmap(void *addr, size_t length, int prot, int flags,
                  int fd, off_t offset);

int MxMunmap(void *addr, size_t length);

int64_t MxGetFileLength(int fd);

bool MxFileExist(const char *pathname);

} // namespace ioutils
