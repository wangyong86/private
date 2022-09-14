#include <stdio.h>

#define MAX_CHAR 127
#define MIN_PRINTABLE 33
#define MAX_PRINTABLE 126
#define CHAR_PER_LINE 8
int main()
{
    int lines = (MAX_PRINTABLE + CHAR_PER_LINE - MIN_PRINTABLE) / CHAR_PER_LINE;
    int base = MIN_PRINTABLE;
    for (int i = 0; i < lines; i++)
    {
        for (int j = 0; j < CHAR_PER_LINE && base <= MAX_PRINTABLE; j++, base++)
            printf("%d:%c\t", base, base);

        printf("\n");
    }

    return 0;
}
