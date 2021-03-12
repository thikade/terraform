#!/bin/bash

#export OCP_VERSION=4.6.15
export OCP_VERSION=4.7.0
export CPUS=6
MEMORY_GB=14
export MEMORY=$((MEMORY_GB * 1024))

export CRC_STARTUP_LOG=/tmp/crc_start.log

# mount external volume
mkdir -p /mnt/volume; chmod 777 /mnt/volume
mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume
grep /mnt/volume /etc/fstab || echo /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
# root user setup
cp /mnt/volume/tmux.conf ~/.tmux.conf
# "exit 0

# install updates & packages
dnf -y install epel-release
dnf -y update
dnf -y install  bash-completion curl wget skopeo git vim python38 tmux bind-utils libvirt libvirt-daemon-kvm qemu-kvm \
                firewalld haproxy policycoreutils-python-utils jq at

# disable NFS
systemctl stop rpcbind.service rpcbind.socket
systemctl disable rpcbind.service rpcbind.socket

systemctl enable --now atd

# add user crc and sudo-rights
useradd -m -g wheel crc
sed -i 's/^%wheel\s.*/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
cp /mnt/volume/tmux.conf ~crc/.tmux.conf

# configure crc 
ln -sf /mnt/volume/crc-linux-*-amd64/crc  /usr/local/bin/crc

su crc -c "crc config set cpus $CPUS"
su crc -c "crc config set memory $MEMORY"
su crc -c "crc config set nameserver 8.8.8.8"
su crc -c "crc config set disk-size 70"
su crc -c "crc config set enable-experimental-features false"
su crc -c "crc config set pull-secret-file /mnt/volume/pull-secret.txt"
su crc -c "crc config set consent-telemetry yes"
su crc -c "crc config set enable-cluster-monitoring false"
su crc -c "crc config view"
# su - crc -c "test -d ~crc/.crc/cache || mkdir -p ~crc/.crc/cache"
# su - crc -c "test -f ~crc/.crc/cache/crc_libvirt_${OCP_VERSION}.crcbundle || ln -s /mnt/volume/crc_libvirt_${OCP_VERSION}.crcbundle  ~crc/.crc/cache/crc_libvirt_${OCP_VERSION}.crcbundle"
# su - crc -c "test -d ~crc/.crc/cache/crc_libvirt_${OCP_VERSION} || ln -s /mnt/volume/crc_libvirt_${OCP_VERSION}  ~crc/.crc/cache/crc_libvirt_${OCP_VERSION}"
su crc -c "echo n | crc setup"

# fix external DNS on DO Centos8 broken by "crc setup"
cat <<EOT > /mnt/volume/99-do-dns.conf
# for all other domains query DO FFM nameserver
server=/#/67.207.67.3
EOT
cp /mnt/volume/99-do-dns.conf /etc/NetworkManager/dnsmasq.d/
systemctl reload NetworkManager

# setup remote access proxy for CRC:
systemctl enable --now cockpit.socket
systemctl enable --now firewalld
# port 9000 is for external haproxy stats
firewall-cmd --add-port=80/tcp  --add-port=6443/tcp --add-port=443/tcp  --add-port=9000/tcp --permanent 2>/dev/null
firewall-cmd --add-port=8800/tcp   --permanent 2>/dev/null   # for rbac-viewer
firewall-cmd --reload
# add custom ports to SELinux 
semanage port -l | grep ^http_port_t| grep 6443 || semanage port -a -t http_port_t -p tcp 6443
semanage port -l | grep ^http_port_t| grep 9000 || semanage port -a -t http_port_t -p tcp 9000
semanage port -l | grep ^http_port_t| grep 8800 || semanage port -a -t http_port_t -p tcp 8800  # for rbac-viewer

# autoload crc and oc completion
grep oc-env ~crc/.bashrc || echo 'eval $(crc oc-env)' >> ~crc/.bashrc
grep completion ~crc/.bashrc || echo 'test -f /etc/bash_completion.d/oc || which oc &>/dev/null && oc completion bash | sudo tee /etc/bash_completion.d/oc &>/dev/null' >> ~crc/.bashrc
grep kubeconfig ~crc/.bashrc || echo "export KUBECONFIG=~crc/.crc/machines/crc/kubeconfig" >> ~crc/.bashrc
grep krew ~crc/.bashrc || echo 'export PATH="${PATH}:~crc/.krew/bin"' >> ~crc/.bashrc

# setup krew & plugins
test -f ~crc/.crc/bin/oc/oc && cd ~crc/.crc/bin/oc  && (test -h kubectl || ln -s oc kubectl)
curl -fsSL "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" -o /tmp/krew.tar.gz
tar -xvzf /tmp/krew.tar.gz -C /tmp 
/tmp/krew-linux_amd64 install krew
export PATH="${PATH}:~crc/.krew/bin"
PLUGINS="ctx ns tail tree minio view-utilization np-viewer view-secret who-can"
for P in $PLUGINS; do 
  su crc -c "export PATH=$PATH:/home/crc/.krew/bin; ~crc/.crc/bin/oc/oc krew install $P"
done


# echo 'Now run as user crc:    su - crc -c "crc start --nameserver 67.207.67.3 --disk-size 70 --bundle /mnt/volume/crc_libvirt_${OCP_VERSION}.crcbundle"'
# echo 'Now run as user crc:         su - crc -c "crc start --nameserver 67.207.67.3 --disk-size 70"'
# echo 'then run external haproxy:   bash /mnt/volume/create-haproxy-cfg.sh  `su - crc -c crc ip`'

cat << EOT > crc_start.sh
  # start crc cluster
  echo "crc start ..."
  su crc -c "crc start"
 
  # configure and start external haproxy
  echo "haproxy start ..."
  bash /mnt/volume/create-haproxy-cfg.sh  \$(su - crc -c "crc ip")
  systemctl enable --now haproxy

  echo "done."
EOT

# fix network issues inside CRC vm
systemctl restart libvirtd

echo "starting CRC cluster in background. Watch progress via:   tail -f $CRC_STARTUP_LOG "
echo "bash /tmp/crc_start.sh &> $CRC_STARTUP_LOG" | at now +1 minute
