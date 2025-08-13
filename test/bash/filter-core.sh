#!bin/bash
for core in $1/core.*; do
    echo "Processing $core"
    gdb -batch -ex "bt" $2 $core
    echo "----------------------------------------"
done
