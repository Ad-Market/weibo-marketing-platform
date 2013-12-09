#!/bin/bash
screen -ls mobile |grep -o "[0-9]\+.m"| while read line; do pstree -p $line| grep -v ruby| grep -o "^screen([0-9]\+)" |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}' |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}'
done
