#!/bin/sh

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drives not mounted, will not continue."
    exit 2
fi

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf
reflector --latest 20 --protocol https --sort rate --number 5 --save /etc/pacman.d/mirrorlist
pacman -Syy
pacstrap /mnt base linux linux-firmware vim reflector grub btrfs-progs

genfstab -U /mnt >> /mnt/etc/fstab

cp $SCRIPT_DIR/20-chroot.sh /mnt/
chmod +x /mnt/20-chroot.sh

echo "Do arch-chroot!"
