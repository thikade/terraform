# Create a new domain record
resource "digitalocean_domain" "minishift" {
   name = "minishift.2i.at"
   ip_address = "${digitalocean_droplet.minishift.ipv4_address}"
}