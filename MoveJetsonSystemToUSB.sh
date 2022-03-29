#!/bin/bash
# Copyright (c) 2022 Andre1506 
# MIT License
# Move the Jetson OS to USB


sudo parted -s /dev/$1 "mklabel gpt"
sudo parted -s /dev/$1 "mkpart primary ext4 1M -1"
sudo mkfs -t ext4 "/dev/"$1"1"
sudo mount -t ext4 "/dev/"$1"1" /mnt/
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude=/proc / /mnt/
PARTUUID_STRING=$(sudo blkid -o value -s PARTUUID "/dev/"$1"1")
BOOT_ORG='root=/dev/mmcblk0p1'
BOOT_NEW='root=PARTUUID='$PARTUUID_STRING
sudo sed -i "s!$BOOT_ORG!$BOOT_NEW!" /boot/extlinux/extlinux.conf
sudo reboot

