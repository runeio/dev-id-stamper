#!/bin/sh

if [ -z ${1} ]; then
	echo "Please provide an input Firmware bundle filename"
	exit 1
fi

fw=${1}
if [ ! -e ${fw} ]; then
	echo "Firmware file ${fw} does not exist"
	exit 2
fi

if [ -z ${2} ]; then
	echo "Please provide output Kernel filename"
	exit 3
fi
fw_kernel=${2}

if [ -z ${3} ]; then
	echo "Please provide output RFS filename"
	exit 4
fi
fw_rfs=${3}

rm -f ${fw_kernel} ${fw_rfs}

offs_line=`grep -obUaP "\x68\x73\x71\x73" ${fw}`
if [ $? -ne 0 ]; then
	echo "SquashFS signature not found in Firmware: ${fw}"
	exit 1
fi

offs=`echo ${offs_line} | cut -f1 -d':'`
echo "Offset of SquashFS RFS is ${offs}"

dd if=${fw} of=${fw_kernel} bs=1 count=${offs}
dd if=${fw} of=${fw_rfs} bs=1 skip=${offs}
exit 0
