#!/bin/bash
##########################################################################################
# Debian 11+ x86_64
# https://github.com/habnai/debian-install.sh
##########################################################################################
# PREPARATIONS FOR INSTALLATION
/usr/bin/apt install -y figlet
/usr/bin/touch /etc/motd
figlet Debian > /etc/motd
/usr/bin/touch /etc/motd
/usr/bin/cat <<EOF >> /etc/motd
EOF
# Global function to update and clean the system
function update_and_clean() {
  /usr/bin/apt update -q4
  /usr/bin/apt upgrade -yq4
  /usr/bin/apt autoclean -yq4
  /usr/bin/apt autoremove -yq4
  }
# Cosmetic feature that uses points to reflect progress during longer processes
CrI() {
  while ps "$!" > /dev/null; do
  echo -n '.'
  sleep '1.0'
  done
  /usr/bin/echo ''
  }

# START SETUP
/usr/bin/mv /etc/apt/sources.list /etc/apt/sources.list.bak
/usr/bin/touch /etc/apt/sources.list
/usr/bin/cat <<EOF >/etc/apt/sources.list
deb http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb http://security.debian.org/debian-security/ bullseye-security main contrib non-free
EOF
/usr/bin/echo 'Acquire::ForceIPv4 "true";' >> /etc/apt/apt.conf.d/99force-ipv4
/usr/bin/apt install openssh-server nano
update_and_clean
/usr/bin/mv /etc/ssh/sshd_config  /etc/ssh/sshd_config.bak
/usr/bin/touch  /etc/ssh/sshd_config
/usr/bin/cat  <<EOF >/etc/ssh/sshd_config
Port 19811
HostKey /etc/ssh/ssh_host_ed25519_key
PermitRootLogin no
AllowUsers habnai
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys2
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
# override default of no subsystems
Subsystem sftp /usr/lib/openssh/sftp-server
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com
MACs umac-128-etm@openssh.com,umac-128@openssh.com
EOF
##RESTART SSHD
/usr/bin/systemctl restart sshd
# Installation der Basissoftware
/usr/bin/apt  install -y build-essential autoconf automake libtool flex bison debhelper binutils
/usr/bin/apt install -y snmp-mibs-downloader
/usr/bin/apt install -y curl gpg
/usr/bin/apt install -y python3-docker
/usr/bin/apt install -y apt-transport-https bash-completion bzip2 ca-certificates debian-archive-keyring dirmngr gnupg2 htop \
libfontconfig1 libfuse2 locate lsb-release libfile-fcntllock-perl net-tools software-properties-common ssl-cert socat tree wget unzip zip & CrI
/usr/bin/apt install net-tools
##ntp-time


/usr/bin/apt autoremove -y
