#!/bin/bash

mkdir -p /mnt/volume; chmod 777 /mnt/volume
mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume
grep /mnt/volume /etc/fstab || echo /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
ln -s /mnt/volume/crc-linux-*-amd64/crc  /usr/local/bin/crc
# "exit 0
dnf -y update
dnf -y install bash-completion curl wget skopeo git vim python38 tmux bind-utils libvirt libvirt-daemon-kvm qemu-kvm
systemctl stop rpcbind.service rpcbind.socket; systemctl disable rpcbind.service rpcbind.socket
useradd -m -g wheel crc
sed -i 's/^%wheel\\s.*/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

su - crc -c 'crc config set cpus 7'
su - crc -c 'crc config set memory 14336'
su - crc -c 'crc config set pull-secret-file /mnt/volume/pull-secret.txt'
su - crc -c 'crc config view'
echo '*** Checking existence of .crc/cache directory'
su - crc -c 'test -d ~crc/.crc/cache || mkdir -p ~crc/.crc/cache'
echo '*** Checking existence of ~crc/.crc/cache/*bundle files'
su - crc -c 'test -f ~crc/.crc/cache/*crcbundle || cp -pr /mnt/volume/cache/. ~crc/.crc/cache/'
su - crc 'crc setup'

# setup remote access proxy for CRC:
dnf -y install firewalld haproxy policycoreutils-python-utils jq
systemctl enable --now firewalld
firewall-cmd --add-port=80/tcp  --add-port=6443/tcp --add-port=443/tcp  --permanent 2>/dev/null
semanage port -l | grep ^http_port_t| grep 6443 || semanage port -a -t http_port_t -p tcp 6443

echo $(date) > /tmp/installed_by_terraform.txt

grep oc-env ~crc/.bashrc || echo 'eval $(crc oc-env)' >> ~crc/.bashrc
grep completion ~crc/.bashrc || echo 'oc completion bash' >> ~crc/.bashrc

echo 'Now run as user crc:  crc start --nameserver 67.207.67.3'
