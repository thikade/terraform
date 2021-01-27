# -[VMs]-------------------------------------------------------------
resource "libvirt_domain" "CENTOS8" {
  name   = format(var.hostname_format, count.index + 1)
  count  = var.num_hosts
  vcpu   = "1"
  memory = "2048"

#####   cmdline = [
#####    {
#####     "inst.ks" = "${var.http_base_url}/${var.kick_start_file}"
#####    }
#####   ]
##### disk {
#####   file = pathexpand("/download/CentOS-8.2.2004-x86_64-dvd1.iso")
##### }

  disk {
    volume_id = element(libvirt_volume.rootvol.*.id, count.index)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)

  graphics {
    ## Bug in linux up to 4.14-rc2
    ## https://bugzilla.redhat.com/show_bug.cgi?id=1432684
    ## No Spice/VNC available if more than one machine is generated at a time
    ## Comment the address line, uncomment the none line and the console block below
    #listen_type = "none"
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
    ##### addresses      = ["10.17.3.3"]
    ##### mac            = var.NAT_0_mac
    mac            = "52:54:00:00:00:a${count.index + 1}"
    wait_for_lease = true
  }
}
