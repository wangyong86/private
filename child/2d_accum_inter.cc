#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int m, n;
	int rst = 0;

	cin >> m >> n;

	int a[m][n];

	for (int i = 0; i < m; i++)
	{
		for (int j = 0; j < n; j++)
		{
			if (i == 0 || j == 0)
				a[i][j] = 1;
			else
				a[i][j] = a[i-1][j] + a[i][j-1];

			rst += a[i][j];
		}
	}

	cout << rst;

	return 0;
}

