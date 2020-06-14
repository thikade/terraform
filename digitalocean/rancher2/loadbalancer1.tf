# data "digitalocean_loadbalancer" "public" {
#   name = "rancher-loadbalancer"
# }

# output "lb_output" {
#   value = data.digitalocean_loadbalancer.public.forwarding_rule
# }

resource "digitalocean_loadbalancer" "rancher" {
  name   = "lb-rancher"
  region = "fra1"

#   forwarding_rule {
#     entry_port     = 80
#     entry_protocol = "http"

#     target_port     = 80
#     target_protocol = "http"
#   }

  forwarding_rule {
      entry_port = 443
      entry_protocol = "https"
      target_port = 443
      target_protocol = "https"
      tls_passthrough = true
  }

  forwarding_rule {
      entry_port = 80
      entry_protocol = "http"
      target_port = 80
      target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_tag = "rancher-node"
}


resource "digitalocean_record" "rancher" {
  domain = "2i.at"
  type = "A"
  name = "rancher.2i.at"
  value = digitalocean_loadbalancer.rancher.ip
  ttl = 180
}