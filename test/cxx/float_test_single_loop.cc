#include <cstdio>
#include <cstdint>
#include <cmath>
#include <iostream>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>

#include <sys/time.h>

using namespace std;

#define RUNS 100000000
inline bool lt_v1(float &lhs, float &rhs) { return !std::isnan(lhs) && (std::isnan(rhs) || lhs < rhs); }
inline bool lt_v2(float &lhs, float &rhs) { return ~std::isnan(lhs) & (std::isnan(rhs) | (lhs < rhs)); }

typedef struct timeval timeval;

float GenNan()
{
    return sqrt(-1);
}

int couttimediff(timeval &t1, timeval &t2)
{
    return (t2.tv_sec - t1.tv_sec) * 1000000 + (t2.tv_usec - t1.tv_usec);
}

float Test2(float &num, float &n)
{
    if (lt_v2(num, n))
        num++;
    return num;
}

float Test3(float &num, float &n)
{
    if (lt_v1(num, n))
        num++;
    return num;
}

int Test1(float n)
{
    timeval t1, t2, t3, t4;
    float num1 = 0, num2 = 0;
    int fd = open("/dev/zero", O_APPEND);
    float *nums = (float *)mmap(NULL, 8*RUNS, PROT_READ, MAP_SHARED, fd, 0); 
    std::uint64_t matchbits = 0;

    gettimeofday(&t1, NULL);
    for (int i = 0; i < RUNS; i++)
    {
        matchbits |= lt_v1(nums[i], n) << (i % 64);
    }

    gettimeofday(&t2, NULL);
    cout << "number:" << matchbits << "time:" << couttimediff(t1, t2) << endl;
    gettimeofday(&t3, NULL);
    
    for (int i = 0; i < RUNS; i++)
    {
        matchbits |= lt_v2(nums[i], n) << (i % 64);
    }

    gettimeofday(&t4, NULL);
    cout << "number:" << matchbits << "time:" << couttimediff(t3, t4) << endl;

    return 1;
}

int main(int argc, char * argv[])
{
    float n = 1000000000;
    float m = GenNan();
    Test1(n);
    Test1(m);
}

