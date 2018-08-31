
IMAGE_PATH=$1

if [ "$1" = "" ]; then
    echo "Please provide the file path of the image"
    exit 1
fi

kvm -m 1024 -hda $IMAGE_PATH
