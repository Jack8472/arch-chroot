#!/bin/sh

ping -q -w5 -c1 8.8.8.8  >/dev/null 2>&1
online=$?
if [ $online -ne 0 ]; then
    echo "Offline."
    exit 2
fi

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

loadkeys pl

timedatectl set-ntp true

chmod +x $SCRIPT_DIR/10-init.sh

echo "Setup and mount partitions!"
