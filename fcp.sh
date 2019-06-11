#!/bin/bash

FCP_PORT=7761

function log( ) {
	echo -e $(date +"%Y-%m-%d %H:%M:%S") " -- $@"
}

test "$3" && log "too manay args" && exit 1

test ! "$1" && log "server model:fcp.sh [file] [host]\n client model: fcp.sh [file]" && exit 1

if test "$2" ; then

test ! -f "$1" && log "can not find $1" && exit 1

log "start send file $1 to host $2"

nc -vu -w 2 $2 $FCP_PORT < "$1" && log "send finished " && exit 0

log "copy file faild $1 $2"
exit 1

fi




if test "$1"; then

ps -ef | grep "nc -v $FCP_PORT -lk" | grep -v grep | awk '{print "send kill sign to pid " $2;system("kill -9 "$2)}'

log "start watting file revive $1"

nc -vu $FCP_PORT -l > "$1" && log "recive success " && exit 0

log "recive file failed $1"
exit 1

fi
