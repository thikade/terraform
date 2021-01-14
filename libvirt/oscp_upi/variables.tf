# -[Variables]-------------------------------------------------------------

variable "bootstrap_hostname_format" {
  type    = string
  default = "bs%02d"
}

variable "bootstrap_num_hosts" {
  default = 1
}

variable "bootstrap_num_vcpu" {
  type = number
  default = 2
}

variable "bootstrap_mem_mb" {
  default = 1024*16
}

variable "bootstrap_ign_file_name" {
  type = string
  default = "/vms/httpd/bootstrap.ign"
}

##### source = "https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.6/latest/rhcos-qemu.x86_64.qcow2.gz"
##### source = "/download/rhcos-qemu.x86_64.qcow2"
variable "cloud_image_source" {
  type = string
  default = "/download/rhcos-qemu.x86_64.qcow2"
}

variable "disk_pool_dir" {
  type = string
  default = "/vms/kvm"
}

variable "disk_pool_name" {
  type = string
  default = "RHCOS-POOL"
}

variable "domain" {
  type = string
  default = "os.hhue"
}

variable "http_base_url" {
  type = string
  default = "http://192.168.122.1:8080"
}

variable "master_hostname_format" {
  type    = string
  default = "ma%02d"
}

variable "master_ign_file_name" {
  type = string
  default = "/vms/httpd/master.ign"
}

variable "master_num_hosts" {
  default = 3
}

variable "master_num_vcpu" {
  type = number
  default = 2
}

variable "master_mem_mb" {
  default = 1024*16
}

variable "NAT_0_mac" {
  type = string
  default = "AA:BB:CC:11:22:22"
}

variable "rhcos_version" {
  type = string
  default = "4.6.8"
}

variable "rhcos_arch" {
  type = string
  default = "x86_64"
}

# 16Gb for root filesystem
variable "rootdiskBytes" {
  default = 1024*1024*1024*16
}

variable "worker_hostname_format" {
  type    = string
  default = "wo%02d"
}

variable "worker_ign_file_name" {
  type = string
  default = "/vms/httpd/worker.ign"
}

variable "worker_num_hosts" {
  default = 2
}

variable "worker_num_vcpu" {
  type = number
  default = 2
}

variable "worker_mem_mb" {
  default = 1024*8
}
