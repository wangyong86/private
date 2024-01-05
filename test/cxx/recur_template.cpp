/*
 * After swap, v1 lost it's first element. Because swapped v1.front() has 
 * not place to store
 */
#include <iostream>
#include <vector>

struct v: std::vector<v>
{
	int anything;
};

int main()
{
	v v1;
	v1.emplace_back();
	v1.swap(v1.front());

	std::cout << v1.anything << std::endl;
}
