resource "digitalocean_droplet" "server" {
    count = var.instance_count
    name = var.serverNames[count.index]
    image = var.imageName
    region = var.region
    size = var.size
    private_networking = true
    user_data = var.user_data
    tags  = split(",", var.tags)

    ssh_keys =  var.ssh_fingerprints
    
  

    connection {
      host = digitalocean_droplet.server[count.index].ipv4_address
      user = "root"
      type = "ssh"
      private_key = file(var.priv_key)
      timeout = "2m"
    }

    # provisioner does not work in module-loop at this time...
    # provisioner "remote-exec" {
    #     inline = var.remote-exec-provisioner-commands
    # }
}
