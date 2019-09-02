variable "serverName" {
  description = "droplet name"
  type        = string
}

variable "ssh_fingerprint" {
  description = "SSH pub key fingerprint"
  type        = string
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

variable "imageName" {
  description = "DO droplet slug name"
  type        = string
  default     = "centos-7-x64"
}

variable "priv_key" {
  description = "ssh private key-file path used by provisioner"
  type        = string
}
