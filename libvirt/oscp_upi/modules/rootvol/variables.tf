# -[Variables]-------------------------------------------------------------
variable "mod_base_volume_id" {
  type = string
}

variable "mod_disk_size_bytes" {
  type = number
}

variable "mod_hostname_format" {
  type = string
}

variable "mod_num_hosts" {
  type = number
}

variable "mod_storage_pool_name" {
  type = string
}

variable "mod_disk_format" {
  type = string
  default = "qcow2"
}
