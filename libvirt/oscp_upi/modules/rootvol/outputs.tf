# -[Outputs]-------------------------------------------------------------

output "rootvol_ids" {
    value = libvirt_volume.rootvol.*.id
}
