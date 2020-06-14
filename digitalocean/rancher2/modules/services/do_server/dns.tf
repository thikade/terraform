

resource "digitalocean_record" "server" {
  count = var.instance_count
  domain = "2i.at"
  type = "A"
  name = var.serverNames[count.index]
  value = digitalocean_droplet.server[count.index].ipv4_address
  ttl = 180
}

resource "digitalocean_record" "private" {
  count = var.instance_count
  domain = "2i.at"
  type = "A"
  name = "${var.serverNames[count.index]}-priv"
  value = digitalocean_droplet.server[count.index].ipv4_address_private
  ttl = 180
}
