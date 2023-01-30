

# Create a new domain
resource "digitalocean_domain" "cluster" {
  name       = var.clusterDomain
}
resource "digitalocean_record" "server" {
  count = var.instance_count
  domain = digitalocean_domain.cluster.id
  type = "A"
  name = var.serverNames[count.index]
  value = digitalocean_droplet.server[count.index].ipv4_address
  ttl = 180
}

resource "digitalocean_record" "private" {
  count = var.instance_count
  domain = var.clusterDomain
  type = "A"
  name = "${var.serverNames[count.index]}-priv"
  value = digitalocean_droplet.server[count.index].ipv4_address_private
  ttl = 180
}
