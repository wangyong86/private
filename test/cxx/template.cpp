#include <iostream>

namespace myspace{
#if 0
class Box{
	public: 
		Box():
			i64(0)
		{}

		template<typename type>
		type getTyped(){
			return i32;
		}
	private:
		union{
			std::int32_t i32;
			std::int64_t i64;
			//char *       ptr;
			double       d;
		};
};

template<>
double Box::getTyped<double>()
{
	return 0.0;
}
#endif

template <typename T>
class BasicTypeWrapper {
public:

	T func(T a)
	{
		return a + 1; 
	}

	T func1(T a)
	{
		return a + 10; 
	}
};

#if 0
template <>
class BasicTypeWrapper<float> {
public:
	float func(float a);
};
#endif

template<>
inline
float BasicTypeWrapper<float>::func(float a)
{
	return a + 2;
}

extern void global_func_reference_template(); 
}
class intc {
public:
	intc() = default;

	int operator= (const intc c_) {
		return c_.get();
	}

	intc& operator= (int c_){
		c = c_;
		return *this;
	}

	int get() const{
		return c;
	}
private:
	int c;
};

using namespace std;
using namespace myspace;

/*
 * 1) member function should be declared as INLINE for template class, to avoid
 *    multi-declaration when included in different compile unit. Implement them
 *    in class can also solve it. Should NOT declare another specification class
 *    seperately.
 * 2) Specification can be partial on some function. So, match implementation is
 *    in function granularity.
 * 3) Syntax. Sepecification should be prefixed by "template <>"
 * 4) Partially specify parameter type is permitted. 
 * 
 */

template<typename U>
class UClass{
	public:
		UClass() = default;

	using InnerType = intc;
};

template<typename T>
class TClass{
public:
	TClass() = default;

	int get() {
		// if k has a class definition, then class... is also ok.
		// but if k is a embeded type, like int, only typename is viable
		typename UClass<T>::InnerType k;
		k = 315156;
		return k.get();
	}
};

int main()
{
	BasicTypeWrapper<float> A;
	BasicTypeWrapper<int> B;

	std::cout << A.func(10) << std::endl;
	std::cout << B.func(10) << std::endl;
	std::cout << A.func1(10) << std::endl;
	std::cout << B.func1(10) << std::endl;

	TClass<float> t;
	int p = t.get();
	std::cout << p << std::endl;
}
