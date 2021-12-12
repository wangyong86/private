#!/bin/env bash

exec 6<&0

exec < data-file

read a1
read a2

echo 
echo "sadfasdfasdf"
echo $a1
echo $a1

exec 0<&6 6<&-
