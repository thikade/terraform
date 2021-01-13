##
## NOTE: To use modules please see: https://learn.hashicorp.com/tutorials/terraform/module-create?in=terraform/modules
##

module "stgpool_module" {
  source = "./modules/stgpool"
  mod_disk_pool_dir = var.disk_pool_dir
  mod_disk_pool_name = var.disk_pool_name
}

module "cloudimage_module" {
  source = "./modules/cloudimage"
  mod_volume_source = var.cloud_image_source
}

module "rootvol_module_bootstrap" {
  source = "./modules/rootvol"
  mod_base_volume_id = module.cloudimage_module.cloud_image_id
  mod_disk_size_bytes = var.rootdiskBytes
  mod_hostname_format = var.bootstrap_hostname_format
  mod_num_hosts = var.bootstrap_num_hosts
  mod_storage_pool_name = module.stgpool_module.storage_pool_name
}


module "ignition_module_bootstrap" {
  source = "./modules/ignition"
  mod_disk_pool_name = var.disk_pool_name
  mod_hostname_format = var.bootstrap_hostname_format
  mod_ign_file_name = var.bootstrap_ign_file_name
  mod_num_hosts = var.bootstrap_num_hosts
}

# -[VMs]-------------------------------------------------------------
resource "libvirt_domain" "bootstrap" {
  name   = format(var.bootstrap_hostname_format, count.index + 1)
  count  = var.bootstrap_num_hosts
  vcpu   = var.bootstrap_num_vcpu
  memory = var.bootstrap_mem_mb

#####   cmdline = [
#####    {
#####     "inst.ks" = "${var.http_base_url}/${var.kick-start-file}"
#####    }
#####   ]
##### disk {
#####   file = pathexpand("/download/CentOS-8.2.2004-x86_64-dvd1.iso")
##### }

  disk {
    ##### volume_id = element(libvirt_volume.rootvol.*.id, count.index + 1)
    volume_id = element(module.rootvol_module_bootstrap.rootvol_ids, count.index + 1)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  ##### cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index + 1)
  coreos_ignition = element(module.ignition_module_bootstrap.ignition_resource_ids, count.index + 1)

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
    hostname       = "${format(var.bootstrap_hostname_format, count.index + 1)}.${var.domain}"
    ##### addresses      = ["10.17.3.3"]
    ##### mac            = var.NAT_0_mac
    mac            = "52:54:00:00:00:b${count.index + 1}"
    wait_for_lease = true
  }
}

module "rootvol_module_master" {
  source = "./modules/rootvol"
  mod_base_volume_id = module.cloudimage_module.cloud_image_id
  mod_disk_size_bytes = var.rootdiskBytes
  mod_hostname_format = var.master_hostname_format
  mod_num_hosts = var.master_num_hosts
  mod_storage_pool_name = module.stgpool_module.storage_pool_name
}


module "ignition_module_master" {
  source = "./modules/ignition"
  mod_disk_pool_name = var.disk_pool_name
  mod_hostname_format = var.master_hostname_format
  mod_ign_file_name = var.master_ign_file_name
  mod_num_hosts = var.master_num_hosts
}

resource "libvirt_domain" "master" {
  name   = format(var.master_hostname_format, count.index + 1)
  count  = var.master_num_hosts
  vcpu   = var.master_num_vcpu
  memory = var.master_mem_mb

#####   cmdline = [
#####    {
#####     "inst.ks" = "${var.http_base_url}/${var.kick-start-file}"
#####    }
#####   ]
##### disk {
#####   file = pathexpand("/download/CentOS-8.2.2004-x86_64-dvd1.iso")
##### }

  disk {
    ##### volume_id = element(libvirt_volume.rootvol.*.id, count.index + 1)
    volume_id = element(module.rootvol_module_master.rootvol_ids, count.index + 1)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  ##### cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index + 1)
  coreos_ignition = element(module.ignition_module_master.ignition_resource_ids, count.index + 1)

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
    hostname       = "${format(var.master_hostname_format, count.index + 1)}.${var.domain}"
    ##### addresses      = ["10.17.3.3"]
    ##### mac            = var.NAT_0_mac
    mac            = "52:54:00:00:00:c${count.index + 1}"
    wait_for_lease = true
  }
}
