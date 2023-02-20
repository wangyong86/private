#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int n = 12;
	double balance;
	double total = 0;
	for (int i = 0; i < n; i++) {
		cin >> balance;
		total += balance;
	}

	cout << "$";
	cout << setiosflags(ios::fixed);
	cout << setprecision(2);
	cout << total/n << endl;
	return 0;
}

