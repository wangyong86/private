#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int m, n;
	int even = 0, odd = 0;

	cin >> m >> n;

	int a[m][n];

	for (int i = 0; i < m; i++)
	{
		for (int j = 0; j < n; j++)
		{
			cin >> a[i][j];
			if ((i+j)%2 == 0)
				even += a[i][j];
			else
				odd += a[i][j];
		}
	}

	cout << even << " " << odd;

	return 0;
}

