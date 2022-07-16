#!/bin/sh

echo  "=> $(tput setaf 2 bold) Setting up timezone..."
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

echo  "=> $(tput setaf 2 bold) Setting hwclock..."
hwclock --systohc

echo  "=> $(tput setaf 2 bold) Setting up locale..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pl" > /etc/vconsole.conf

echo  "=> $(tput setaf 2 bold) Tweaking pacman.conf..."
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

# Chaotic
echo  "=> $(tput setaf 2 bold) Setting up chaotic-aur..."
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo -ne "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
" >> /etc/pacman.conf

echo  "=> $(tput setaf 2 bold) Installing favourite packages..."
pacman -Syy --needed efibootmgr networkmanager network-manager-applet base-devel linux-headers xorg-server pipewire pipewire-alsa pipewire-pulse pipewire-jack plocate ufw xorg-server ttf-dejavu ttf-liberation ttf-iosevka-nerd qtile picom git fish sudo xfce4 lightdm lightdm-gtk-greeter alacritty emacs-nativecomp firefox yay chezmoi

# Optional

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm xf86-video-vmware
# pacman -S --noconfirm intel-ucode
# pacman -S --noconfirm amd-ucode
# pacman -S --noconfirm os-prober 

echo  "=> $(tput setaf 5 bold) Setting up hostname:"
read -p "Hostname:" myhostname
echo "$myhostname" > /etc/hostname

echo  "=> $(tput setaf 5 bold) Setting up root password:"
passwd

echo  "=> $(tput setaf 2 bold) Installing grub..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 
grub-mkconfig -o /boot/grub/grub.cfg

echo  "=> $(tput setaf 2 bold) Enabling services..."
systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable lightdm.service
systemctl enable ufw.service
systemctl enable plocate-updatedb.timer
systemctl enable btrfs-scrub@-.timer 
systemctl enable btrfs-scrub@home.timer 

echo  "=> $(tput setaf 2 bold) timedatectl..."
timedatectl set-ntp true

echo  "=> $(tput setaf 2 bold) Enabling uncomplicated firewall..."
ufw enable

echo  "=> $(tput setaf 5 bold) Setting up user:"
read -p "Username:" username
useradd -m $username 
usermod -aG wheel $username
passwd $username

echo  "=> $(tput setaf 2 bold) Setting up default user shells..."
chsh -s /usr/bin/fish $username
chsh -s /usr/bin/fish root

echo  "=> $(tput setaf 2 bold) Allowing wheel sudo..."
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

echo  "=> $(tput setaf 1 bold) Done. Exit and reboot."
