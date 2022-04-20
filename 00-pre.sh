#!/bin/sh

loadkeys pl

iwctl

timedatectl set-ntp true

chmod +x 10-init.sh

echo "Setup and mount partitions!"
