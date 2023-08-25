#include <iostream>

int main(int argc, char * argv[])
{
	// must use hexdecimal const
	int num = 0x100'full;
	if (num == 0x100 * 16 + 15)
		std::cout << "c++ support full keyword" << std::endl;

    return 0;
}

