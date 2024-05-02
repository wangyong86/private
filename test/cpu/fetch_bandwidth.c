/*
 * This program demo how fetch bandwith affects loop performance.  Please
 * compile using gcc -g -O2.
 *
 * Modern compiler may insert nop to make start address of loop aligned with
 * fetch bandwith(e.g. 32B). Demo below is a loop which has a branch. This loop
 * can be hold in a 32B code block.  But branch lead to another fetch, not
 * prefetch.  It incurs additional cost.
 *
 * With O3, gcc generate different code totally.
 */
#include <errno.h>
#include <stdio.h>
#include <string.h>

typedef unsigned long long uint64;

uint64 g_tsc_hz = 0;

#define __noop_8() __asm__ __volatile__ ("nop (0x1)" ::: )

#define MAX_PATH_LEN 1024
#define ELOG(level, argv...) printf(argv)

static uint64
rdtsc_hz_cpuinfo()
{
	const char *filename = "/proc/cpuinfo";
	const char *pattern = "cpu MHz";
	FILE *file;
	char buff[MAX_PATH_LEN];
	char *cursor;
	float value;
	int result;
	uint64 cpu_hz = 0;

	file = fopen(filename, "r");
	if (!file)
	{
		/* elog can't accept errno which is a function correctly */
		result = errno;
		ELOG(LOG, "Can't open cpuinfo file: %s, error: %d", filename, result);
		return 0;
	}

	while (1)
	{
		cursor = fgets(buff, MAX_PATH_LEN, file);
		if (!cursor)
		{
			ELOG(LOG, "Can't match cpu hz, pattern: %s", pattern);
			break;
		}

		cursor = strstr(buff, pattern);
		if (!cursor)
		{
			continue;
		}

		cursor = strchr(buff, ':');
		result = sscanf(++cursor, "%f", &value);
		if (result < 1)
		{
			ELOG(LOG, "Read cpuinfo failed, errno: %d", result);
			(void)0;
		}
		else
		{
			cpu_hz = (uint64)value * 1000 * 1000;
			ELOG(LOG, "Read cpu hz success, value: %f hz: %lu\n", value, cpu_hz);
		}
		break;
	}

	fclose(file);

	return cpu_hz;
}

typedef struct time_interval_tsc
{
	uint64		start;
	uint64		end;
} interval_tsc;

#define pg_attribute_always_inline __attribute__((always_inline)) inline

#define NSECS_IN_USEC 1000UL
#define USECS_IN_SEC 1000 * 1000UL
#define NSECS_IN_SEC USECS_IN_SEC * NSECS_IN_USEC

#define DECLARE_ARGS(val, low, high)    unsigned low, high
#define EAX_EDX_RET(val, low, high)     "=a" (low), "=d" (high)
#define EAX_EDX_VAL(val, low, high)     ((low) | ((uint64)(high) << 32))

#if defined(__x86_64__)
#define DECLARE_TIMEINTERVAL(v) interval_tsc v; \
	v.start = 0; \
	v.end = 0; \

#define GET_BEGIN_TIME(v) v.start = __native_read_tsc()
#define GET_END_TIME(v) v.end = __native_read_tsc()
#define GET_TIME_INTERVAL(v) timediff_tsc(v.start, v.end)
#else
#define DECLARE_TIMEINTERVAL(v) interval v; \
	v.start.tv_sec = v.start.tv_usec = 0; \
	v.end.tv_sec = v.end.tv_usec = 0; \

#define GET_BEGIN_TIME(v) gettimeofday(&v.start, NULL)
#define GET_END_TIME(v) gettimeofday(&v.end, NULL)
#define GET_TIME_INTERVAL(v) timediff(v.start, v.end)
#endif

#define timediff(s, e) \
	((e.tv_sec - s.tv_sec) * USECS_IN_SEC + (e.tv_usec - s.tv_usec))

#define timediff_tsc(s, e) \
	((e - s) * NSECS_IN_SEC / g_tsc_hz)

static pg_attribute_always_inline unsigned long long
__native_read_tsc(void)
{
#if defined(__x86_64__)
	DECLARE_ARGS(val, low, high);
	asm volatile ("rdtsc":EAX_EDX_RET(val, low, high));

	return EAX_EDX_VAL(val, low, high);
#else
	struct timespec tmp; 
	clock_gettime(CLOCK_MONOTONIC, &tmp); 
	return tmp.tv_sec * g_tsc_hz + 
			(uint64_t)tmp.tv_nsec * g_tsc_hz / NSECS_IN_SEC;
#endif
}

void test(int loop)
{
	DECLARE_TIMEINTERVAL(v);
	GET_BEGIN_TIME(v);

	int k1 = 0;
	int k2 = 0;

	for (int i = 0; i < loop; i++)
	{
		//__noop_8();
		if ( (i & 0xF) == 0)
		{
			k1 += i;
			k2++;
		}
	}
	GET_END_TIME(v);

	printf("result:%d/%d, Run loop:%d, time(ns):%lld\n", k1, k2, loop, GET_TIME_INTERVAL(v));
}

int main(int argc, char *argv)
{
	uint64 loop = 100000;

	g_tsc_hz = rdtsc_hz_cpuinfo();
	
	test(loop);
}
