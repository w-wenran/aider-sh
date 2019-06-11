#!/bin/bash

# this shell can hold cpu us percentage
# Automatic adjustment
# author wangwenran
# create date 2018-05-18

cpu_us_min=$1

cpu_us_max=$2

if [[ -z "$cpu_us_min" || -z "$cpu_us_max" ]]

then
	echo "input params [cpu_us_min cpu_us_max]"
	exit 0
fi

echo "===================================================="
echo "try resolve linux info"
cup_count=$(cat /proc/cpuinfo| grep "processor"| wc -l)

echo "cpu amount $cup_count"

echo "Automatic adjustment cpu us ${cpu_us_min}% ~ ${cpu_us_max}%"

echo "===================================================="

while true
do
	cpu_us=$( top -bn 2 | awk -F '[ %,]+' '/Cpu/{print $2}' | awk 'NR==2{print $0}')
	cpu_grab_count=`ps -ef | grep cpu_grab.sh | grep -v grep | wc -l`
	echo "`date "+%Y-%m-%d %H:%M:%S"` cpu amount $cup_count, cpu use ${cpu_us}%, cpu grab counts $cpu_grab_count"
	cpu_us=`echo $cpu_us | awk -F '.' '{print $1}'`
	if [ `expr $cpu_us \< ${cpu_us_min}` -eq 1 ]
	then
		echo "try cpu grab ..."
		( bash cpu_grab.sh & )  
	fi
	if [ `expr $cpu_us \> ${cpu_us_max}` -eq 1 ]
	then
		ps -ef | grep cpu_grab.sh | grep -v grep | awk -F '[ ]+' 'NR==1{system("kill -9 " $2)}'
		echo "kill cpu grab proccess decrease cpu"
	fi
	sleep 3
done
