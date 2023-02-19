#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int n, val;
	int cnt = 0;

	cin >> n >> val;

	for (int i = 0; i < n; i++)
	{
		int v;

		cin >> v;

		if (v == val)
			cnt++;
	}

	cout << cnt;

	return 0;
}

