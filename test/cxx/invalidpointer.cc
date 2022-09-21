#include <iostream>

int main()
{
    // modify const will core
    char *p = "abc";
    *p = 0;

    // modify invalid address will core
    char *q = 0;
    *q = 0;
}

