#!/bin/sh

echo "Checking mounts..."
if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drives not mounted, will not continue."
    exit 2
fi

SCRIPT_DIR="$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )"

echo "Adjusting pacman configuration and configuring mirrors."
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf
reflector --latest 20 --protocol https --sort rate --number 5 --save /etc/pacman.d/mirrorlist
echo "Updating pacman db..."
pacman -Syy
echo "Pacstrap..."
pacstrap /mnt base linux linux-firmware vim reflector grub btrfs-progs
echo "genfstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo "copy mirrorlist..."
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo "cp & +x 20-chroot.sh..."
cp $SCRIPT_DIR/20-chroot.sh /mnt/
chmod +x /mnt/20-chroot.sh

echo "DO: arch-chroot /mnt"
