#!/bin/env awk
#loop
echo "1 2 3 4 5 6 7"|awk '{for (i=1;i<=NF;i++) count+=$i}END {printf ("%3.3f", count)}'
echo "1 2 3 4 5 6 7\n 10 10 12"|awk '{for (i=1;i<=NF;i++) count[i]+=$i}END {for (j in count) printf ("%3.3f ", count[j])}'

#if

#array


#string
