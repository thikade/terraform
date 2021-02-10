# -[Variables]-------------------------------------------------------------
variable "num_hosts" {
  default = 3
}

variable "hostname_format" {
  type    = string
  default = "centos7-%02d"
}

variable "disk_pool_name" {
  type = string
  default = "CENTOS7-POOL"
}

variable "domain" {
  type = string
  default = "hhue.at"
}

variable "disk_pool_dir" {
  type = string
  default = "/vms/kvm"
}

# 16Gb for root filesystem
variable "rootdiskBytes" {
  default = 1024*1024*1024*16
}
