//#include "template.h"
#include <iostream>
#include <memory>
#include <vector>
#include <unordered_map>

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
		cout << "loop none\n" << endl; 
	}
}

class MyObj
{
	public:
		MyObj(const string &name)
		: name_(name)
		{}

		friend ostream& operator<<(ostream& os, const MyObj& m)
		{
			os << "Name" << m.name_;
			return os;
		}

	private:
		string name_;
};
 
void testNewFor()
{
	std::unordered_map<string, shared_ptr<MyObj>> umap;
	umap["black"] = make_shared<MyObj>("cat");
	umap["red"] = make_shared<MyObj>("tea");

	for (auto &pair : umap)
	{
		cout << *pair.second << endl;
	}

	cout << *umap["black"] << endl;
}

int main()
{
	testNewFor();
	testForLoop();
	testforcond();
}
