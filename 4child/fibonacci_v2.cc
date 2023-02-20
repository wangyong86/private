#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int n;
	int a = 1, b = 1;
	int rst;

	cin >> n;

	if (n == 1 || n == 2)
		rst = 1;

	for (int i = 3; i <= n; i++)
	{
		rst = a + b;
		a = b;
		b = rst;
	}

	cout << rst;
	return 0;
}

