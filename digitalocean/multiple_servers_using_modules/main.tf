provider "digitalocean" {
  token = "${var.do_token}"
  version = "~> 1.7"
}

variable "do_token" {}
variable "pub_key" {}
variable "priv_key" {}
variable "ssh_fingerprint" {}

terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

module "jmeter1" {
  source          = "./modules/services/do_server"
  serverName      = "jmeter1"
  imageName       = "centos-7-x64"
  region          = "fra1"
  size            = "s-1vcpu-1gb"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  priv_key        = "${var.priv_key}"

}

module "jmeter2" {
  source          = "./modules/services/do_server"
  serverName      = "jmeter2"
  imageName       = "centos-7-x64"
  region          = "fra1"
  size            = "s-1vcpu-1gb"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  priv_key        = "${var.priv_key}"

}

module "jmeter-controller" {
  source          = "./modules/services/do_server"
  serverName      = "jmeter-controller"
  imageName       = "centos-7-x64"
  region          = "fra1"
  size            = "s-1vcpu-1gb"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  priv_key        = "${var.priv_key}"

}
