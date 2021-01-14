terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# -[Resources]-------------------------------------------------------------

resource "libvirt_volume" "cloud_image" {
  name   = "cloud-image"
  source = var.mod_volume_source
}
