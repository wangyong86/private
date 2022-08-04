#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#define MxAssertVar(cond, fmt, ...)                     \
    if (!(cond)) {                                      \
        printf("Cond:(%s) file:%s line:%d " fmt "\n",        \
               #cond, __FILE__, __LINE__, ##__VA_ARGS__); \
    }

#define Mars3Assert MxAssert
#define Mars3AssertVar MxAssertVar

#define LOG(cond, level, fmt, ...)                     \
    if (cond) \
        fprintf(stderr, #level": " fmt "\n", __VA_ARGS__);

#define hehe(x,y) wx##y


int main(int argc, char * argv[])
{
	LOG(1, LOG, "int: %d", 10);

	MxAssertVar(0, "hello, the workld");
	MxAssertVar(0, "hello, the workld: %d", 10);
}
