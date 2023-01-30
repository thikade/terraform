output "nodes-id" {
  value = module.nodes.server_id
}

output "nodes-ipv4" {
  value = module.nodes.server_ipv4
}

output "nodes-ipv4-private" {
  value = module.nodes.server_ipv4_private
}

output "nodes-fqdn" {
  value = module.nodes.server_fqdn
}

output "nodes-fqdn-private" {
  value = module.nodes.server_fqdn_private
}

output "data-droplet-sizes" {
  # value = zipmap(data.digitalocean_sizes.main.sizes.*.slug,
  #                 data.digitalocean_sizes.main.sizes.*.vcpus)
  value = [
    for o in data.digitalocean_sizes.main.sizes : tomap({"slug" = o.slug, "mem" = o.memory, "cpus" = o.vcpus, "price/month" = o.price_monthly})
  ]
}
