#!/bin/env bash

#democluster location
binary=$GPHOME/bin/postgres
gdb=""

if  [ $# == 0 ]; then
	echo "please specify corefile, use pcore.sh to identify corefiles in democluster " 
	echo "./gdb.sh \$corefile"
	exit 1
fi

if [ a"$gdb" == "a" ]; then
	gdb=gdb
fi

$gdb $binary $1
