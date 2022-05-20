#include <iostream>
#include <cstdlib>
using namespace std;
int main(int argc, char **argv) {
	void *p;
	p = (void*)1000000;
	cout << "void* p is:" << p << endl;
	cout << "void* p is:" << p + 1 << endl;

    cout << "sizeof(float): " << sizeof(float) << endl;
    cout << "sizeof(int): " << sizeof(int) << endl;
    cout << "sizeof(long long int): " << sizeof(long long int) << endl;
    cout << "sizeof(long int): " << sizeof(long int) << endl;
    cout << "sizeof(double): " << sizeof(double) << endl;

    long int lvalue = 0;
    snprintf((char*)&lvalue, 8, "%d", 51);
    cout << "51 ld as long int: " << lvalue << endl;
    snprintf((char*)&lvalue, 8, "%lld", (long long)51);
    cout << "51 lld as long int: " << lvalue << endl;
}
