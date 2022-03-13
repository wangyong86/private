#include <iostream>
using namespace std;
class base {
public:
	virtual void func()
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

int main(int argc, char **argv)
{ 
	derived c;
	base &e = c;
	c.func();
	derived &d = dynamic_cast<derived&>(e);
	d.func();
	cout << "main" << endl;
}
