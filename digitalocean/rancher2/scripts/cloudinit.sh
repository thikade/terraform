#!/bin/bash

DOCKER_VERSION=19.03.11

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

useradd -u 1010 rancher
mkdir /home/rancher/.ssh
chmod 700 /home/rancher/.ssh
cat /root/.ssh/authorized_keys > /home/rancher/.ssh/authorized_keys
chown -R rancher.rancher /home/rancher/.ssh/

yum -y install epel-release
yum -y update 
yum install -y curl wget htop
yum remove -y docker
curl -L https://releases.rancher.com/install-docker/$DOCKER_VERSION.sh | sh

usermod -aG docker rancher
systemctl enable --now docker

# required by rancher
echo 'net.bridge.bridge-nf-call-iptables = 1' > /etc/sysctl.d/rancher
sysctl net.bridge.bridge-nf-call-iptables=1

### install latest kubectl
curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod 755 /usr/local/bin/kubectl

### install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

# DO agent update
yum remove -y do-agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | bash

# systemd stuff
systemctl stop     rpcbind.service rpcbind.socket
systemctl disable  rpcbind.service rpcbind.socket

git config --global color.ui auto
git config user.name rancher
git config core.fileMode false

echo "Setup complete." >> /tmp/setup.log
