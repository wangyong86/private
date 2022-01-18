#include <stdio.h>
int array[];
int main(int argc, char * argv[])
{
    int len = 4;
    array[0] = 1;
    array[2] = 1;
    array[3] = 1;
    array[1] = 1;
    for(int i = 0; i < len; i++)
    {
	printf("element %i is: %d\n" , i, array[i]);
    }
}
