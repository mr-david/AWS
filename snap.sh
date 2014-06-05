#!/bin/bash

# this script will take a snapshot of volumes matching $1
# TODO
# convert this to use the python based AWS tools

# set up environment
. /home/dcolon/.bash_profile

regex="$1"

ec2-describe-volumes | egrep $regex | while read line
do
    name=$(echo $line | awk '{print $5}')
    volumeid=$(echo $line | awk '{print $3}')
    datecode=$(date +"%Y%m%d.%H%M")
    #echo "hostname is $name and volumeid is $volumeid"
    snap=$(ec2-create-snapshot $volumeid -d "$name.$datecode")
    snapid=$(echo $snap | awk '{print $2}')
    ec2-create-tags $snapid -t "Name=$name.$datecode"
    if [ $? -ne 0 ]; then
        echo "error creating tag for $snapid of $volumeid"
    fi
done


### TAG     volume  vol-e55a7c8b    Name    marketplace-fe-1-root
### TAG     volume  vol-2323054d    Name    marketplace-fe-2-root
### TAG     volume  vol-ef2e0881    Name    marketplace-solr-slave-1-root
### TAG     volume  vol-3d2f0953    Name    marketplace-solr-slave-2-root
### TAG     volume  vol-3f2c0a51    Name    marketplace-feedloader-root
### TAG     volume  vol-8b2d0be5    Name    marketplace-solr-master
