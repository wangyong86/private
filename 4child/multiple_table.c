#include <stdio.h>

void multitable(int linefirst)
{
	if (linefirst)
	{
		for (int i = 1; i <= 9; i++)
		{
			for (int j = 1; j <= i; j++)
				printf ("%d * %d = %2d  ", j, i, j *i);
			printf("\n");
		}

		return;
	}

	for (int i = 1; i <= 9; i++)
	{
		for (int j = i; j <= 9; j++)
			printf ("%d * %d = %2d  ", i, j, j *i);
		printf("\n");
	}
}

int main(int argc, char **argv)
{
	multitable(0);

	return 0;
}
