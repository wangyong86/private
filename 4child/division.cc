#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int num;
	bool factor = false;

	cin >> num;

	if (num % 3 == 0) {
		cout << 3 << " ";
		factor = true;
	}

	if (num % 5 == 0) {
		cout << 5 << " ";
		factor = true;
	}

	if (num % 7 == 0) {
		cout << 7 << " ";
		factor = true;
	}

	if (!factor)
		cout << "n";

	return 0;
}

