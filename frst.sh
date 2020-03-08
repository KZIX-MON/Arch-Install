#!/bin/sh

timedatectl set-ntp true

#lsblk | awk '{print $1}'| dmenu -l 3 > "$sdx"

cat <<EOF | fdisk /dev/sdb
o
n
p


+8G
n
p


+24G
n
p


+24G
n
p


w
EOF


yes | mkfs.ext4 /dev/sdb1
yes | mkfs.ext4 /dev/sdb2
yes | mkfs.ext4 /dev/sdb3

mount /dev/sdb2 /mnt
mkdir -p /mnt/home
mount /dev/sdb3 /mnt/home
mkdir -p /mnt/boot
mount /dev/sdb /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
