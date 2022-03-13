#include <iostream>
#include <vector>
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

vector<base*> func()
{
	return vector<derived*>();
}

int main(int argc, char **argv) {
	func();
	cout << "main" << endl;
}
