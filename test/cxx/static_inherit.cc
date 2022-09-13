#include <array>
#include <tuple>
#include <ctime>
#include <string>
#include <iostream>
#include <sstream>
#include <iomanip>

struct parent {
    static int st;
};

struct child : public parent {
    static int cst;
};

int child::cst;
//int parent::st;

int void_test()
{
    child c;
//    std::cout << parent::st << std::endl;
    return 0;
}

int main()
{
    child c;
    std::cout << c.cst << std::endl;
    return 0;
}
