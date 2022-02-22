#include <iostream>
using namespace std;

class A {
public:
	A() = default;

	int func() const {
		cout << "const function" << endl;
		return 100;
	}

protected:
	char* func() {
		cout << "non-const function" << endl;
		return reinterpret_cast<char*>(0);
	}
};

int main(int argc, char **argv) {
	const A a;
	A b;
	const A *c = &b;
	int p = a.func();
	std::cout << p << std::endl;
	std::cout << c->func() << std::endl;
}
