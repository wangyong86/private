#include <stdio.h>

void printBinary(float num) {
    unsigned int* ptr = (unsigned int*)&num; // 将浮点数的内存地址转换为unsigned int指针
    unsigned int value = *ptr; // 获取浮点数的二进制表示

    printf("float: %.1f, binary:", num);
    for (int i = sizeof(value) * 8 - 1; i >= 0; i--) {
        unsigned int mask = 1u << i; // 使用位运算提取每一位的值
        putchar(value & mask ? '1' : '0');
    }
    putchar('\n');
}

int Test()
{
	#define num 10
	float a[num] = {1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0};
	for (int i = 0; i < num; i++)
	{
		printBinary(a[i]);
	}

	return 1;
}

int main()
{
	return Test();
}

