#!/bin/bash

. functions.sh

sh triple_ele.sh 100

section_header
echo $0
echo `basename $0`
case "$1" in
	"") echo "no parameter";;
	*[!0-9]*) echo "usage: `basename $0` balabal";
	exit 1;;
	*) echo "Integer Paremter" $1;;
esac

# w
section_header
echo 'w display display all login users and its current activity'
w |tee -a log # w 

section_header
d=`date`
echo $d
echo "double quote keep some special chars like \$, Current date is: $d" |tee -a log
echo 'single quote disable all special chars, like Current date is: $d' |tee -a log

section_header
echo '/{,usr/}bin/*calc means /usr/bin/... and /bin/...'
for file in /{,usr/}bin/*calc
do
	if [ -x "$file" ]; then
		echo $file
	fi
done

section_header
echo ": mean NOP, return true"
:
echo $?

section_header
echo ': also act as placeholder, without: ${username=`whoami`} will report error'
: ${username=`whoami`}
echo "username is :" $username

section_title "$'...' means "
echo $'0xFF'
a=0xFF
echo $a

section_title "change abCd to ABCD "
echo abCd|./uppercase.sh
