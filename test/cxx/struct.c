#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define MAXKEYCACHE 3

typedef struct spec
{
	int			base;
	/* field of the same type can be put together, seperated by comma*/
	int			a, b, c;
} Spec;

// non-compact mode: align by 8B, neighbours are arranged in a 8B elements.
// total size if 64
typedef struct SortTuple
{
    uint8_t		type;
    void	   *tuple;
    int			ntuples;        /* number of logical tuple */
    uint16_t	tapeno;         /* see notes above */
    uint16_t	runno;          /* see notes above */
    bool		cached[MAXKEYCACHE];        /* number of sort key values cached */
    bool		ignore;
    int64_t		datums[MAXKEYCACHE];        /* value of key column */
    bool		isnulls[MAXKEYCACHE];       /* is key column NULL? */
} SortTuple;

// compaction mode: align by 1B, bool is also occupy a bytes.
typedef struct __attribute__((__packed__)) CSortTuple
{
    uint8_t       type;
    void       *tuple;
    int         ntuples;        /* number of logical tuple */
    uint16_t      tapeno;         /* see notes above */
    uint16_t      runno;          /* see notes above */
    bool        cached[MAXKEYCACHE];        /* number of sort key values cached */
    bool        ignore;
    int64_t       datums[MAXKEYCACHE];        /* value of key column */
    bool        isnulls[MAXKEYCACHE];       /* is key column NULL? */
} CSortTuple;


int main()
{
	printf("sizeof struct is:%d, compact style is:%d, sizeof(bool) is:%d\n", 
			sizeof(SortTuple) ,sizeof(CSortTuple), sizeof(bool));

	SortTuple s;
	CSortTuple cs;
	cs.ignore=s.ignore=true;
	memset(&s.cached, false, MAXKEYCACHE*sizeof(bool));
	memset(&cs.cached, false, MAXKEYCACHE*sizeof(bool));
	printf("bool value is: %d, bool value in compact struct is:%d\n", 
			s.ignore, cs.ignore);
	printf("sizeof spec: %zd\n", sizeof(Spec));
}
