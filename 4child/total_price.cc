#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main()
{
	float a[10] = {28.9, 32.7, 45.6, 78, 35, 86.2, 27.8, 43, 56, 65};
	int b[10];
	float total_price = 0;

	for (int i = 0; i < 10; i++) {
		cin >> b[i];
		total_price += a[i] * b[i];
	}

	cout << setiosflags(ios::fixed);
	cout << setprecision(1);
	cout << total_price << endl;
	return 0;
}

