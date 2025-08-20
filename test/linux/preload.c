/*
 * gcc -shared -fPIC -o libwrapper.so wrapper.c -ldl
 * LD_PRELOAD=./libwrapper.so ./your_binary
 */


#define _GNU_SOURCE
#include <dlfcn.h>
#include <time.h>
#include <stdio.h>

// 要拦截的函数原型
typedef int (*original_open_t)(const char *, int, ...);

int open(const char *pathname, int flags, ...) {
    // 获取原函数的地址
    original_open_t original_open;
    original_open = (original_open_t)dlsym(RTLD_NEXT, "open");

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    // 调用原函数
    int result = original_open(pathname, flags);

    clock_gettime(CLOCK_MONOTONIC, &end);
    long long elapsed = (end.tv_sec - start.tv_sec) * 1000000000LL + (end.tv_nsec - start.tv_nsec);
    printf("open(‘%s‘) took %lld ns\n", pathname, elapsed);

    return result;
}
