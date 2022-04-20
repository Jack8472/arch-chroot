#!/bin/sh

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drive is not mounted can not continue"
    exit
fi

sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf
reflector --latest 20 --protocol https --sort rate --number 5 --save /etc/pacman.d/mirrorlist
pacman -Syy
pacstrap /mnt base linux linux-firmware vim reflector grub btrfs-progs

genfstab -U /mnt >> /mnt/etc/fstab

cp 20-chroot.sh /mnt/
chmod +x /mnt/20-chroot.sh
cp 30-config.sh /mnt
chmod +x /mnt/30-config.sh

echo "Do arch-chroot now..."
