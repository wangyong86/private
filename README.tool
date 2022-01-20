STREAM:
downloads: http://www.cs.virginia.edu/stream/FTP/Code/stream.c
explain: https://zhuanlan.zhihu.com/p/147658532
gcc -O -DOMP_NUM_THREADS=8 -fopenmp -DNTIMES=7 -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream_OMP.100M 

FIO:


SystemTap:


Tsar:



