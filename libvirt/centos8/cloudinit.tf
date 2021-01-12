# -[cloudinit]-------------------------------------------------------------
##### resource "libvirt_ignition" "ignition" {
#####   name = "bootstrap.ign"
#####   content = "/vms/httpd/bootstrap.ign"
##### }

data "template_file" "user_data" {
  ##### template = file("${path.module}/cloud_init_cfg")
  template = file("${path.module}/cloud_init_cfg")
  count = var.num-hosts
  vars = {
    hostname = format(var.hostname_format, count.index + 1)
    fqdn = "${format(var.hostname_format, count.index + 1)}.${var.domain}"
  }
}

##### data "template_file" "network_config" {
#####   template = file("${path.module}/network_config_dhcp.cfg")
##### }

# Use CloudInit ISO to add ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  name = "${format(var.hostname_format, count.index + 1)}-commoninit.iso"
  pool = libvirt_pool.diskpooldir.name
  user_data = element(data.template_file.user_data.*.rendered, count.index + 1)
#####   network_config = data.template_file.network_config.rendered
  count = var.num-hosts
}
