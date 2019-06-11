#!/bin/bash

pre_day=$(date +"%Y-%m-%d" -d "-1day")

tar_log="/opt/work/funds_trace/logs/${pre_day}-info.log"

echo "tar log file '$tar_log'"

if [ -s "$tar_log" ]
then
	echo "exit"
	tar -czPf "$tar_log.tar.gz" $tar_log && rm -rf $tar_log && mv "$tar_log.tar.gz" /opt/work/funds_trace/logs/log_zip/
else
	echo "not exit $tar_log"
fi
