#!/bin/sh

if [ -z ${1} ]; then
	echo "Please provide Rooth path of mounted RFS"
	exit 1
fi

root=${1}
if [ ! -d ${root} ]; then
	echo "SquashFS not mounted at ${root}"
	exit 2
fi

if [ -z ${2} ]; then
	echo "Please provide override input subdir path"
	exit 3
fi

isubdir=${2}
if [ ! -d ${isubdir} ]; then
	echo "Dir ${isubdir} does not exist"
	exit 4
fi

if [ -z ${3} ]; then
        echo "Please provide override output location in RFS"
        exit 4
fi

osubdir=${3}
if [ ! -d ${root}/${osubdir} ]; then
	echo "Warning: SquashFS at ${root} does not contain ${osubdir}"
fi

echo "Subdir ${root}/${osubdir} will be replaced with ${isubdir}"

#prompt ?

sudo rm -rf ${root}/${osubdir}
sudo cp -rf ${isubdir} ${root}/${osubdir}
sync

exit 0
