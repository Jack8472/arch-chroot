#!/bin/sh

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drive is not mounted can not continue"
    exit
fi

reflector --latest 50 --protocol https --sort rate --number 5 --save /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware 

genfstab -U /mnt >> /mnt/etc/fstab

cp 20-chroot.sh /mnt/
chmod +x /mnt/20-chroot.sh

echo "Do arch-chroot now..."
