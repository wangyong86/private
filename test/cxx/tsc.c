#include <stdio.h>
#include <unistd.h>

typedef unsigned long long u64;
#define DECLARE_ARGS(val, low, high)    unsigned low, high
#define EAX_EDX_RET(val, low, high)     "=a" (low), "=d" (high)
#define EAX_EDX_VAL(val, low, high)     ((low) | ((u64)(high) << 32))

static __always_inline unsigned long long __native_read_tsc(void)
{
          DECLARE_ARGS(val, low, high);
          asm volatile("rdtsc": EAX_EDX_RET(val, low, high));
          return EAX_EDX_VAL(val, low, high);
}

static __always_inline u64 gettsc()
{
	u64 result;
	__asm__ __volatile__ ("rdtsc" : "=A" (result));
	return result;
}

unsigned long long native_read_tsc(void)
{
         return __native_read_tsc();
}


int method1()
{
        unsigned long long val, val2;
        unsigned long long delta;

        val = native_read_tsc();
        usleep(1000 * 1000);
        val2 = native_read_tsc();
        delta = val2 - val;

        printf ("v1: %llu, v2: %llu, delta: %llu \n", val, val2, delta);
        printf ("%lld\n", delta);

        return (0);
}

int method2()
{
	u64 val1, val2;;
	u64 delta;
	
	val1 = gettsc();
	usleep(1000 * 1000);
	val2 = gettsc();
	delta = val2- val1;

	printf ("v1: %llu, v2: %llu, delta: %llu \n", val1, val2, delta);
	printf ("%lld\n", delta);
}

int main()
{
	method1();
	method2();
}
