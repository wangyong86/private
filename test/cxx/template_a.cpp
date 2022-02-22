#include "template.h"

namespace myspace {
void global_func_reference_template(int a)
{
	if (a = 1)
	{
		BasicTypeWrapper<float>  a;
		a.func(10);
	} else {
		BasicTypeWrapper<int>  a;
		a.func(10);
	}
}

}

