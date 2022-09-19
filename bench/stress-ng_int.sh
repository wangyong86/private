#!/bin/env bash
methods="int64 int32 int16 int8"

for method in $methods
do
    echo $method
    stress-ng --cpu 1 --cpu-method=$method -t 10 --metrics-brief >> int.rst
done
