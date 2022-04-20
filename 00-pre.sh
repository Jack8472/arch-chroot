#!/bin/sh

loadkeys pl

timedatectl set-ntp true

chmod +x 10-init.sh

echo "Setup and mount partitions!"
