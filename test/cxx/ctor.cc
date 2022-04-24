#include <iostream>
#include <vector>

using namespace std;
class base {
public:
	base(int && _a, int &&_b)
		: a(_a)
		, b(_b)
	{ }

	void func()
	{
		cout << "in base" << endl;
	}
		
private:
	int a;
	int b;
};

int main(int argc, char **argv) {
	std::vector<base> v;

	v.emplace_back(base{10,10});
	
}
