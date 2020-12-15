#!/bin/bash

mkdir -p /mnt/volume; chmod 777 /mnt/volume
mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume
grep /mnt/volume /etc/fstab || echo /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
ln -sf /mnt/volume/crc-linux-*-amd64/crc  /usr/local/bin/crc
# "exit 0
dnf -y install epel-release
dnf -y update
dnf -y install bash-completion curl wget skopeo git vim python38 tmux bind-utils libvirt libvirt-daemon-kvm qemu-kvm    firewalld haproxy policycoreutils-python-utils jq
systemctl stop rpcbind.service rpcbind.socket
systemctl disable rpcbind.service rpcbind.socket

useradd -m -g wheel crc
sed -i 's/^%wheel\s.*/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

su - crc -c 'crc config set cpus 7'
su - crc -c 'crc config set memory 14336'
su - crc -c 'crc config set pull-secret-file /mnt/volume/pull-secret.txt'
su - crc -c 'crc config view'
echo '*** Checking existence of .crc/cache directory'
su - crc -c 'test -d ~crc/.crc/cache || mkdir -p ~crc/.crc/cache'
echo '*** Checking existence of ~crc/.crc/cache/*bundle files'
su - crc -c 'test -f ~crc/.crc/cache/crc_*crcbundle || ln -s /mnt/volume/crc_libvirt_4.6.6.crcbundle  ~crc/.crc/cache/crc_libvirt_4.6.6.crcbundle'
su - crc -c 'crc setup'

# fix DNS on DO
cp /mnt/volume/99-do.conf /etc/NetworkManager/dnsmasq.d/
systemctl reload NetworkManager

# setup remote access proxy for CRC:
systemctl enable --now cockpit.socket
systemctl enable --now firewalld
firewall-cmd --add-port=80/tcp  --add-port=6443/tcp --add-port=443/tcp  --permanent 2>/dev/null
firewall-cmd --reload
semanage port -l | grep ^http_port_t| grep 6443 || semanage port -a -t http_port_t -p tcp 6443
bash /mnt/volume/create-haproxy-cfg.sh

grep oc-env ~crc/.bashrc || echo 'eval $(crc oc-env)' >> ~crc/.bashrc
grep completion ~crc/.bashrc || echo 'test -f /etc/bash_completion.d/oc || which oc &>/dev/null && oc completion bash | sudo tee /etc/bash_completion.d/oc &>/dev/null' >> ~crc/.bashrc

# echo 'Now run as user <crc>:    crc start --disk-size 70 --bundle /mnt/volume/crc_libvirt_4.6.6.crcbundle'
echo 'Now run as user <crc>:    crc start --disk-size 70 --nameserver 67.207.67.3  --bundle /mnt/volume/crc_libvirt_4.6.6.crcbundle'
