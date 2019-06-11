#!/bin/bash

tfile=$1
match_str=$2
pid=$$
echo $0,$tfile,$match_str,$pid,$(pwd)
tail -f $tfile |  while read line
do
	#echo "$line"
	#if $(echo $line | grep -q "$match_str")
	if [[ "$line" =~ "${match_str}" ]]
		then
			ps -ef | grep tme.sh | grep -v grep | awk -F '[ ]+' '{print $0;system("kill -9 " $2)}'
	fi
done
