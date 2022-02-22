#include "template.h"

using namespace std;
using namespace myspace;


int main()
{
	BasicTypeWrapper<float> A;
	BasicTypeWrapper<int> B;

	std::cout << A.func(10) << std::endl;
	std::cout << B.func(10) << std::endl;
	std::cout << A.func1(10) << std::endl;
	std::cout << B.func1(10) << std::endl;
}
