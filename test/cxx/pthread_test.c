#include <stdio.h>
#include <pthread.h>

void* printt(void *args)
{
	int arg = *(int*)(args);
	printf("hello, the world, id:%d\n", arg);
	return NULL;
}

int main(int argc, char * argv[])
{
	pthread_t tid;
	int args = 10;
	int rst = pthread_create(&tid, NULL, printt, (void*) &args);
	if (!rst)
		pthread_join(tid, NULL);
}

