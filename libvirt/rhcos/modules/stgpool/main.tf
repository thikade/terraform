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
resource "libvirt_pool" "diskpool" {
  name = var.mod_disk_pool_name
  type = "dir"
  path = "${var.mod_disk_pool_dir}/${var.mod_disk_pool_name}"
}
