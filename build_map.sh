#########################################################################
# File Name: build_map.sh
# Author: jjia
# mail: junjie.jia@cienet.com.cn
# Created Time: Fri 29 Jun 2018 02:45:37 AM UTC
#########################################################################
#!/bin/bash

prem_src=/sandbox-local/jjia/prem_v1
repo_dir=$prem_src/bcm_src/external_repos
#map_src=/sandbox-local/hanyang/12.2
map_src=/sandbox-local/eiliu/MB-PREM-12.2/
map_dest=$prem_src
map_repo_files=("map-agent.repo" "map-agent-sdk.repo" "map-ms-lib.repo" "map-utils.repo" "p2utils.repo" "exa_sdk.repo")

function rm_repo_files(){
	cd $repo_dir
	for i in ${map_repo_files[@]}
	do
		if [ -f $i ]; then
			echo "rm -f $i"
			rm -f $i
		fi
	done
	cd -
}

function cp_map_dir(){
	cd $prem_src
	for i in ${map_repo_files[@]}
	do
		map_dir=`echo $i | cut -d '.' -f 1`
		if [ -d $map_src/$map_dir ]; then
			echo "cp -a $map_src/$map_dir ."
			cp -a $map_src/$map_dir .
		fi
	done
	cd -
}


rm_repo_files
cp_map_dir

