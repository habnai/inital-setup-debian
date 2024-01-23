#!/bin/bash
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use the root user to install the software."
    exit 1
fi
# exit when any command fails
set -e
apt -y install ssh openssh-server sudo
apt install net-tools
/usr/bin/mv  /etc/network/interfaces  /etc/network/interfaces.bak
/usr/bin/touch  /etc/network/interfaces
/usr/bin/cat <<EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet static
        address 10.11.20.35
        netmask 255.255.255.0
        network 10.11.20.0
        broadcast 10.11.20.255
        gateway 10.11.20.1

# This is an autoconfigured IPv6 interface
iface enp0s3 inet6 auto
EOF
systemctl restart networking

#### ssh-copy-id -i ~/.ssh/id_ed25519.pub user@10.11.20.35 ##


