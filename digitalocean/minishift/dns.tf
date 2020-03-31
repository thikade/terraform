# Create a new domain record
#resource "digitalocean_domain" "minishift" {
#   name = "minishift.2i.at"
#   ip_address = "${digitalocean_droplet.minishift.ipv4_address}"
#}


resource "digitalocean_record" "minishift" {
  domain = "2i.at"
  type = "A"
  name = "minishift"
  value = digitalocean_droplet.minishift.ipv4_address
  ttl = 120
}
