#!/bin/sh

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=pl" >> /etc/vconsole.conf

pacman -S grub efibootmgr networkmanager network-manager-applet base-devel linux-headers pipewire pipewire-alsa pipewire-pulse pipewire-jack reflector plocate ufw xorg-server ttf-iosevka-nerd qtile picom git fish sudo btrfs-progs vim xfce4 lightdm lightdm-gtk-greeter alacritty emacs ttc-iosevka-aile xorg-server firefox

# xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils 

# optional
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# pacman -S --noconfirm intel-ucode
# pacman -S --noconfirm amd-ucode

mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable lightdm.service
systemctl enable ufw.service
systemctl enable plocate-updatedb.timer
stemctl enable btrfs-scrub@-.timer 
systemctl enable btrfs-scrub@home.timer 

printf "Next: set root password; set hostname; add user and make sudoer."
