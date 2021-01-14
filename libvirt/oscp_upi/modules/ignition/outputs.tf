# -[Outputs]-------------------------------------------------------------
output "ignition_resource_ids" {
    value = libvirt_ignition.ignition-file.*.id
}
