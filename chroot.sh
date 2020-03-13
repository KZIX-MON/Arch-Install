#Chroot

echo "root password:"
passwd

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#for the fonts
echo "en_US.UTF-8 UTF-8" >> /etc/loacle.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

#For the Lang Variable
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

#Network Manager
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

#Grub
pacman -S --noconfirm grub
grub-install --target=i386-pc /dev/sdb 
grub-mkconfig -o /boot/grub/grub.cfg

#Hostname
read -p "Enter your hostname" host
echo "$host" >> /etc/hostname

echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1		$host.localdomain	$host" >> /etc/hosts

#Non-Root User
read -p "Enter your username: " user
useradd -m $user
usermod -a -G wheel,audio,storage,video,optical $user
echo "$user password:"

passwd $user

#Config
visudo
vi /etc/fstab
vi /etc/hosts
vi /etc/hostname
vi /etc/pacman.conf

echo "Installation Complete!"
