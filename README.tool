STREAM:
downloads: http://www.cs.virginia.edu/stream/FTP/Code/stream.c
explain: https://zhuanlan.zhihu.com/p/147658532
gcc -O -DOMP_NUM_THREADS=8 -fopenmp -DNTIMES=7 -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream_OMP.100M 

FIO:


SystemTap:


Tsar:git@github.com:alibaba/tsar.git


smem:
python, examine concrete memory distribution, RSS/PSS/USS
others: ipcs examine share memory info, but size seems inaccurate;
pmap: filter rw-s, s indicate it's shared memory. correspond to /dev/zero. equivalent to /proc/$pid/smaps
/dev/shm: tmpfs. postgres mmap some shared memory to it's files
psql-shared-buffers. fixed setting, shared by postgres and it's descent
top: SHR, all shared part by this proc, including shared memory and shared library
