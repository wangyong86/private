#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

struct const_val {
    const char *const func_map;
};

const int return_const() {
    return 10;
};

const int fixed = 10;

const int &return_const_ref() {
    return fixed;
};

const char * a = "hello, the world";

int main(int argc, char * argv[])
{
    // compile error?
    const int i = return_const();

    const int j = return_const_ref();

    cout << i << j << endl;

    struct const_val *p = (struct const_val*) malloc (sizeof(struct const_val)); 
   
    /* expect compile error */ 
    p->func_map = a;

    *((const char **)&p->func_map) = a;
}
