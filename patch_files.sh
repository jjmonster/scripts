#########################################################################
# File Name: patch_files.sh
# Author: jjia
# mail: junjie.jia@cienet.com.cn
# Created Time: Fri 19 Oct 2018 07:40:06 AM UTC
#########################################################################
#!/bin/sh


if [ $# -ne 1 ];then
	echo "no params!"
	exit 1
fi

patches=$1
curr_path=$PWD
src=/sandbox-local/jjia/844F/bcm_src
commit_patch4="28526f1f4d5cac33778416ac75c9fa5083778864"
commit_patch5="15ab77a5ebe5305463b3baeb31abd424d99d6638"

if [ -f $patches ];then #patch is only one file (changes_data_src_patchx.diff).
	while read line
	do
		if [[ $line =~ "--- ../base" ]];then     #repleace the prefix path
			let p=0
			file=`echo $line | cut -d ' ' -f 2`
			newfile=${file/"../base/"/"bcm963xx/"}
			if [ -f $src/$newfile ];then      #we have same file in bcm_src directory.
				echo "--- $newfile"
				cd $src
				#echo $newfile
				#pick one file diff from the base commit.
				git show $commit_patch4 $newfile >> $curr_path/newdiff #| patch -p1
				cd - > /dev/null
				let p=0
			fi
		elif [ $p -eq 1 ]; then #following lines will be print out
			echo "$line"
		fi
	done < $patches
elif [ -d $patches ];then           #patch is a directory include binaries (newbins).
	lines=`find $patches -type f`
	for i in $lines
	do
		#file=`echo $i | awk -F / '{print $NF}'`
		#find $src -name $file
		pathfile=`echo $i | cut -d / -f 5-`
		echo "--- $pathfile"
		if [ -f $src/bcm963xx/$pathfile ];then
			echo $src/bcm963xx/$pathfile
		fi
	done
fi
