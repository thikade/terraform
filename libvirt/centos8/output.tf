
output "ip" {
  value = libvirt_domain.OS99.network_interface[0].addresses[0]
}

output "metadata" {
  # run 'terraform refresh' if not populated
  value = libvirt_domain.OS99
}
