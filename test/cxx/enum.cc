#include <iostream>

using namespace std;

#if 0
/*
 * compile this function will be failed with:
 * enum.cc:12:22: error: ‘man’ conflicts with a previous declaration
 */
int testenum()
{
	enum type { man = 1, child = 2};
	enum gender { man = 1, woman = 2}; 

	cout << man << endl;

	return 0;
}
#else

int testenum()
{
	enum class type { man = 1, child = 2};
	enum class gender { man = 3, woman = 2}; 

#if 0
	/*
	 * Following statment is errortic because no << overload defined and enum class
	 * can't be converted to integer automatically because enum class is strong type
	 * ``cout << type::man << endl``;
	 */
	cout << type::man << endl;
	cout << gender::man << endl;
#endif

	auto t = type::man;

	if (t == type::man) 
		cout << " man" << endl;

	/* expression must be bracketed*/
	cout << (t==type::man?" man": " child") << endl;


	return 0;
}
#endif

int main(int argc, char** argv)
{
	testenum();
}
