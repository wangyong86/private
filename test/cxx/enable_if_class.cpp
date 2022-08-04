#include "template.h"
#include <type_traits>

using namespace std;
using namespace myspace;

template <int id, typename enable = void>
class check{};

template <int id>
class check<id, std::enable_if_t<id==10>>{
static constexpr int val = 10;
public:
    void output() {std::cout << "world" << std::endl;}
};

template <int id>
class check<id, std::enable_if_t<id!=10>>{
static constexpr int val = 10;
public:
    void output() {std::cout << "hello" << std::endl;}
};

#if 0
template <int id, std::enable_if<id==100, int>>
class check<int id>{
    void check1() {std::cout << 100 << std::endl;}
};
#endif

int main()
{
    check<10> a;
    a.output();

}
