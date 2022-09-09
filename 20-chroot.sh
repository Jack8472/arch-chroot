#!/bin/sh

echo  "=> $(tput setaf 2 bold) Setting up timezone...$(tput sgr0)"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

echo  "=> $(tput setaf 2 bold) Setting hwclock...$(tput sgr0)"
hwclock --systohc

echo  "=> $(tput setaf 2 bold) Setting up locale...$(tput sgr0)"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pl" > /etc/vconsole.conf

echo  "=> $(tput setaf 2 bold) Tweaking pacman.conf...$(tput sgr0)"
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

# Chaotic
echo  "=> $(tput setaf 2 bold) Setting up chaotic-aur...$(tput sgr0)"
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo -ne "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
" >> /etc/pacman.conf

echo  "=> $(tput setaf 2 bold) Installing favourite packages...$(tput sgr0)"
pacman -Syy --needed --noconfirm efibootmgr networkmanager network-manager-applet base-devel \
       linux-headers xorg-server pipewire pipewire-alsa pipewire-pulse pipewire-jack \
       plocate ufw xorg-server ttf-dejavu ttf-liberation ttf-iosevka-nerd qtile picom \
       git fish sudo chezmoi yay lightdm lightdm-gtk-greeter alacritty  \
       firefox xfce4 emacs-nativecomp # big ones, consider commenting

# Optional

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm xf86-video-vmware
# pacman -S --noconfirm intel-ucode
# pacman -S --noconfirm amd-ucode
# pacman -S --noconfirm os-prober 

echo  "=> $(tput setaf 5 bold) Setting up hostname:$(tput sgr0)"
read -p "Hostname:" myhostname
echo "$myhostname" > /etc/hostname

echo  "=> $(tput setaf 5 bold) Setting up root password:$(tput sgr0)"
passwd

echo  "=> $(tput setaf 2 bold) Installing bootloader...$(tput sgr0)"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 
grub-mkconfig -o /boot/grub/grub.cfg
# bootctl install

echo  "=> $(tput setaf 2 bold) Enabling services...$(tput sgr0)"
systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable lightdm.service
systemctl enable ufw.service
systemctl enable plocate-updatedb.timer
systemctl enable btrfs-scrub@-.timer 
systemctl enable btrfs-scrub@home.timer 

echo  "=> $(tput setaf 2 bold) Enabling uncomplicated firewall...$(tput sgr0)"
ufw enable

echo  "=> $(tput setaf 5 bold) Setting up user:$(tput sgr0)"
read -p "Username:" username
useradd -m $username 
usermod -aG wheel $username
passwd $username

echo  "=> $(tput setaf 2 bold) Setting up default user shells...$(tput sgr0)"
chsh -s /usr/bin/fish $username
chsh -s /usr/bin/fish root

echo  "=> $(tput setaf 2 bold) Allowing wheel sudo...$(tput sgr0)"
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

echo  "=> $(tput setaf 1 bold) Done. Exit and reboot.$(tput sgr0)"
