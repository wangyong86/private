#include <iostream>
using namespace std;
int main(int argc, char **argv) {
	void *p;
	p = (void*)1000000;
	cout << "void* p is:" << p << endl;
	cout << "void* p is:" << p + 1 << endl;
}
