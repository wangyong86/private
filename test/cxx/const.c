#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

struct const_val {
    const char *const func_map;
};

const char * a = "hello, the world";

int main(int argc, char * argv[])
{
    struct const_val *p = (struct const_val*) malloc (sizeof(struct const_val)); 
   
    /* expect compile error */ 
    p->func_map = a;

    *((const char **)&p->func_map) = a;
}
