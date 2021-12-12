#!/bin/env bash

stringZ=abcABC123ABCabc

#length
echo ${#stringZ}
echo `expr length $stringZ`
echo `expr "$stringZ" : '.*'` # char number?

#substring
echo `expr match "$stringZ" 'abc[A-Z]*.2'`
echo `expr "$stringZ" : 'abc[A-Z]*.2'`

#index, pos of first char in substring
echo `expr index "$stringZ" C12`

echo `expr index "$stringZ" C12`

#cut off/intercept
echo ${stringZ:0} # string:startpos:length
echo ${stringZ:7}
echo ${stringZ:1}
echo ${stringZ:7:3}

#blank or () will escape pos
echo ${stringZ:-4} 
echo ${stringZ:(-4)}
echo ${stringZ: -4}

#parameter cut off
echo ${*:2}
echo ${@:2} #as before
echo ${*:2:3} # from the second parameter, output three pos parameters

#expr substr $string $pos $length
#expr match $string $pos $length
echo `expr match "$stringZ" '\(.[b-c]*[A-Z]..[0..9]\)'`
echo `expr "$stringZ" : '\(.[b-c]*[A-Z]..[0..9]\)'`
echo `expr "$stringZ" : '\(......\)'`

#delete substr: 
#${string#substring}: from beginning, match shortest substr
#${string##substring}: from beginning, match longest substr
#${string%substring}: from endding, match shortest substr
#${string%%substring}: from endding, match longest substr

stringZ=abcABC123ABCabc
X='a*C'
echo ${stringZ#$X}
echo ${stringZ##$X}

#${string/substr/replacement}: replace first
#${string//substr/replacement}: replace all
#${string/#substr/replacement}: replace leftmost
#${string/%substr/replacement}: replace rightmost

#default value
variable=
echo "${variable-0}" # no output, the same as ${parameter=default}
echo "${variable:-0}" # 0, the same as ${parameter:=default}

a=${param1+xyz}
echo "a = $a" # a=xyz, if var is  set, let it's xyz, otherwise is null

#${parameter?err_msg}, ${parameter:?err_msg}. if set, use original value,
#otherwise output err_msg and terminate the script

strip_leading_zero()
{
	return=${1#0}
}

b=
strip_leading_zero2()
{
	shopt -s extglob # enable extend wildcard(扩展通配符)
	local val=${1##+(0)}
	shopt -u extglob # disable extend wildcard
	_strip_leading_zero2=${val:-0}
	#return $_strip_leading_zero2 error: can't return non-integer value
	b=$_strip_leading_zero2 #global var is valid	
}

strip_leading_zero2 0000123db
echo $b
strip_leading_zero2 0
echo $b

#{!varprefix*}, {!varprefix@} : match all variables prefixed by varprefix

abc23=something_else
b=${!abc*}
echo "b=$b"
c=${!b} # output something_else, indirect reference
echo $c
