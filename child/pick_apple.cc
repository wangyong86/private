#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int n = 10;
	int a[n];
	int dh = 30;
	int h;
	int cnt = 0;

	for (int i = 0; i < n; i++)
		cin >> a[i];

	cin >> h;

	for (int i = 0; i < n; i++)
		if (a[i] <= h + dh)
			cnt++;

	cout << cnt;

	return 0;
}

