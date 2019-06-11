#!/bin/bash

SERVER_PORT=3301

CLIENT_PORT=3302

CLIENT_IP="./CIP.nchack"
function execmd ( ) {
	while read line
	do
		flag=$(echo "$line" | grep -vE 'closed|Listening|listening')
		
		if ! test "$flag"
		then
			continue;
		fi
		
		echo "REMOTE: $line"
		
		NCHACK_CLIENT_IP=$(echo "$line" | grep -oE '([0-9]+.){3}[0-9]+')
		
		if test "$NCHACK_CLIENT_IP"
		then
			echo "client: $NCHACK_CLIENT_IP"
			echo "$NCHACK_CLIENT_IP" > "$CLIENT_IP"
		else
			sleep 0.5
			NCHACK_CLIENT_IP=`cat $CLIENT_IP`
			echo "send response to $NCHACK_CLIENT_IP $CLIENT_PORT"
			respons=`echo "$line" | /bin/bash`
			echo "${respons}" | nc "$NCHACK_CLIENT_IP" "$CLIENT_PORT"
		fi
	done
}

if (($# > 1))
then
	echo "too many args"
	exit 1
fi

#server model
if (($# == 0))
then
	#server model
	echo "server model start"
	nc -lvk $SERVER_PORT 2>&1 | execmd
	exit 0
fi



#client model
server_ip=$1
echo "client model"

resp=$(nc -vw 8 -z ${server_ip} $SERVER_PORT 2>&1)

flag=$?

if((${flag}!=0))
then
	echo "server can not connect ${server_ip} ${SERVER_PORT}"
	exit 1
fi

for ((;;))
do

	read -p "[nchack@${server_ip}] " ecmd

	! test "$ecmd" && continue

	echo "$ecmd" | nc $server_ip $SERVER_PORT

	nc -l $CLIENT_PORT
done

