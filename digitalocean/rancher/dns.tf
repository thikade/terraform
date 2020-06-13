# Create a new domain record
#resource "digitalocean_domain" "rancher" {
#   name = "rancher.2i.at"
#   ip_address = "${digitalocean_droplet.rancher.ipv4_address}"
#}


resource "digitalocean_record" "rancher1" {
  domain = "2i.at"
  type = "A"
  name = "rancher1"
  value = digitalocean_droplet.rancher1.ipv4_address
  ttl = 120
}
resource "digitalocean_record" "rancher2" {
  domain = "2i.at"
  type = "A"
  name = "rancher2"
  value = digitalocean_droplet.rancher2.ipv4_address
  ttl = 120
}
resource "digitalocean_record" "rancher3" {
  domain = "2i.at"
  type = "A"
  name = "rancher3"
  value = digitalocean_droplet.rancher3.ipv4_address
  ttl = 120
}
