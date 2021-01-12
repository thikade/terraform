
output "ip" {
  value = libvirt_domain.CENTOS8.*.network_interface.0.addresses
}

output "metadata" {
  # run 'terraform refresh' if not populated
  value = libvirt_domain.CENTOS8.*
}
