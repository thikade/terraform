variable "clusterDomain" {
  description = "cluster domain"
  type        = string
  default     = "2i.at"
}
variable "serverNames" {
  description = "droplet name list"
  type        = list
}

variable "instance_count" {
  description = "number of instances"
  type        = number
  default = 1
}

variable "vpc_uuid" {
  type        = string
  default     = ""
}


variable "ssh_fingerprints" {
  description = "SSH pub key fingerprints"
  type        = list
}

variable "size" {
  description = "droplet size specifier "
  type        = string
  default     = "s-1vcpu-1gb"

  # other sizes:
  # size = "s-4vcpu-8gb"
  # size = "s-2vcpu-2gb"
  # size = "s-1vcpu-1gb"
}

variable "region" {
  description = "DO region"
  type        = string
  default     = "fra1"
}

variable "user_data" {
  description = "user data field"
  type        = string
  default     = ""
}

variable "tags" {
  description = "comma-separated list of tag names"
  type        = string
  default     = ""
}

variable "imageName" {
  description = "DO droplet slug name"
  type        = string
  default     = "centos-7-x64"
}

variable "priv_key" {
  description = "ssh private key-file path used by provisioner"
  type        = string
}

variable "remote-exec-provisioner-commands" {
  description = "bash command list to execute once droplet is up"
  type        = list
  default = []
}
