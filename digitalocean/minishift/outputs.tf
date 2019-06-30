output "minishift_fqdn" {
  value = "${digitalocean_record.minishift.fqdn}"
}

output "minishift_ipv4" {
  value = "${digitalocean_droplet.minishift.ipv4_address}"
}