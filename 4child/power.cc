#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int n;
	int num;
	int rst;

	cin >> num >> n;
	rst = num;
	for (int i = 0; i < n - 1; i++)
		rst *= num;

	cout << rst << endl;
	return 0;
}

