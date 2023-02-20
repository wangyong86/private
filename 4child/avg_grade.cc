#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int n;
	int age;
	float total = 0;
	cin >> n;
	for (int i = 0; i < n; i++) {
		cin >> age;
		total += age;
	}

	cout << setiosflags(ios::fixed);
	cout << setprecision(2);
	cout << total/n << endl;
	return 0;
}

