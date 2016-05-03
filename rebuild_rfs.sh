#!/bin/sh

if [ -z ${1} ]; then
	echo "Please provide an input subdir name"
	exit 1
fi

if [ ! -d ${1} ]; then
	echo "Input param must be a sub-directory"
	exit 2
fi

if [ -z ${2} ]; then
        echo "Please provide an output SquashFS squashed file name"
        exit 2
fi

rfsdir=${1}
rfssquashed=${2}
sudo rm -f {rfssquashed}

sudo `which mksquashfs4` ${rfsdir} ${rfssquashed} -nopad -noappend -root-owned -comp xz -Xpreset 9 -Xe -Xlc 0 -Xlp 2 -Xpb 2  -b 256k -p '/dev d 755 0 0' -p '/dev/console c 600 0 0 5 1' -processors 1
sudo chmod o+rw ${rfssquashed}

padjffs2 ${rfssquashed} 64
exit 0
