#include <iostream>
#include <functional>

using namespace std;
using namespace std::placeholders;

class base {
public:
	void Set(int time)
	{
		t_ = time;
	}
	
	int Get() { return t_; }

private:
	int  t_;
};

void func(int *a) { ++*a;}

typedef std::function<void()> functor;
using functor1 = std::function<int(int)>;

class ScopedTimer {
public:
	explicit ScopedTimer (functor f)
	{
		f_ = f;
	}

	~ScopedTimer()
	{
		f_();
	}

private:
	functor f_;
};

void print(functor1 const &f)
{
	cout << f(10) << endl;
}

void test2()
{
	auto  a = [&](int i)->int {
		return i*2;
	};

	print(a);
}

void test3()
{
	print([&](int i){
		return i*3;
	});
}

void test1()
{
	int i = 0;
	functor f = std::bind(func, &i);

	{
		ScopedTimer timer(f);
	}
	cout << i << endl;
}

int main(int argc, char **argv) 
{
	test1();
	test2();
	test3();
}
