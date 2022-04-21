#!/bin/sh

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=pl" >> /etc/vconsole.conf

reflector --latest 20 --protocol https --sort rate --number 5 --save /etc/pacman.d/mirrorlist

sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf
reflector --latest 20 --protocol https --sort rate --number 5 --save /etc/pacman.d/mirrorlist

pacman -Syy efibootmgr networkmanager network-manager-applet base-devel linux-headers pipewire pipewire-alsa pipewire-pulse pipewire-jack plocate ufw xorg-server ttf-iosevka-nerd qtile picom git fish sudo xfce4 lightdm lightdm-gtk-greeter alacritty emacs ttc-iosevka-aile xorg-server firefox

# optional

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm xf86-video-vmware
# pacman -S --noconfirm intel-ucode
# pacman -S --noconfirm amd-ucode
# pacman -S --noconfirm os-prober 

vim /etc/hostname
echo "Setting root password:"
passwd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable lightdm.service
systemctl enable ufw.service
systemctl enable plocate-updatedb.timer
systemctl enable btrfs-scrub@-.timer 
systemctl enable btrfs-scrub@home.timer 

timedatectl set-ntp true

echo "Setting up user:"
read -p "Username:" username
useradd $username # WARNING: consider -m flag
usermod -aG wheel $username
passwd $username
chsh -s /usr/bin/fish $username
chsh -s /usr/bin/fish root
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

printf "Done. Exit and reboot."
