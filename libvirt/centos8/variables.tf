# -[Variables]-------------------------------------------------------------
variable "rhcos-version" {
  type = string
  default = "4.6.8"
}
variable "rhcos-arch" {
  type = string
  default = "x86_64"
}
variable "hostname" {
  type = string
  default = "centos8"
}

variable "domain" {
  type = string
  default = "os.hhue"
}

variable "disk-pool-dir" {
  type = string
  default = "/vms/kvm"
}

variable "NAT-0-mac" {
  type = string
  default = "AA:BB:CC:11:22:22"
}

# 16Gb for root filesystem
variable "rootdiskBytes" {
  default = 1024*1024*1024*16
}

##### variable "kick-start-file" {
#####   type = string
#####   default = "k8sm00.cfg"
##### }
#####
##### variable "http-base-url" {
#####   type = string
#####   default = "http://192.168.122.1:8080"
##### }
