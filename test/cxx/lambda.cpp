#include <iostream>
using namespace std;
class base {
public:
	void func()
	{
		cout << "in base" << endl;
	}
		
private:
	int a;
};

class derived : public base {
public:
	void func ()
	{
		cout << "in derived" << endl;
	}
};

	
int main(int argc, char **argv) {
	auto a = []() {
		int x = 10;
		auto b = [x]() mutable {
			return ++x;
		};
		auto c = [x]() mutable {
			return ++x;
		};
		return std::make_pair(b, c);
	};
	
	auto pair = a();
	auto b = pair.first;
	auto c = pair.second;

	cout << b() << endl;
	cout << b() << endl;
	cout << c() << endl;
	cout << c() << endl;
}
