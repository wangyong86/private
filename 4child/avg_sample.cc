#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int n;
	double value;
	double total = 0;

	cin >> n;

	for (int i = 0; i < n; i++) {
		cin >> value;
		total += value;
	}

/*
	cout << setiosflags(ios::fixed);
	cout << setprecision(4);
	cout << total/n << endl;
*/
	printf("%.4f", total/n);
	return 0;
}

