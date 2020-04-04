#########################################################################
# File Name: vopen.sh
# Author: jjia
# mail: junjie.jia@cienet.com.cn
# Created Time: Tue 03 Jul 2018 05:49:08 PM CST
#########################################################################
#!/bin/bash

info=`cat ~/.viminfo | grep "$1"`
if [ $? -ne 0 ]; then
	info=`find $src/bcm_src/ -name "$1"`
	if [ $? -ne 0 ]; then
		echo "Fail find $1"
		exit 0
	fi
fi

for line in $info
do
	echo $line | grep "bcm_src"
	if [ $? -eq 0 ]; then
		vim $line
		echo $line
		break
	fi
done




