resource "digitalocean_droplet" "server" {

    name = "${var.serverName}"
    image = "${var.imageName}"
    region = "${var.region}"
    size = "${var.size}"

    private_networking = true
    
    ssh_keys = [
      "${var.ssh_fingerprint}",
      "4f:7d:cf:c6:82:38:0a:19:11:ad:42:5a:b5:7d:66:9e",
      "71:a6:1f:38:5e:19:05:24:d4:dd:1c:32:4f:e1:f9:f6"
    ]

    connection {
      host = "${digitalocean_droplet.server.ipv4_address}"
      user = "root"
      type = "ssh"
      private_key = "${file(var.priv_key)}"
      timeout = "2m"
    }

    # install rancher!
    provisioner "remote-exec" {
        inline = [
            "echo $(date) > /tmp/installed_by_terraform.txt",
            "echo ipv4: ${digitalocean_droplet.server.ipv4_address} >> /tmp/installed_by_terraform.txt",
            # "echo ${digitalocean_droplet.server.ipv4_address}   xxx.2i.at >> /etc/hosts",
            "yum -y update ",
            "yum install -y docker podman buildah skopeo",
            "setenforce 0",
            "sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config",
            "echo Done."
        ]
    }
}
