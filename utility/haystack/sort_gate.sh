#!/bin/bash

grep Insert $1 |awk -F"[()]" '{print $2}'>tempa
awk '{print $4}' tempa |grep s >tempb;
grep m tempb|awk -F"ms" '{print $1}' |sort -n | awk '{print $1"ms"}' > $2
grep -v m tempb|awk -F"s" '{print $1}' |sort -n | awk '{print $0"s"}' >> $2
