#!/bin/bash
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License
# Copy the root directory to the given volume


sudo parted -s /dev/$1 "mklabel gpt"
sudo parted -s /dev/$1 "mkpart primary ext4 1M -1"
sudo mkfs -t ext4 "/dev/"$1"1"
sudo mount -t ext4 "/dev/"$1"1"/mnt/
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude=/proc / /mnt/
PARTUUID_STRING=$(sudo blkid -o value -s PARTUUID $PARTITION_TARGET)
sudo sed -i 's/"root=/dev/mmcblk0p1"/"root=PARTUUID="$PARTUUID_STRING' /boot/extlinux/extlinux.conf
sudo reboot

