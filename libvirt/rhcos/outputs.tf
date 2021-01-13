
output "ip_bootstrap" {
  value = libvirt_domain.bootstrap.*.network_interface.0.addresses
}

output "metadata_bootstrap" {
  # run 'terraform refresh' if not populated
  value = libvirt_domain.bootstrap.*
}

output "ip_master" {
  value = libvirt_domain.master.*.network_interface.0.addresses
}

output "metadata_master" {
  # run 'terraform refresh' if not populated
  value = libvirt_domain.master.*
}
