#!/bin/bash

show ( ){
	if [[ ! $DEBUG == "NO" ]]
	then
		echo -e "\033[40;35m[INFO] ${*}\033[0m"
	fi
}

dbtag=${1}-DB

dbindex=$2

sql=$3

export DBCONF="/opt/wr-ubt-work/note/bin/dbconf"

dbsize=$(grep -E "^${1}-AMOUNT" $DBCONF | awk -F '-' '{print$NF}')

proxyhost=$(grep -E "^${1}-PROXY" $DBCONF | awk -F '-' '{print$NF}')

proxypwd=$(grep -E "^${1}-PWD" $DBCONF | awk -F '-' '{print$NF}')

show "--------------------------"
show "- connect '${1} ${dbindex}'"
show "--------------------------"

mysql_cmd=""
while read line
	do
		arr=($line)
		limit=${arr[1]}
		if [[ $line == $dbtag* && $limit -ge $dbindex ]]
		then
			host=${arr[2]}
			port=${arr[3]}
			user=${arr[4]}
			password=${arr[5]}
			database=${arr[6]}
			
			#是否需要端口转发
			if [[ $proxyhost == "FALSE" ]]
			then
				mysql_cmd="mysql -h ${host} --port ${port} -u ${user} -p${password} --database=${database}${dbindex} --auto-rehash"
			else
				#使用中转代理机器
				if [[ -n "$proxypwd" ]]
				#使用自动输入密码登录跳板机连接数据库
				then
					show "use pwd login in '$proxyhost'"
					mysql_cmd="exssh $proxyhost $proxypwd mysql -h ${host} --port ${port} -u ${user} -p${password} --database=${database}${dbindex} --auto-rehash"
				else
					show "using port redirect connected"

					p_port=`expr ${limit} + ${port}`

					show proxy redirect port $p_port
					
					proxy_pid=$(netstat -anp | grep ${p_port} | grep LISTEN | awk '{print$NF}' | awk -F '/' '{print $1}' | uniq)

					if [ -n "${proxy_pid}" ]
					then
						RQN=$(netstat -anp | grep ${p_port} | awk 'BEGIN{sum=0};{sum+=$2;};END{print sum}')
						show "mysql proxy pid ${proxy_pid} RQN ${RQN}"
						if ((RQN>0))
						then
							show "restart proxy, kill -9 ${proxy_pid}"
							kill -9 ${proxy_pid}
							ssh -fN -L${p_port}:${host}:${port} tbj
						fi
					else
						ssh -fN -L${p_port}:${host}:${port} tbj
					fi

					mysql_cmd="mysql -h 0.0.0.0 --port ${p_port} -u ${user} -p${password} --database=${database}${dbindex} --auto-rehash"

				fi			
				
			fi
						
			break
		fi
	done < $DBCONF

#connect databases
show "$mysql_cmd"
if [[ -z $sql ]]
then
	$mysql_cmd
else
	show "execute sql: $sql"
	show "$mysql_cmd"
	$mysql_cmd -e "$sql" 2>/dev/null
fi

