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

#define concate_impl(x, y) x##y
#define concate(x, y) concate_impl(x, y)

void Test()
{
	printf("if defined TEST macro in command line, you will not see this message\n");
}

int main(int argc, char * argv[])
{
	LOG(1, LOG, "int: %d", 10);

	MxAssertVar(0, "hello, the workld");
	MxAssertVar(0, "hello, the workld: %d", 10);

	int concate(offset, __LINE__) = 100, b = concate(offset, __LINE__);
	printf("%d\n", b);

	int concate_impl(offset, __LINE__) = 1000;
	printf("%d\n", concate_impl(offset, __LINE__));

#ifndef TEST
Test();
#endif
}
