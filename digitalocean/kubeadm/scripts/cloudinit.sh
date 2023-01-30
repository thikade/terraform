#!/bin/bash
echo "Setup start: $(date)" >> /tmp/setup.log

DOCKER_VERSION=20.10.13

# setenforce 0
# sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

USERNAME=kubeadm
useradd -m -s /bin/bash -u 1010 $USERNAME
mkdir /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
cat /root/.ssh/authorized_keys > /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME.$USERNAME /home/$USERNAME/.ssh/
# enable sudo
echo "kubeadm ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kubeadm


export DEBIAN_FRONTEND=noninteractive
echo "running: apt update" >> /tmp/setup.log
apt update

# echo "running: apt upgrade" >> /tmp/setup.log
# apt upgrade -y

echo "running: apt install" >> /tmp/setup.log
apt install -y git curl htop net-tools bash-completion

# DO agent update
#  yum remove -y do-agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | bash



git config --global color.ui auto
git config user.name $USERNAME
git config core.fileMode false

su - kubeadm -c "git clone https://github.com/sandervanvugt/cka.git"

echo "CKA: $(pwd)/cka" >> /tmp/setup.log

echo "Setup complete: $(date)" >> /tmp/setup.log
