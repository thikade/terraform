output "crc_fqdn" {
  value = digitalocean_record.crc.fqdn
}

output "crc_ipv4" {
  value = digitalocean_droplet.crc.ipv4_address
}