resource "digitalocean_droplet" "crc" {

    # image ==> DO droplet slug name
    image = "centos-8-x64"

    name = "crc"
    region = "fra1"

    # size = "s-1vcpu-1gb"
    # size = "s-4vcpu-8gb"
    size = "s-8vcpu-16gb"

    # only specific IPs can connect to droplets labelled with this tag!
    tags  = [ "FW-PRIVATE" ]

    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}",
      "4f:7d:cf:c6:82:38:0a:19:11:ad:42:5a:b5:7d:66:9e",
      "71:a6:1f:38:5e:19:05:24:d4:dd:1c:32:4f:e1:f9:f6"
    ]

}



#### VOLUME ###############

# get volume xxx - volume will be managed in another state because it's got a different lifecycle!
data "digitalocean_volume" "vData" {
  name      = "volume-fra1-data-20g"
  region    = "fra1"
}

# be sure to attach volume
resource "digitalocean_volume_attachment" "data" {
  droplet_id = digitalocean_droplet.crc.id
  volume_id  = data.digitalocean_volume.vData.id

  connection {
    host = digitalocean_droplet.crc.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.priv_key)
    timeout = "2m"
  }

  # install crc after volume has been attached!
  # get your pulll secret from: https://cloud.redhat.com/openshift/install/crc/installer-provisioned
  provisioner "remote-exec" {
      inline = [
          "mkdir -p /mnt/volume; chmod 777 /mnt/volume", 
          "mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume", 
          "grep /mnt/volume /etc/fstab || echo /dev/disk/by-id/scsi-0DO_Volume_volume-fra1-data-20g /mnt/volume ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab",
          "ln -s /mnt/volume/crc-linux-*-amd64/crc  /usr/local/bin/crc",

          "dnf -y update",
          "dnf -y install bash-completion curl wget skopeo git vim python38 tmux bind-utils libvirt libvirt-daemon-kvm qemu-kvm",
          "systemctl stop rpcbind.service rpcbind.socket; systemctl disable rpcbind.service rpcbind.socket",
          "useradd -m -g wheel crc",
          "sed -i 's/^%wheel\\s.*/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers",

          "su - crc -c 'crc config set cpus 7'",
          "su - crc -c 'crc config set memory 14336'",
          "su - crc -c 'crc config set pull-secret-file /mnt/volume/pull-secret.txt'",
          "su - crc -c 'crc config view'",
          "grep oc-env ~crc/.bashrc || echo 'eval $(crc oc-env)' >> ~crc/.bashrc",
          "grep completion ~crc/.bashrc || echo 'oc completion bash' >> ~crc/.bashrc",
          "su - crc -c 'test -d ~/.crc/cache || mkdir -p .crc/cache",
          "su - crc -c 'test -f ~/.crc/cache/*crcbundle || cp -r /mnt/volume/cache/. ~/.crc/cache/",
          "crc setup'",

          # setup remote access proxy for CRC:
          "dnf -y install firewalld haproxy policycoreutils-python-utils jq",
          "systemctl enable --now firewalld",
          "firewall-cmd --add-port=80/tcp  --add-port=6443/tcp --add-port=443/tcp  --permanent 2>/dev/null",
          "semanage port -l | grep ^http_port_t| grep 6443 || semanage port -a -t http_port_t -p tcp 6443",
          
          "echo $(date) > /tmp/installed_by_terraform.txt",
          # # "echo ${digitalocean_droplet.crc.ipv4_address}   crc.2i.at >> /etc/hosts",
          # # "echo ipv4: ${digitalocean_droplet.crc.ipv4_address} >> /tmp/installed_by_terraform.txt",
          "echo Done.",
          "echo Now run:   crc start --nameserver 67.207.67.3 "
      ]
  }

}
