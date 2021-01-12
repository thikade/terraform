# -[VMs]-------------------------------------------------------------
resource "libvirt_domain" "OS99" {
  name = var.hostname
  vcpu   = "1"
  memory = "2048"

#####   cmdline = [
#####    {
#####     "inst.ks" = "${var.http-base-url}/${var.kick-start-file}"
#####    }
#####   ]
##### disk {
#####   file = pathexpand("/download/CentOS-8.2.2004-x86_64-dvd1.iso")
##### }

  disk {
    volume_id = libvirt_volume.rootvol.id
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

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
    hostname       = "${var.hostname}.${var.domain}"
    ##### addresses      = ["10.17.3.3"]
    mac            = var.NAT-0-mac
    wait_for_lease = true
  }
}
