#include <iostream>
#include <vector>

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

void reference()
{ 
	derived c;
	base &e = c;
	c.func();
	derived &d = dynamic_cast<derived&>(e);
	d.func();
	cout << "main" << endl;
}

void move_reference()
{
	std::string str("hello, the world");

	std::vector<std::string> vec;
	vec.push_back(str);
	cout << "after moved:pushback:" << str << endl; 

	vec.emplace_back(std::move(str));
	cout << "after moved:emplack:" << str << endl; 
}

template<typename T>
void func(T& t)
{
	cout << "it's a lvalue" << endl;
}

template<typename T>
void func(T&& t)
{
	cout << "it's a rvalue" << endl;
}

template<typename T>
void wrap(T&& t)
{
	func(t);
}

template<typename T>
void wrap1(T&& t)
{
	func(std::forward<T>(t));
}

void forward_reference()
{
	int num = 1920;

	wrap(num);
	wrap(1920);
	wrap1(num);
	wrap1(1920);
}

int main(int argc, char **argv)
{
	reference();
	move_reference(); 
	forward_reference(); 

	return 1;
}
