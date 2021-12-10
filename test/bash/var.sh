#!/bin/bash
. functions.sh

a=$((100+10))
arch=$(uname -m)
R=$(cat /etc/redhat-release)
section_title "\$((100+10) is:$a"
section_title "\$(uname -m) is:$arch"
section_title "\$(cat /etc/redhat-release) is:$R"

#Weak type
a=2323
B=${a/23/BB}
section_title "\${a/23/BB} is:"$B

#global var
B=abc
var=${VAR:-$B}
section_title "VAR is: $VAR, var(\${VAR:-abc) is:$var"

#progname
dirname=$(dirname $0)
dir=$(cd $dirname;pwd)
basename=$(basename $0)
section_title "dirname is:$dir, basename is: $basename"

#program parameter
./parameter.sh 1 2 3 4 5 6 7 8 9 10 11

