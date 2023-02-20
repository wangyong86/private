#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
	int m;
	int year;
	double amount;
	int interest;

	cin >> interest >> m >> year;
	amount = m;
	for (int i = 0; i < year; i++) {
		amount *= (100 + interest);
        amount /= 100;
    } 

	cout << int(amount) << endl;
	return 0;
}

