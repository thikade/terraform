output "server_id" {
  value = digitalocean_droplet.server[*].id
}

output "urn" {
  value = digitalocean_droplet.server[*].urn
}

output "server_ipv4" {
  value = digitalocean_droplet.server[*].ipv4_address
}

output "server_ipv4_private" {
  value = digitalocean_droplet.server[*].ipv4_address_private
}


output "server_fqdn" {
  value = digitalocean_record.server[*].fqdn
}

output "server_fqdn_private" {
  value = digitalocean_record.private[*].fqdn
}
