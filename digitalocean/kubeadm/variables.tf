
variable "do_token" {
  type    = string
  default = "undefined-token"
}

variable "domain" {}

variable "pub_key" {}
variable "priv_key" {}
variable "ssh_fingerprint" { type = string }

variable "fingerprints" { type = list(any) }

variable "remote-exec-all-nodes" { type = list(any) }

# variable "nodeCount"   { type = number }
variable "nodeNames" { type = list(any) }
variable "tagList" { type = list(any) }
variable "projectName" {
  type    = string
  default = "myProject"
}


variable "droplet-image-name" {}

variable "droplet-size" {
  type    = string
  default = "s-1vcpu-1gb"
}
