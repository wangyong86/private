#include "template.h"
#include <vector>

using namespace std;
//using namespace myspace;

void printout(int a)
{
	cout << a << endl;
}

void testForLoop()
{
	std::vector<int> v = {1,2,3,4,5};
	for (auto a: v)
	{
		printout(a);
	}
}

void testforcond()
{
	for(int i = 1; i < 1; i++)
	{
		printf ("loop none\n"); 
	}
}

int main()
{
	testForLoop();
	testforcond();
}
