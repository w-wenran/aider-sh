#!/bin/bash


log=$(date "+%Y-%m-%d")-warn.log

ps -ef | grep 'tail -fn0 /opt/work/funds_trace/logs/' | grep -v grep | awk '{print $2}' | while read pid

do
	echo "stop pid" $pid
	kill -9 $pid
done

#exit 0

tail_monitor_warn( )
{
	
	watch_log="/opt/work/funds_trace/logs/$log"
	
	for((;;))
	do
		if [ ! -f "$watch_log" ]
		then
			echo "${watch_log} not exist"
			sleep 30
		else
			break	
		fi
	done	

	tail -fn0 /opt/work/funds_trace/logs/$log |grep 'FT-RESULT-FAILURE' | awk '
BEGIN{
	pre_time=systime();
	count=0;
	total=0;
	ajk_total=0;
	wuba=0;
	wuba_total=0;
	ajk=0;
}

{
	count++;
	total++;

	if(index($0,"WUBA")>0){
		wuba++;
		wuba_total++;
	}

	if(index($0,"AJK")>0){
		ajk++;
		ajk_total++;
	}

	if((systime()-pre_time)>300)
	{
		msg="warning per 5min ajk: "ajk" ["ajk_total"] wuba: "wuba" ["wuba_total"] total: "count" ["total"]"
		if(count>10){
			system("/opt/work/funds_trace/bin/sms2.sh "msg);
		}
		
		print strftime("%Y-%m-%d %H:%M:%S",systime())" -- "msg;

		pre_time=systime();count=0;wuba=0;ajk=0;
	}
}'

}

( tail_monitor_warn >> /opt/work/funds_trace/bin/warn_monitor.log 2>&1 & )

