# Create a new domain record
#resource "digitalocean_domain" "crc" {
#   name = "crc.2i.at"
#   ip_address = "${digitalocean_droplet.crc.ipv4_address}"
#}


resource "digitalocean_record" "crc" {
  domain = "2i.at"
  type = "A"
  name = "crc"
  value = digitalocean_droplet.crc.ipv4_address
  ttl = 120
}
