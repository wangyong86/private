#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	int n;

	cin >> n;

	int a[n];
	int b[n];
	for (int i = 0; i < n; i++) {
		cin >> a[i];
		b[i] = 0;
	}

	int i = 1;
	for (; i < n; i++) {
		int k = a[i] - a[i - 1];

		k = k < 0 ? -k : k;

		if (k > n - 1 || k < 1 || b[k] == 1)
			break;

		b[k] = 1;
	}

	cout << (i == n ? "Jolly" : "Not jolly");

	return 0;
}

