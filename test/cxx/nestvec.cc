#include <iostream>
#include <vector>
using namespace std;

vector<vector<int>> a = {{1,2}, {3,4}};
vector<vector<int>> b = a;

int main(int argc, char **argv) {
	cout << a[1][1] << endl;
}
