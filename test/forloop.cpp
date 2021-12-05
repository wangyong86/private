#include "template.h"
#include <vector>

using namespace std;
//using namespace myspace;

void testForLoop()
{
	std::vector<int> v = {1,2,3,4,5};
	for (auto a: v)
	{
		cout << a << endl;
	}
}

int main()
{
	testForLoop();
}
