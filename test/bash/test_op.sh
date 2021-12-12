#!/bin/bash
function show_input_type()
{
	[ -p /dev/fd/0 ] && echo PIPE || echo STDIN 
}

show_input_type "Input"
echo "Input" | show_input_type

# -s size!=0
# -p pipe
# -f normal file
# -L/h symlink
# -S socket
# -t file descriptor
# -e file existence
# -d directory
# -b block device
# -c char device
# -t tty
# -r readable
# -w writeable
# -x executable
# -g sgid
# -u suid: normal user can execute it as root user
# -k sticky bit: file will be stored in cache; directory's writable privilege
#      will be limited to it's owner
# -O owner
# -G file group is the same as user group
# f1 -nt f2: f1 is newer than f2
# f1 -ef f2: f1 and f2 are hard linked to the same file
# ! : return negative value of tested value

[ 1 -eq 2 -a -n "`echo true 1>&2`" ] # result is true. because -a/o is not
#follow shortcut, and echo cmd is execute and result is true. so it's returned

[[ 1 -eq 2 && -n "`echo true 1>&2`" ] # result is true. because -a/o is not
# && is shortcut, not show true and result is false 
