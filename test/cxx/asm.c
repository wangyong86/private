#include <stdio.h>

/* standard gcc asm format
__asm__ __volatile__(
    "instrunction \n"
    "instrunction \n"
    "instrunction \n"
:   "=r"(_res), "+m"(*lock)
:   "r":lock
:   "memory": "cc" );
*/


#ifdef __x86_64__
#if 0
#define TAS(lock) tas(lock)
int tas(s_lock_t *lock)
{
    register s_lock_t _res = 1;
    
    __asm__ __volatile__(
    " lock \n"
    " xchgb %0,%1\n"
    : "+q"(_res), "+m"(*lock)
    :
    : "memory", "cc");

    return (int)_res;
}
#endif

#define SPIN_DELAY() spin_delay()

static __inline__ void
spin_delay(void)
{
    /*
     * Adding a PAUSE in the spin delay loop is demonstrably a no-op on
     * Opteron, but it may be of some use on EM64T, so we keep it.
     */
    asm __volatile__(
    /*__asm__ __volatile__( */
        " rep; nop          \n");
}

#endif   /* __x86_64__ */

int main()
{
	spin_delay();
	fprintf(stderr, "hello, the world\n");
}
