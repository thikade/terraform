output "minishift_dns_name" {
  value = "${digitalocean_domain.minishift.name}"
}

output "minishift_ipv4" {
  value = "${digitalocean_droplet.minishift.ipv4_address}"
}