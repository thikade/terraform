# -[Variables]-------------------------------------------------------------
variable "rhcos_version" {
  type = string
  default = "4.6.8"
}

variable "rhcos_arch" {
  type = string
  default = "x86_64"
}

variable "num_hosts" {
  default = 2
}

variable "hostname_format" {
  type    = string
  default = "centos8-%02d"
}

variable "disk_pool_name" {
  type = string
  default = "CENTOS8-POOL"
}

variable "domain" {
  type = string
  default = "os.hhue"
}

variable "disk_pool_dir" {
  type = string
  default = "/vms/kvm"
}

variable "NAT_0_mac" {
  type = string
  default = "AA:BB:CC:11:22:22"
}

# 16Gb for root filesystem
variable "rootdiskBytes" {
  default = 1024*1024*1024*16
}

##### variable "kick_start_file" {
#####   type = string
#####   default = "k8sm00.cfg"
##### }
#####
##### variable "http_base_url" {
#####   type = string
#####   default = "http://192.168.122.1:8080"
##### }
