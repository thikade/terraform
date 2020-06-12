resource "digitalocean_droplet" "rancher1" {

    # image ==> DO droplet slug name
    image = "centos-7-x64"

    name = "rancher1"
    region = "fra1"

    # size = "s-4vcpu-8gb"
    size = "s-2vcpu-2gb"

    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}",
      "4f:7d:cf:c6:82:38:0a:19:11:ad:42:5a:b5:7d:66:9e",
      "71:a6:1f:38:5e:19:05:24:d4:dd:1c:32:4f:e1:f9:f6"
    ]

    connection {
      host = digitalocean_droplet.rancher1.ipv4_address
      user = "root"
      type = "ssh"
      private_key = file(var.priv_key)
      timeout = "2m"
    }

    # install rancher!
    provisioner "remote-exec" {
        inline = [
            "echo $(date) > /tmp/installed_by_terraform.txt",
            "echo ipv4: ${digitalocean_droplet.rancher1.ipv4_address} >> /tmp/installed_by_terraform.txt",
            # "echo ${digitalocean_droplet.rancher1.ipv4_address}   rancher1.2i.at >> /etc/hosts",
            "yum -y update ",
            "yum install -y docker podman buildah skopeo",
            "setenforce 0",
            "sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config",
            "echo Done."
        ]
    }
}
