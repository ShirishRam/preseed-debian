#!/bin/bash

ISO_FILE=$1
PRESEEDED_ISO_FILE=$2
PARENT=`pwd`

if [ ! -d $PARENT/temp ]; then
    mkdir $PARENT/temp
fi

cd $PARENT/temp

if [ -f $PRESEEDED_ISO_FILE ]; then
    rm -f $PRESEEDED_ISO_FILE
fi

mkdir loopdir
mount -o loop $ISO_FILE loopdir
mkdir cd
rsync -a -H --exclude=TRANS.TBL loopdir/ cd
umount loopdir
mkdir irmod
cd irmod
gzip -d < ../cd/install.386/initrd.gz | cpio --extract --make-directories --no-absolute-filenames
cp $PARENT/my_preseed.cfg ./preseed.cfg
find . | cpio -H newc --create | gzip -9 > ../cd/install.386/initrd.gz
cd ..
rm -fr irmod
cd cd
cp $PARENT/delete_partition.sh ./delete_partition.sh
md5sum `find -follow -type f` > md5sum.txt
cd ..
genisoimage -o $PRESEEDED_ISO_FILE -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ./cd

rm -rf $PARENT/temp/loopdir
rm -rf $PARENT/temp/cd
