#!/bin/bash

# This script will mount local ssd files.
# See https://help.aliyun.com/document_detail/25426.html for details.

DEV=$1
POINT=$2

sudo apt-get update
sudo apt-get install -y \
    parted \
    e2fsprogs

set -ue

parted /dev/${DEV} <<EOF
mklabel gpt
mkpart primary 1 100%
align-check optimal 1
print
quit
EOF

# reload partition table.
partprobe

# display partition info.
fdisk -lu /dev/${DEV}

DEV_PARTITION=`fdisk -lu /dev/${DEV} | awk '/Linux filesystem/{device=1} END{print $device}'`

# make file system for partition.
yes | mkfs -t ext4 ${DEV_PARTITION}

cp /etc/fstab /etc/fstab.bak.mount.${DEV}

echo $(blkid ${DEV_PARTITION} | awk '{print $2}' | sed 's/\"//g') /${POINT} ext4 defaults 0 0 >>/etc/fstab

cat /etc/fstab
mount -a
df -h
