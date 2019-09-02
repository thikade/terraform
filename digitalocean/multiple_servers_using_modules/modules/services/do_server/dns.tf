# Create a new domain record
#resource "digitalocean_domain" "server" {
#   name = "${var.serverName}.2i.at"
#   ip_address = "${digitalocean_droplet.server.ipv4_address}"
#}


resource "digitalocean_record" "server" {
  domain = "2i.at"
  type = "A"
  name = "${var.serverName}"
  value = "${digitalocean_droplet.server.ipv4_address}"
  ttl = 120
}
