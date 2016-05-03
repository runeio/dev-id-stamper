#!/bin/sh


if [ -z ${1} ]; then
	echo "Please provide an input RFS file name"
	exit 1
fi

rfs=${1}
if [ ! -e ${rfs} ]; then
	echo "SquashFS File ${rfs} does not exist"
	exit 2
fi

if [ -z ${2} ]; then
	echo "Please provide an mount-point for Root"
	exit 3
fi

root_mount=${2}
if [ -d ${root_mount} ]; then
	echo "Warning: Root mount-point ${root_mount} already exists"
fi

offs_line=`grep -obUaP "\x68\x73\x71\x73" ${rfs}`
if [ $? -ne 0 ]; then
        echo "SquashFS signature not found in SquashFS file: ${rfs}"
        exit 4 
fi

offs=`echo ${offs_line} | cut -f1 -d':'`
echo "Offset of SquashFS RFS is ${offs}"
if [ ${offs} -ne 0 ]; then
	echo "Wrong RFS file. Offset of SquashFS signature is not 0 ${offs}"
	exit 5
fi

# squashfs-root is the default path, if not supplying -d<path>
rm -rf ${root_mount}
echo "Expanding"
sudo `which unsquashfs4` -d ${root_mount} ${rfs}
if [ $? -ne 0 ]; then
	echo "Unsquashfs of ${rfs} failed"
	exit 6 
fi

if [ ! -d ${root_mount}/sbin ]; then
	echo "Problem mounting root."
	exit 7
fi

echo "Root mounted at ${root_mount}"
exit 0
