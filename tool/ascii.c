#include <stdio.h>

#define MAX_CHAR 127
#define MIN_PRINTABLE 32
#define MAX_PRINTABLE 126
#define CHAR_PER_LINE 8
int main()
{
    int lines = (MAX_PRINTABLE + CHAR_PER_LINE - MIN_PRINTABLE) / CHAR_PER_LINE;
    int base = MIN_PRINTABLE;

	printf("Output all printable ascii, style: numeric:hexdecimal: char\n");

    for (int i = 0; i < lines; i++)
    {
        for (int j = 0; j < CHAR_PER_LINE && base <= MAX_PRINTABLE; j++, base++)
		{
			if (base > 99)
				printf("%d:%x:%c\t", base, base, base);
			else
				printf("%d:%x:%c\t\t", base, base, base);
		}

        printf("\n");
    }

    return 0;
}
