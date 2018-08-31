#!/bin/sh

PARTITION_NO=$1

fdisk -u -p /dev/sda <<EOF
d
$PARTITION_NO

w
EOF
