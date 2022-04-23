#!/bin/sh

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pl" > /etc/vconsole.conf

sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

pacman -Syy efibootmgr networkmanager network-manager-applet base-devel linux-headers pipewire pipewire-alsa pipewire-pulse pipewire-jack plocate ufw xorg-server ttf-iosevka-nerd qtile picom git fish sudo xfce4 lightdm lightdm-gtk-greeter alacritty emacs ttc-iosevka-aile xorg-server firefox

# Chaotic
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo -ne "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
" >> /etc/pacman.conf

pacman -Syy yay 

# Optional

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm xf86-video-vmware
# pacman -S --noconfirm intel-ucode
# pacman -S --noconfirm amd-ucode
# pacman -S --noconfirm os-prober 

echo "Setting up hostname:"
read -p "Hostname:" myhostname
echo "$myhostname" > /etc/hostname

echo "Setting up root password:"
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
ufw enable

echo "Setting up user:"
read -p "Username:" username
useradd -m $username 
usermod -aG wheel $username
passwd $username
chsh -s /usr/bin/fish $username
chsh -s /usr/bin/fish root
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

printf "Done. Exit and reboot."
