#!/bin/sh

localectl set-x11-keymap pl "" "" caps:escape,compose:prsc,compose:menu,terminate:ctrl_alt_bksp,eurosign:4

# Chaotic
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo -ne "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
" >> /etc/pacman.conf

pacman -Syy yay 

ufw enable

updatedb
