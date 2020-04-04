#!/bin/sh

ip=`env | grep SSH_CLIENT | cut -d '=' -f 2 | cut -d ' ' -f 1`
echo $ip

ip1=$ip
ip2="172.17.0.1"

#ip1=`echo $ip | tr '.' 'p'`
#ip2=`echo '172.17.0.1' | tr '.' 'p'`

#change this for Personal tailor
username=jjia
passwd=111111

if [ "$ip1" != "$ip2" ];then
    echo "ssh to premdev01 ..."
    sshpass -p $passwd ssh $username@premdev01
    exit 0
fi


#change this for Personal tailor
if [ $# -ne 1 ]; then
	project=8x4SG         #compile 8x4SG by default
#    src=/sandbox-local/$username/prem_v1
    src=/sandbox-local/$username/repo
else
	project=$1
    src=/sandbox-local/$username/$project
fi

if [ ! -d $src ];then
    echo "dir $src no exist!"
    exit 1
fi

bcm_src=$src/bcm_src
build=$bcm_src/build
#map_src=/sandbox-local/hanyang/MB12.2/
#map_src=/sandbox-local/eiliu/MB-PREM-12.2/
map_src=/sandbox-local/lma/prem_12.2.9.6/
map_dest=$src

repo_dir=$bcm_src/external_repos
map_repo_files=("map-agent.repo" "map-agent-sdk.repo" "map-ms-lib.repo" "map-utils.repo" "p2utils.repo" "exa_sdk.repo" "map-l2.repo" "map-lldp.repo") 

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
    for i in ${map_repo_files[@]}
    do
        map_dir=`echo $i | cut -d '.' -f 1`
        if [ -d $map_src/$map_dir ]; then
			if [ ! -d $map_dest/$map_dir ]; then
				echo "mkdir $map_dir"
				mkdir $map_dest/$map_dir
			fi
            echo "cp -a $map_src/$map_dir ."
			cp -a $map_src/$map_dir/* $map_dest/$map_dir
        fi
    done
}

#checkout repo dir first
#cd $repo_dir
#git checkout .
#cd -

#check if compile map-agent
#if [ -f $repo_dir/map-agent.repo ]; then
#	rm_repo_files
#	cp_map_dir
#else
#	cd $src/exa_sdk && git checkout .
#fi

#final build
cd $build && ./build8xx.pl --project=$project


