#!/bin/bash

reserved_days=10

cday=$(date +"%Y-%m-%d" -d "-1day");

deleted_file=/opt/work/funds_trace/logs/log_zip/$(date +"%Y-%m-%d" -d "-${reserved_days}days")-info.log.tar.gz;

if [ -s "${deleted_file}" ]
then
	echo "deleted file ${deleted_file}"
	rm -rf ${deleted_file}
fi

cfile="/opt/work/funds_trace/logs/log_zip/${cday}-info.log.tar.gz"

scp -r ${cfile} work@10.126.126.141:/data/ft_log/
