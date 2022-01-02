#include<stdio.h>
#include<stdint.h>
#include<string.h>
int main(int argc, char** argv)
{
	char name[100];
	uint32_t oid = 0xF0000000;
	snprintf(name, 100, "name_%d\0", oid);
	printf("name is: %s\n", name);	
	snprintf(name, 100, "name_%u\0", oid);
	printf("name using unsigned int is: %s\n", name);	

	char sname[8];
	snprintf(sname, 10, "name_%u\0", oid);
	printf("name is:%s, len is %d\n", sname, strlen(sname));	
}
