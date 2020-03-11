#Chroot

echo "root password:"
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

read -p "Enter your username: " $user

useradd -a -m -G audio,optical,storage,video,wheel $user

echo "$user password:"

passwd $user
