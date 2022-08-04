#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <dlfcn.h>

#include "testdso.h"

void print_usage(void)
{
    printf("Usage: main SO_PATH/n");
}

int main(int argc, char* argv[])
{
    if (2 != argc) {
        print_usage();
        exit(0);
    }
    
    const char* soname = argv[1];
    void *so_handle = dlopen(soname, RTLD_LAZY);
    if (!so_handle) {
        fprintf(stderr, "Error, load so %s failed, err: %s\n", soname, dlerror());
        exit(-1);
    }

    myadd_t *fn = (myadd_t*)dlsym(so_handle, "myadd"); // load
    char *err = dlerror();
    if (NULL != err) {
        fprintf(stderr, "%s\n", err);
        exit(-1);
    }

    printf("myadd 57 + 3 = %d\n", fn(57, 3));

    dlclose(so_handle);

    return 0;
}
