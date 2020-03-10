#!/bin/sh

read -p "Which partion do you want to use? " sdx

timedatectl set-ntp true

#lsblk | awk '{print $1}'| dmenu -l 3 > "$sdx"

cat <<EOF | fdisk /dev/"$sdx"
o
n
p


+512M
n
p


+26G
n
p


+24G
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

pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

#Chroot

passwd

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#For the Lang Variable
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

#for the fonts
echo "en_US.UTF-8 UTF-8" >> /etc/loacle.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

#Network Manager
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

#Grub
pacman -S --noconfirm grub
grub-install --target=i386-pc /dev/sdb 
grub-mkconfig -o /boot/grub/grub.cfg

useradd -aG audio,optical,storage,video,wheel jason
passwd jason

exit

umount -R /mnt || echo "Please Retry" && exit

lsblk

reboot
