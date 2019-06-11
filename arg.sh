#!/bin/bash

echo "$@"

arg=($@)
num=$(($#-1))
echo  ${arg[@]:1:$num}
