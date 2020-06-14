
variable "do_token"         {}
variable "pub_key"          {}
variable "priv_key"         {}
variable "ssh_fingerprint"  { type = string}

variable "fingerprints"     { type = list}

variable "remote-exec-all-nodes"      { type = list }

variable "nodeCount"   { type = number }
variable "nodeNames"   { type = list }
variable "tagList"     { type = list }
variable "projectName" { 
  type = string 
  default = "myProject"
}


variable "droplet-size"    {
  type = string
  default = "s-1vcpu-1gb"
}
