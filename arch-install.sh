#!/bin/sh

read -p "Which partion do you want to use? " sdx

timedatectl set-ntp true

umount -R /mnt || echo "nothing to unmount" 

wipefs -a /dev/"$sdx"

echo "Numbers only [Max size is 512M]"
echo "In Megabytes:"
read -p "Boot Partition Size: " boot
echo "Numbers only"
echo "In Gigabytes"
read -p "Root Partition Size: " root
echo "Numbers Only"
echo "In Gigabytes"
read -p "Home Partition Size: " home

cat <<EOF | fdisk /dev/"$sdx"
o
n
p


+${boot}M
n
p


+${root}G
n
p


+${home}G
n
p


w
EOF


yes | mkfs.ext4 /dev/"$sdx"1
yes | mkfs.ext4 /dev/"$sdx"2
yes | mkfs.ext4 /dev/"$sdx"3

mount /dev/"$sdx"2 /mnt
mkdir -p /mnt/home
mount /dev/"$sdx"3 /mnt/home
mkdir -p /mnt/boot
mount /dev/"$sdx"1 /mnt/boot

cp chroot.sh /mnt/root

echo "Execute the following on your own PC:"
echo "pacstrap /mnt base base-devel linux linux-firmware vi"
echo ""
echo "After executing pacstrap, Execute this command:"
echo "genfstab -U /mnt >> /mnt/etc/fstab"
echo "After executing genfstab, Execute this command:"
echo "arch-chroot /mnt"
