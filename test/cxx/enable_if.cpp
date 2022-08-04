#include "template.h"
#include <type_traits>

using namespace std;
using namespace myspace;

template <int id>
class check{
    public:
        template <int x = id>
        static typename std::enable_if<x==10>::type
        check1() { std::cout << id << std::endl;}

        template <int x = id>
        static typename std::enable_if<x==11>::type
        check1() { std::cout << id << std::endl;}
};


int main()
{
    check<10> a;
    a.check1();

    check<11> b;
    b.check1();
}
