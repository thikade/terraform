terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}

# -[Resources]-------------------------------------------------------------
resource "libvirt_volume" "rootvol" {
  name  = "${format(var.mod_hostname_format, count.index + 1)}.qcow2"
  count = var.mod_num_hosts
  pool  = var.mod_storage_pool_name
  ##### pool   = module.stgpool_module.storage_pool_name
  size   = var.mod_disk_size_bytes
  format = var.mod_disk_format
  base_volume_id = var.mod_base_volume_id
  ##### base_volume_id = module.cloudimage.cloud_image_id
}
