#!/bin/bash

dir=$(pwd)

cd $dir

config_files=$( find ./ -name .settings -o -name .project -o -name .idea -o -name .classpath -o -name .idea -o -name *.iml )

for f in $config_files
do
	rm -rf $f
	echo "[CLEAN] $f"
done

echo Project reset success!

