#!/bin/sh


if [ -z ${1} ]; then
	echo "Please provide input Firmware filename"
	exit 1
fi

fw=${1}

if [ ! -e ${fw} ]; then
	echo "Firmware file ${fw} does not exist"
	exit 2
fi

if [ -z ${2} ]; then
	echo "Please provide overwrite input subdir path"
	exit 3 
fi

isubdir=${2}

if [ ! -d ${isubdir} ]; then
	echo "Input overwrite Dir ${isubdir} does not exist"
	exit 4
fi

if [ -z ${3} ]; then
        echo "Please provide override output location in RFS"
        exit 5
fi

osubdir=${3}

tmp="tmp"
mkdir ${tmp}
cd ${tmp}
fw="../${fw}"

fwfn=`basename ${fw}`
kernel=${fwfn}.kernel
rfs=${fwfn}.rfs
newfw=${fwfn}.firmware.new
split_fw.sh ${fw} ${kernel} ${rfs}
if [ $? -ne 0 ]; then
	echo "Firmware split failed"
	exit 6
fi

rfs_mounted=squashfs-root
mount_rfs.sh ${rfs} ${rfs_mounted}
if [ $? -ne 0 ]; then
	echo "Mounting ${rfs} failed"
	exit 7
fi

overwrite_subdir.sh ${rfs_mounted} ../${isubdir} ${osubdir}
if [ $? -ne 0 ]; then
	echo "Subdir ${osubdir} overwrite in RFS failed"
	exit 8 
fi

newrfs=${rfs}.new
rebuild_rfs.sh ${rfs_mounted} ${newrfs}
if [ $? -ne 0 ]; then
	echo "Rebuild of SquashFS for ${rfs_mounted} failed"
	exit 9 
fi

merge_2parts.sh ${kernel} ${newrfs} ${newfw}
if [ $? -ne 0 ]; then
	echo "Firmware re-merge of ${kernel} and ${newrfs} failed"
	exit 10 
fi

echo "New rebundled Firmware is at: ${newfw}"
exit 0
