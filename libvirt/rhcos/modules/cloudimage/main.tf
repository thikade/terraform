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

resource "libvirt_volume" "cloud_image" {
  name   = "cloud-image"
  ##
  ## See: https://raw.githubusercontent.com/openshift/installer/release-4.3/data/data/rhcos.json
  ## https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.6/latest/
  ## and get: rhcos-qemu.x86_64.qcow2.gz
  ##### source = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2"
  source = var.mod_volume_source
  ##### source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
  ##### source = "/download/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
}
