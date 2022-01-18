#include <stdio.h>
int main(int argc, char * argv[])
{
    printf("args number is:%d\n", argc);
    for(int i = 0; i < argc; i++)
    {
	printf("args %i is: %s\n" , i, argv[i]);
    }
}
