#include <stdio.h>
#include <stdint.h>

#define CATALOG_CACHE_PAGE_KEY_LEN 21

typedef struct IndexRegionKey
{
    int     len;
    union
    {
        char     data[CATALOG_CACHE_PAGE_KEY_LEN];
        char    *ptr;
        uint64_t   rownum;
    } u;
} IndexRegionKey;

int main(int argc, char * argv[])
{
	IndexRegionKey AKey = {2, {{'0', '0'}}};
	IndexRegionKey BKey = {2, {"vlllll"}};
	IndexRegionKey CKey = {2, .u.rownum=100};

	int a[] = {
		[1] = 100,
		[2] = 300,
		[3] = 200,
	};

	printf("sizoef(array)=%zd, a[3] = %d\n", sizeof(a), a[3]);

    return 0;
}

