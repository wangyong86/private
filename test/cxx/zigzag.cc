#include <iostream>
#include <cinttypes>

using namespace std;

uint32_t zigzag(int32_t n)
{
    uint32_t n1 = n >> 31;
    uint32_t n2 = n << 1;
    uint32_t n3 = n1 ^ n2;
    
    return n3;
}

int main(int argc, char **argv) {
	std::cout << zigzag(-1) << endl;
}
