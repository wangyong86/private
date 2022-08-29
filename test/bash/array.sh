#!/bin/env bash
tpch_tables=(lineitem custom orders)

#size
num=${#tpch_tables[@]}
echo "table number:" $num
for ((idx=0;idx<$num;idx++))
do
#single element
echo ${tpch_tables[$idx]};
done

echo "All talbes:" ${tpch_tables[*]}
echo "All talbes:" ${tpch_tables[@]}

#associated array
map["hello"]="world"
map["car"]="sonata"
map["person"]="trump"

echo ${map["hello"]}

#str is an array type
str="hello,the world"
echo "the first char of $str is:" ${str[1]}
echo "the sizeof of $str is:" ${#str}
