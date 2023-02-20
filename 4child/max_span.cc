#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int n;
	int val;
	int max = 0, min = 100000;

	cin >> n;
	for (int i = 0; i < n; i++) {
		cin >> val;
		if (val > max)
			max = val;

		if (val < min)
			min = val;
	}

	cout << max - min << endl;
	return 0;
}

