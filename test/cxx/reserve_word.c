#include <stdio.h>
#include <stdint.h>

// below function has compliling error
// To C, reserved word and keyword can't be used as name,
// but Go's reserved word can
void TestReservedWord()
{
	int NULL = 100;
	int b = NULL * 100;
	printf("NULL is a reserved word, but can used as a name, result is: %d\n", b);
}

int main(int argc, char * argv[])
{
    TestReservedWord();
    return 0;
}

