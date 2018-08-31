### Script to install 2 Debian images on Qemu

ISO_FILE=$1
PRESEEDED_ISO_1=$2
PRESEEDED_ISO_2=$3
IMAGE_FILE=$4
SIZE=$5

if [ "$1" = "" ]; then
    echo "Please provide the ISO path"
    exit 1
fi

if [ "$2" = "" ]; then
    echo "Please provide the preseed ISO path for the first image"
    exit 1
fi

if [ "$3" = "" ]; then
    echo "Please provide the preseed ISO path for the second image"
    exit 1
fi

if [ "$4" = "" ]; then
    echo "Please provide path for HDD image"
    exit 1
fi

if [ "$5" = "" ]; then
    echo "Please provide HDD image size"
    exit 1
fi


echo "Re-mastering the ISO files"

cp my_preseed_1.cfg my_preseed.cfg
### Run the script which re-masters the ISO for the first Debian image
sh preseed_edit_iso.sh $ISO_FILE $PRESEEDED_ISO_1

cp my_preseed_2.cfg my_preseed.cfg
### Run the script which re-masters the ISO for the second Debian image
sh preseed_edit_iso.sh $ISO_FILE $PRESEEDED_ISO_2

echo "Generated the ISO files"

sleep 5

echo "Creating HDD image"

### Create HDD image
qemu-img create $IMAGE_FILE $SIZE

echo "Image of size "$SIZE" created"

echo "Running Qemu to install the first Debian image"

### Run Qemu (KVM) to install the first Debian image
kvm -hda $IMAGE -cdrom $PRESEEDED_ISO_1 -boot d -m 1024

echo "Finished with installation of first Debian image"
sleep 5


echo -n "Have you deleted the partition?(y/n): "
read var
if [ "$var" = "n" ];
	then exit 0;
fi


echo "Running Qemu to install the second Debian image"

### Run Qemu (KVM) to install the first Debian image
kvm -hda $IMAGE -cdrom $PRESEEDED_ISO_2 -boot d -m 1024

echo "Finished with installation of second Debian image"
