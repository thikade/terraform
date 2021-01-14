##
## NOTE: To use modules please see: https://learn.hashicorp.com/tutorials/terraform/module-create?in=terraform/modules
##

module "stgpool_module" {
  source = "./modules/stgpool"
  providers = {
    libvirt = libvirt
  }

  mod_disk_pool_dir = var.disk_pool_dir
  mod_disk_pool_name = var.disk_pool_name
}

module "cloudimage_module" {
  source = "./modules/cloudimage"
  providers = {
    libvirt = libvirt
  }

  mod_volume_source = var.cloud_image_source
}

module "rootvol_module_bootstrap" {
  source = "./modules/rootvol"
  providers = {
    libvirt = libvirt
  }
  depends_on = [module.stgpool_module, module.cloudimage_module]

  mod_base_volume_id = module.cloudimage_module.cloud_image_id
  mod_disk_size_bytes = var.rootdiskBytes
  mod_hostname_format = var.bootstrap_hostname_format
  mod_num_hosts = var.bootstrap_num_hosts
  mod_storage_pool_name = module.stgpool_module.storage_pool_name
}

module "ignition_module_bootstrap" {
  source = "./modules/ignition"
  providers = {
    libvirt = libvirt
  }
  depends_on = [module.stgpool_module]

  mod_disk_pool_name = var.disk_pool_name
  mod_hostname_format = var.bootstrap_hostname_format
  mod_ign_file_name = var.bootstrap_ign_file_name
  mod_num_hosts = var.bootstrap_num_hosts
}

module "rootvol_module_master" {
  source = "./modules/rootvol"
  providers = {
    libvirt = libvirt
  }
  depends_on = [module.stgpool_module, module.cloudimage_module]

  mod_base_volume_id = module.cloudimage_module.cloud_image_id
  mod_disk_size_bytes = var.rootdiskBytes
  mod_hostname_format = var.master_hostname_format
  mod_num_hosts = var.master_num_hosts
  mod_storage_pool_name = module.stgpool_module.storage_pool_name
}

module "ignition_module_master" {
  source = "./modules/ignition"
  providers = {
    libvirt = libvirt
  }
  depends_on = [module.stgpool_module]

  mod_disk_pool_name = var.disk_pool_name
  mod_hostname_format = var.master_hostname_format
  mod_ign_file_name = var.master_ign_file_name
  mod_num_hosts = var.master_num_hosts
}

module "rootvol_module_worker" {
  source = "./modules/rootvol"
  providers = {
    libvirt = libvirt
  }
  depends_on = [module.stgpool_module, module.cloudimage_module]

  mod_base_volume_id = module.cloudimage_module.cloud_image_id
  mod_disk_size_bytes = var.rootdiskBytes
  mod_hostname_format = var.worker_hostname_format
  mod_num_hosts = var.worker_num_hosts
  mod_storage_pool_name = module.stgpool_module.storage_pool_name
}

module "ignition_module_worker" {
  source = "./modules/ignition"
  providers = {
    libvirt = libvirt
  }
  depends_on = [module.stgpool_module]

  mod_disk_pool_name = var.disk_pool_name
  mod_hostname_format = var.worker_hostname_format
  mod_ign_file_name = var.worker_ign_file_name
  mod_num_hosts = var.worker_num_hosts
}

# -[VMs]-------------------------------------------------------------

##
## Bootstrap VMs
##
resource "libvirt_domain" "bootstrap" {
  name   = format(var.bootstrap_hostname_format, count.index + 1)
  count  = var.bootstrap_num_hosts
  vcpu   = var.bootstrap_num_vcpu
  memory = var.bootstrap_mem_mb

  disk {
    volume_id = element(module.rootvol_module_bootstrap.rootvol_ids, count.index + 1)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  coreos_ignition = element(module.ignition_module_bootstrap.ignition_resource_ids, count.index + 1)

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
    hostname       = "${format(var.bootstrap_hostname_format, count.index + 1)}.${var.domain}"
    mac            = "52:54:00:00:00:b${count.index + 1}"
    wait_for_lease = true
  }
}
##
## Master VMs
##
resource "libvirt_domain" "master" {
  name   = format(var.master_hostname_format, count.index + 1)
  count  = var.master_num_hosts
  vcpu   = var.master_num_vcpu
  memory = var.master_mem_mb

  disk {
    volume_id = element(module.rootvol_module_master.rootvol_ids, count.index + 1)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  coreos_ignition = element(module.ignition_module_master.ignition_resource_ids, count.index + 1)

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
    hostname       = "${format(var.master_hostname_format, count.index + 1)}.${var.domain}"
    mac            = "52:54:00:00:00:c${count.index + 1}"
    wait_for_lease = true
  }
}
##
## Worker VMs
##
resource "libvirt_domain" "worker" {
  name   = format(var.worker_hostname_format, count.index + 1)
  count  = var.worker_num_hosts
  vcpu   = var.worker_num_vcpu
  memory = var.worker_mem_mb

  disk {
    volume_id = element(module.rootvol_module_worker.rootvol_ids, count.index + 1)
  }

  boot_device {
    dev = [ "hd", "cdrom", "network" ]
  }

  coreos_ignition = element(module.ignition_module_worker.ignition_resource_ids, count.index + 1)

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
    hostname       = "${format(var.worker_hostname_format, count.index + 1)}.${var.domain}"
    mac            = "52:54:00:00:00:c${count.index + 1}"
    wait_for_lease = true
  }
}
