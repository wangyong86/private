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

	
int main(int argc, char **argv) {
	int i = 0;
	functor f = std::bind(func, &i);

	{
		ScopedTimer timer(f);
	}
	cout << i << endl;
}
