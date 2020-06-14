resource "digitalocean_droplet" "rancher3" {

    # image ==> DO droplet slug name
    image = "centos-7-x64"

    name = "rancher3"
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
      host = digitalocean_droplet.rancher3.ipv4_address
      user = "root"
      type = "ssh"
      private_key = file(var.priv_key)
      timeout = "2m"
    }

    # install rancher!
    provisioner "remote-exec" {
        inline = [
            "echo $(date) > /tmp/installed_by_terraform.txt",
            "useradd rancher && mkdir /home/rancher/.ssh && chmod 700 /home/rancher/.ssh",
            "cat /root/.ssh/authorized_keys > /home/rancher/.ssh/authorized_keys && chown -R rancher.rancher /home/rancher/.ssh/",
            "yum -y update ",
            "yum install -y curl wget htop",
            "yum -y remove docker || true",
            "curl -L https://releases.rancher.com/install-docker/19.03.11.sh | sh",
            "usermod -aG docker rancher",
            "systemctl enable --now docker",
            "echo 'net.bridge.bridge-nf-call-iptables = 1' > /etc/sysctl.d/rancher",
            "sysctl net.bridge.bridge-nf-call-iptables=1",
            "curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
            "chmod 755 /usr/local/bin/kubectl",
            "setenforce 0",
            "sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config"
        ]
    }
}
