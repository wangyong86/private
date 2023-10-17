#include <stdio.h>
#include <stdint.h>

float fv = 1123;
int iv = 100;
char *cv = "hello, this world";

void flag_test()
{
    printf("value is 100 display: %#o\n", iv);
    printf("value is 100 display: %#X\n", iv);
    printf("value is 100 display: %#x\n", iv);
    printf("value is 100 display: %''d\n", iv);
    printf("value is 100 display: %'ld\n", 100000000);
    printf("value is %f display: %0f\n", fv, fv);
}


int main(int argc, char * argv[])
{
	//format_test();
	flag_test();
}

