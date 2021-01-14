# -[Resources]-------------------------------------------------------------
resource "libvirt_pool" "diskpooldir" {
  name = var.disk_pool_name
  type = "dir"
  path = "${var.disk_pool_dir}/${var.disk_pool_name}"
}

##### resource "libvirt_volume" "RHCOS" {
#####   name   = "RHCOS"
#####   source = "/vms/httpd/rhcos-${var.rhcos_version}-${var.rhcos_arch}-qemu.x86_64.qcow2"
##### }

resource "libvirt_volume" "CentOS8-cloud-image" {
  name   = "CentOS8-cloud-image"
  ##### source = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2"
  source = "/download/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2"
  ##### source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
  ##### source = "/download/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
}

resource "libvirt_volume" "rootvol" {
  name   = "${format(var.hostname_format, count.index + 1)}.qcow2"
  count  = var.num_hosts
  pool   = libvirt_pool.diskpooldir.name
  size   = var.rootdiskBytes
  format = "qcow2"
  base_volume_id = libvirt_volume.CentOS8-cloud-image.id
}
