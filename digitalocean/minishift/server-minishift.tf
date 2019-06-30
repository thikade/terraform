resource "digitalocean_droplet" "minishift" {

    # image ==> DO droplet slug name
    image = "centos-7-x64"

    name = "minishift"
    region = "fra1"
    
    # size = "s-4vcpu-8gb"
    size = "s-1vcpu-1gb"
    
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}",
      "4f:7d:cf:c6:82:38:0a:19:11:ad:42:5a:b5:7d:66:9e",
      "71:a6:1f:38:5e:19:05:24:d4:dd:1c:32:4f:e1:f9:f6"
    ]
  
  
    connection {
      host = "${digitalocean_droplet.minishift.ipv4_address}"
      user = "root"
      type = "ssh"
      private_key = "${file(var.priv_key)}"
      timeout = "2m"
    } 
    
    provisioner "remote-exec" {
        inline = [
            "export PATH=$PATH:/usr/bin",
            "echo $(date) > /tmp/installed_by_terraform.txt",
            "yum -y update ",
            "cd /root && curl -L https://github.com/minishift/minishift/releases/download/v1.34.0/minishift-1.34.0-linux-amd64.tgz -o - | tar xvzf -",
            "ln -s /root/minishift-1.34.0-linux-amd64/minishift  /usr/bin/minishift",
            "mkdir /root/.ssh",
            "ssh-keygen.exe  -t ed25519 -C minishift_local_ssh -N - -f /root/.ssh/id_ed25519",
            "minishift config set vm-driver generic",
            "minishift config set remote-ipaddress minishift.2i.at",
            "minishift config set public-hostname minishift.2i.at",
            "minishift config set remote-ssh-user root",
            "minishift config set remote-ssh-key /root/.ssh/id_ed25519",
            "minishift config set timezone Europe/Vienna",
            "minishift config view"
            # "minishift start --openshift-version v3.11.0"
        ]
    }
}    
