#include <stdio.h>
#include <stdlib.h>

int main() {
#if defined(WARN)
    printf("hello, is hell\n");
#endif

#if WARN
    printf("hello, is hello\n");
#endif
}
