#!/bin/bash

url=$1
data=$2
if [[ -z "$url" ]]
then
	echo "input post url"
	exit -1
fi

if [[ -z "$data" ]]
then
	echo "input post data"
	exit -1
fi

data=$(echo "$data" | sed 's/\x1E\x17/\\/g')
echo $data
resp=$(curl -ls -H "Content-type: application/json" -X POST -d "${data}" ${url})

echo $resp
