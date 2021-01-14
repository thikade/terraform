terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# -[Resources]-------------------------------------------------------------
resource "libvirt_ignition" "ignition-file" {
  name    = "${format(var.mod_hostname_format, count.index + 1)}-ignition"
  pool    = var.mod_disk_pool_name
  count   = var.mod_num_hosts
  ##### content = element(data.ignition_config.startup.*.rendered, count.index + 1)
  content = file(var.mod_ign_file_name)
}
