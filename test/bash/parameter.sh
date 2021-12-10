#!/bin/bash
. functions.sh

#program parameter
section_header
echo "all paramters are $*"
echo "all paramters can also be referenced as: $@"
echo "The number of parameters is: $#"
args=$#
echo "The last parameter is: ${!args}"

#warning: this result is not in accord with ABSG(Advanced Bash Scripting Guide)
echo "Exceed 10 parameters, must be referenced by \${10}, result is:${10}, \$10 is $10"
echo "\$11 is: $11"

for((i=0;i<$#;i++))
do
echo $(echo $i)
done
