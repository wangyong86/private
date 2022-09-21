#!/bin/env bash

declare -A a
a['1']='world'
a['2']='america'
a[2]='russia'
a[0.2]='nieria'
#echo ${a['hell']}
echo ${a['1']} # world
echo ${a[2]} # russia
echo ${a[0.2]} # russia
