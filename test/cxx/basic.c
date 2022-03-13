#include <stdio.h>
#include <stdint.h>
int main(int argc, char * argv[])
{
    printf("args number is:%d\n", argc);
    for(int i = 0; i < argc; i++)
    {
	printf("args %i is: %s\n" , i, argv[i]);
    }
	
	uint64_t start = 7568097715378832;
	uint64_t end = 7568124279237732;
	uint64_t hz = 2300;
	hz*=1000*1000;
	uint64_t result = (end-start) * 1000 * 1000 / (hz/ 1000);
	printf("%ld\n", result);
}
