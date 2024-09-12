#include <iostream>

using namespace std;

// const idicates a variable can't be change, a[0] = 'c' is forbidden
const char *a = "hello, the world";

/*============constexpr============*/
// it's also a const, it's redundant generally
constexpr int v_i1 = 100 * 10000;

// it's also okay, this a const, const also can be 
constexpr const int c_i1 = 100 * 1000;

// But for string, without const, report:
// warning: ISO C++ forbids converting a string constant to ‘char*’ [-Wwrite-strings]
constexpr const char *b = "hello";

// mixed with static
constexpr static const int sc_i1 = 100 * 1000;

class constexpr_ctor {
  public:
	constexpr constexpr_ctor(int d_)
		: d(d_)
	{}

  public:
	int d; 
};
/*=================================*/

int main(int argc, char * argv[])
{
    // correct, only assignment
    const int i = 10;
    int k = 10;

    // error, binding reference of type ‘int&’ to ‘const int’ discards qualifiers
    // int &j = i;

    // correct, const reference a const
    const int &j = i;

	// it's a variable, assignment is wrong
	// v_i1 = 10;

    // error, const reference can't be assgined new value;
    // j = k;

    // error, const reference can't be assgined any other value, include itself
    // j = i;

    // ok, add const to existed variable
    const int &l = k;

    cout << i << j << k << l << endl;

	constexpr constexpr_ctor t(10);

	cout << "const:" << c_i1 << " constexpr var:" << v_i1 << " constexpr static const:"
		 << sc_i1 << " constexpr obj variable:" << 10 << b << endl;
#if 0
    struct const_val *p = (struct const_val*) malloc (sizeof(struct const_val)); 
   
    /* expect compile error */ 
    p->func_map = a;

    *((const char **)&p->func_map) = a;
#endif
}
