#! /bin/bash

# Get timestamp
timeStamp=`date "+%Y%m%d-%H%M%S"`
# Define server list
serverList=("XXX" "YYY" "ZZZ")
# Defining the number of snapshots to keep
keepNum=5
# Get backup for each server
for ((i=0 ; i<`echo ${#serverList[*]}` ; i++))
do
	# Take snapshot
	VBoxManage snapshot "${serverList[i]}" take "${serverList[i]}-${timeStamp}"
	# Check the number of snapshots
	snapshotNum=`VBoxManage snapshot "${serverList[i]}" list | grep "${serverList[i]}" -c`
	# If the number of snapshots is more than the set number, delete the oldest one
	if [ ${snapshotNum} -gt ${keepNum} ]; then
		cycle=`echo $((${snapshotNum} - ${keepNum}))`
		for ((j=0 ; j<${cycle} ; j++))
		do
			deleteName=`VBoxManage snapshot "${serverList[i]}" list | grep ${serverList[i]} -m1 | awk '{print $2}'`
			VBoxManage snapshot "${serverList[i]}" delete "${deleteName}"
		done
	fi
done
