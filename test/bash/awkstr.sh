#!/bin/env bash
String=23skidoo1

#bash take position of the first char is 0
#awk take position of the first char is 1

echo ${String:2:4}

#using "'" escape '
#using echo to avoid a specific file
echo |awk ' 
{ print substr("'"${String}"'",3,4)
}
'

echo |awk ' 
{ print index("'"${String}"'","skid")
}
'

exit 0
