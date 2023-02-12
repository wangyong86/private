#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int n;

	cin >> n;

	int a[n];

	for (int i = 0; i < n; i++)
	{
		if (i == 0 || i == 1)
			a[i] = 1;
		else
			a[i] = a[i- 1] + a[i - 2];

		cout << a[i] << " "; 
	}

	return 0;
}

