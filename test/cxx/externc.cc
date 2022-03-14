#include <iostream>

extern "C" {
void printfxx () {
	std::cout << "hello, the world" << std::endl;
}
}

void printfxy () {
	std::cout << "hello, the world" << std::endl;
}

using namespace std;
class base {
public:
	void func()
	{
		cout << "in base" <<  a << endl;
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
	cout << argc << argv <<  "main" << endl;
}
