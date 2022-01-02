#include<iostream>

namespace myspace{
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
}
