#!/bin/bash
grep duration $1|grep chj_st_signal|grep -v slice |grep ms|awk -F"duration: " '{print $2}'|awk '{print $1" "$2}'|sort -k1 -n >$2
