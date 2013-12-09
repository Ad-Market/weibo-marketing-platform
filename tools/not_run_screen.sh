#!/bin/bash

not_run_search_screen.sh
not_run_contact_screen.sh
not_run_mobile_screen.sh
not_run_update_screen.sh
not_run_zero_screen.sh
#screen -ls search |grep -o "[0-9]\+.s"| while read line; do pstree -p $line| grep -v ruby| grep -o "^screen([0-9]\+)" |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}' |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}'
#done
#screen -ls contact |grep -o "[0-9]\+.c"| while read line; do pstree -p $line| grep  ruby| grep -o "^screen([0-9]\+)" |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}' |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}'
#done
#screen -ls mobile |grep -o "[0-9]\+.m"| while read line; do pstree -p $line| grep -v ruby| grep -o "^screen([0-9]\+)" |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}' |grep -o "[0-9]\+" |awk -v a=screen -v b=-x '{print a" "b" "$1}'
#done
