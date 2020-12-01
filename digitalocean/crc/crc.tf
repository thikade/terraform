resource "digitalocean_droplet" "crc" {

    # image ==> DO droplet slug name
    image = "centos-8-x64"

    name = "crc"
    region = "fra1"

    # size = "s-1vcpu-1gb"
    # size = "s-4vcpu-8gb"
    # size = "s-8vcpu-16gb"
    size = "c-8"

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


  provisioner "file" {
    source      = "scripts/prepare-for-crc.sh"
    destination = "/root/prepare-for-crc.sh"
  }
  
  # install crc after volume has been attached!
  # get your pulll secret from: https://cloud.redhat.com/openshift/install/crc/installer-provisioned
  provisioner "remote-exec" {
      inline = [
          "chmod 755 /root/*.sh", 
          "/root/prepare-for-crc.sh",
      ]
  }

}
