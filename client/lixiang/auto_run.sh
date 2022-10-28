#!/bin/bash

run()
{
  for ((i=1; i<=16; i++))
  do
  ./run_query.sh 1 50 sql${i} 
  done
}

run

#测试稳定性使用下面代码
#for ((c=1; c<=200; c++))
#do
#run
#done
