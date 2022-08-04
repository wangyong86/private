#include <cstdio>
#include <cstdint>
#include <cmath>
#include <iostream>

#include <sys/time.h>

using namespace std;

#define RUNS 100000000
#define lt_v1(lhs, rhs) (!std::isnan(lhs) && (std::isnan(rhs) || lhs < rhs))
#define lt_v2(lhs, rhs) (~std::isnan(lhs) & (std::isnan(rhs) | (lhs < rhs)))

typedef struct timeval timeval;

int couttimediff(timeval &t1, timeval &t2)
{
    return (t2.tv_sec - t1.tv_sec) * 1000000 + (t2.tv_usec - t1.tv_usec);
}

int Test()
{
    timeval t1, t2;
    float n = nanf("");

    float num = 0;
    cout << "0 < nan_v1:" << lt_v1(0, n) << endl;
    cout << "0 < nan_v2:" << lt_v2(0, n) << endl;

    gettimeofday(&t1, NULL);
    for (int i=0; i <RUNS; i++)
    {
        if (lt_v1(num, n))
            num++;
    }

    gettimeofday(&t2, NULL);
    cout << "number:" << num << "time:" << couttimediff(t1, t2) << endl;

    gettimeofday(&t1, NULL);
    for (int i=0; i <RUNS; i++)
    {
        if (lt_v2(num, n))
            num++;
    }

    gettimeofday(&t2, NULL);
    cout << "number:" << num << "time:" << couttimediff(t1, t2) << endl;

    return 1;
}

int main(int argc, char * argv[])
{
    float a = -1;
    float b = sqrt(a);

    cout << b << endl;
    
}

