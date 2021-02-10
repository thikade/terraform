# -[VMs]-------------------------------------------------------------
resource "libvirt_domain" "CENTOS7" {
  name   = format(var.hostname_format, count.index + 1)
  count  = var.num_hosts
  vcpu   = "2"
  memory = "16384"

  disk {
    volume_id = element(libvirt_volume.rootvol.*.id, count.index)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)

  graphics {
    listen_type = "address"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  network_interface {
    network_name   = "NAT"
    hostname       = "${format(var.hostname_format, count.index + 1)}.${var.domain}"
    mac            = "52:54:00:00:42:a${count.index + 1}"
    wait_for_lease = true
  }
}
