#include <iostream>

using namespace std;

struct s {
    int a[10] = {10};
    int b[10];
};

int main(int argc, char **argv)
{
    s s1;

    for (int i = 0; i < 10; i++)
        cout << s1.a[i] << endl;
    for (int i = 0; i < 10; i++)
        cout << s1.b[i] << endl;
}

