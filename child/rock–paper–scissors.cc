#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

enum gesture{
	ROCK = 0,
	SCSSISORS = 2,
	PAPER = 5,
};

int compare(int p1, int p2)
{
	if (p1 == p2)
		return 0;

	// 0: rock; 2: scissors; 5:paper
	if ((p1 == (int)ROCK && p2 == (int) SCSSISORS) ||
		(p1 == (int)SCSSISORS && p2 == (int)PAPER) ||
		(p1 == (int)PAPER && p2 == (int)ROCK))
		return 1;

	else
		return -1;
}

int main()
{
	int r, m, n;
	int rst = 0;

	cin >> r >> m >> n;

	int a[m];
	int b[n];
	for (int i = 0; i < m; i++)
		cin >> a[i];

	for (int i = 0; i < n; i++)
		cin >> b[i];

	for (int i = 0; i < r; i++) {
		int g1 = a[i%m];
		int g2 = b[i%n];

		rst += compare(g1, g2);
	}

	cout << (rst > 0 ? "A" : rst < 0 ?  "B" : "draw");

	return 0;
}

