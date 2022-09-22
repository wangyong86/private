#include <iostream>

using namespace std;

const char * a = "hello, the world";

int main(int argc, char * argv[])
{
    // correct, only assignment
    const int i = 10;
    int k = 10;

    // error, binding reference of type ‘int&’ to ‘const int’ discards qualifiers
    // int &j = i;

    // correct, const reference a const
    const int &j = i;

    // error, const reference can't be assgined new value;
    // j = k;

    // error, const reference can't be assgined any other value, include itself
    // j = i;

    // ok, add const to existed variable
    const int &l = k;

    cout << i << j << k << l << endl;

#if 0
    struct const_val *p = (struct const_val*) malloc (sizeof(struct const_val)); 
   
    /* expect compile error */ 
    p->func_map = a;

    *((const char **)&p->func_map) = a;
#endif
}
