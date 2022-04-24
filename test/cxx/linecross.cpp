#include "template.h"

#include <cassert>

using namespace std;
using namespace myspace;

struct point {
	int x;
	int y;
};

struct rectangle {
	point small;
	point large;
};

bool cross1(rectangle lh, rectangle rh) {
	return ! ((rh.small.x > lh.large.x || lh.small.x > rh.large.x) &&
			  (rh.small.y > lh.large.y || lh.small.y > rh.large.y));
}

bool cross(rectangle lh, rectangle rh) {
	return (rh.small.x < lh.large.x && lh.small.x < rh.large.x) &&
			(rh.small.y < lh.large.y && lh.small.y < rh.large.y);
}

int main()
{
	point p{1,1};
	std::cout << p.x << std::endl;
	assert(cross({{1,2}, {3,4}}, {{0,0}, {3,4}}));
	assert(cross(rectangle{{1,2}, {3,4}}, rectangle{{2,2}, {4,5}}));
	assert(!cross(rectangle{{0,0}, {1,1}}, rectangle{{2,2}, {3,3}}));
	assert(!cross(rectangle{{0,0}, {1,1}}, rectangle{{0,2}, {2,3}}));
}
