#!/bin/bash

key=$1

if [[ -z "$key" ]]
then
	echo "please input key worlds"
	exit 0
fi


result_list=`curl -s "http://www.tan8.com/codeindex.php?d=web&c=weixin&m=search_list&type=1&keyword=$key" | grep 'http://www.tan8.com/codeindex.php?d=web&c=weixin&m=piano&'| grep -v 'html' | awk -F '"|<p>|</p>|\n' '{gsub(/ /,"",$0);print $2"-------"$8}'`

select yp in $result_list
do
        break #
done

echo "You chose $yp"

download_url=`echo $yp | awk -F '-------' '{print $1}'`

if [[ -z "$download_url" ]]
then
	echo "can not resolve qinpu"
	exit 0
fi

curl -s "$download_url" | grep 'http://oss.tan8.com/yuepuku/' | grep -v 'download' | awk -F '"' '{for(i=1;i<=NF;i++)if($i=="><img src=")print $(i+1)}' | awk -F '/' '{print "download " $NF;system("curl -so "NR".png "$0);}'


