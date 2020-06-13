output "rancher1_fqdn" {
  value = digitalocean_record.rancher1.fqdn
}
output "rancher1_ipv4" {
  value = digitalocean_droplet.rancher1.ipv4_address
}

output "rancher2_fqdn" {
  value = digitalocean_record.rancher2.fqdn
}

output "rancher2_ipv4" {
  value = digitalocean_droplet.rancher2.ipv4_address
}

output "rancher3_fqdn" {
  value = digitalocean_record.rancher3.fqdn
}

output "rancher3_ipv4" {
  value = digitalocean_droplet.rancher3.ipv4_address
}
