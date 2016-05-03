#!/bin/sh

if [ -z ${1} ]; then
	echo "Please provide an input Kernel file name"
	exit 1
fi

if [ -z ${2} ]; then
	echo "Please provide an input RFS SquashFS file name"
	exit 2
fi

if [ -z ${3} ]; then
	echo "Please provide an output Merged Firmware file name"
	exit 3
fi

kernel=${1}
rfs=${2}
fw=${3}

( dd if=${kernel} bs=65536 conv=sync;  dd if=${rfs} )  > ${fw}

echo "Firmware is `ls -al ${fw}`"
exit 0
