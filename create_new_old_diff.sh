#########################################################################
# File Name: new_old_diff.sh
# Author: jjia
# mail: junjie.jia@cienet.com.cn
# Created Time: Thu 01 Nov 2018 11:51:27 AM CST
#########################################################################
#!/bin/bash

src=$PWD
#/home/jjia/prem/bcm_src
#/sandbox-local/jjia/prem_v1/bcm_src

dest_dir=/sandbox-local/jjia/NEW_OLD

function create_current_new(){
	cd $src
	git diff --name-only | xargs tar -cf $dest_dir/new.tar
	if [ $? -ne 0 ]; then
		echo "Error *** not in a git repostory or not have any diffrence!"
		return 1
	fi
	mkdir -p $dest_dir/new
	tar -xf $dest_dir/new.tar -C $dest_dir/new
	rm $dest_dir/new.tar
	cd - > /dev/null
	return 0
}

function create_current_old(){
	cd $src
	commitid=`git rev-parse HEAD`
	if [ $? -ne 0 ]; then
		echo "Error *** not in a git repostory!"
		return 1
	fi
	git archive -o $dest_dir/old.tar $commitid $(git diff --name-only)
	mkdir -p $dest_dir/old
	tar -xf $dest_dir/old.tar -C $dest_dir/old
	rm $dest_dir/old.tar
	cd - > /dev/null
	return 0
}

function create_current_diff(){
	create_current_new
	if [ $? -ne 0 ];then
		exit 1
	fi
	create_current_old
	if [ $? -ne 0 ];then
		exit 1
	fi
	return 0
}

function find_hist_commitid(){
	if [ $# -ne 1 ];then
		echo "Error *** create_history_diff missing params!"
		return 1
	fi

	new_commitid=$1
	old_commitid=''
	found=0
	i=0
	git log --pretty=oneline > $dest_dir/.tmp
	while read line
	do
		let i++
		#echo "$i found=$found $line"
		if [ $found -eq 1 ]; then
			old_commitid=`echo $line | cut -d ' ' -f 1`
			echo "old_commitid=$old_commitid"
			break
		fi

		echo $line | grep $new_commitid > /dev/null
		if [ $? -eq 0 ]; then
			#echo "find commit $new_commitid"
			found=1
		fi
	done < $dest_dir/.tmp
	#echo "found=$found old_commitid=$old_commitid"
	rm -f $dest_dir/.tmp

	if [ $found -eq 0 ]; then
		echo "Error *** commit $new_commitid not found!!"
		return 1
	fi

	return 0
}

function create_history_diff(){
	if [ $# -ne 1 ];then
		echo "Error *** create_history_diff missing params!"
		return 1
	fi

	new_commitid=$1
	find_hist_commitid $new_commitid
	if [ $? -ne 0 ]; then
		echo "can't find history commit"
		return 1
	fi
	files=`git diff $new_commitid $old_commitid --name-only`
	git archive -o $dest_dir/new.tar $new_commitid $files
	git archive -o $dest_dir/old.tar $old_commitid $files

	unpack_tar
	return 0
}

function unpack_tar(){
	mkdir -p $dest_dir/new $dest_dir/old
	tar -xf $dest_dir/new.tar -C $dest_dir/new
	tar -xf $dest_dir/old.tar -C $dest_dir/old
	rm $dest_dir/new.tar $dest_dir/old.tar
}

mkdir -p $dest_dir
rm -rf $dest_dir/new
rm -rf $dest_dir/old

if [ $# -eq 0 ]; then
	echo "create current diffs..."
	create_current_diff
else
	echo "create history commit diffs..."
	create_history_diff $1
fi
