output "server_fqdn" {
  value = "${digitalocean_record.server.fqdn}"
}

output "server_ipv4" {
  value = "${digitalocean_droplet.server.ipv4_address}"
}
