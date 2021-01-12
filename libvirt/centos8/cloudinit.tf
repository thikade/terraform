# -[cloudinit]-------------------------------------------------------------
##### resource "libvirt_ignition" "ignition" {
#####   name = "bootstrap.ign"
#####   content = "/vms/httpd/bootstrap.ign"
##### }

data "template_file" "user_data" {
  ##### template = file("${path.module}/cloud_init_cfg")
  template = file("${path.module}/cloud_init_cfg")
  vars = {
    hostname = var.hostname
    fqdn = "${var.hostname}.${var.domain}"
  }
}

##### data "template_file" "network_config" {
#####   template = file("${path.module}/network_config_dhcp.cfg")
##### }

# Use CloudInit ISO to add ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
          name = "${var.hostname}-commoninit.iso"
          pool = libvirt_pool.diskpooldir.name
          user_data = data.template_file.user_data.rendered
#####           network_config = data.template_file.network_config.rendered
}
