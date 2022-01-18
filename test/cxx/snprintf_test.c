#include<locale.h>
#include<stdio.h>
#include<stdint.h>
#include<string.h>
#include<unistd.h>

#define MAX_NAME_LEN    100
#define MEDIUM_NAME_LEN 30
#define SHORT_NAME_LEN 10

typedef struct status{
	char name[MAX_NAME_LEN];
	char name1[MAX_NAME_LEN];
	int i;
}status;

void test()
{
	char name[MAX_NAME_LEN];
	char name1[MAX_NAME_LEN];

	printf("Locale is:%s", setlocale(LC_ALL, NULL));

	uint32_t oid = 0xF0000000;
	snprintf(name, MAX_NAME_LEN, "name_%d\0", oid);
	printf("name is: %s\n", name);

	snprintf(name, MAX_NAME_LEN, "name_%u\0", oid);
	printf("name using unsigned int is: %s\n", name);	

	snprintf(name, SHORT_NAME_LEN, "name_%u\0", oid);
	printf("name is:%s, len is %d\n", name, strlen(name));

	// special charater
	const char *relname="4-(\\\n]* )[中文";
	snprintf(name, MEDIUM_NAME_LEN, "name_%s!", relname);
	printf("%s\n", name);

	// test copy data structure
	status s, y;
	memcpy(s.name, name, strlen(name));
	memcpy(&y, &s, sizeof(s));
	printf("%s\n", y.name);

	// null pointer
	const char * xname = NULL;
	snprintf(name, SHORT_NAME_LEN, "name_%s!", xname);
	printf("empty string should be name_:%s\n", name);

	sleep(10000);
}

int main(int argc, char** argv)
{
	test();
}
