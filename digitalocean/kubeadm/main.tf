
#### DROPLET Data Sources

data "digitalocean_sizes" "main" {
  filter {
    key    = "vcpus"
    values = [2,4]
  }

  filter {
    key    = "memory"
    values = [1024, 8192]
  }

  filter {
    key    = "regions"
    values = ["fra1"]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}


# put number of slaves into DNS - will be used by Jmeter master to reach all slaves
# resource "digitalocean_record" "nodeCount" {
#   name = "kubeadm-node-count"
#   domain = "2i.at"
#   type = "TXT"
#   value = var.nodeCount
#   ttl = 180
# }

resource "digitalocean_vpc" "kubeadm" {
  name     = "kubadm-vpc"
  region   = "fra1"
  ip_range = "10.10.0.0/16"
}


module "nodes" {
  instance_count   = length(var.nodeNames)
  # instance_count   = 1
  source           = "./modules/services/do_server"
  serverNames      = var.nodeNames
  imageName        = var.droplet-image-name
  region           = "fra1"
  tags             = join(",", var.tagList)
  size             = var.droplet-size
  ssh_fingerprints = var.fingerprints
  priv_key         = var.priv_key
  vpc_uuid         = digitalocean_vpc.kubeadm.id
  user_data        = data.template_cloudinit_config.cloudinit.rendered
  # remote-exec-provisioner-commands = var.remote-exec-all-nodes
}


#### PROJECT ###############

resource "digitalocean_project" "project" {
  name        = var.projectName
  # purpose     = "Web Application"
  resources   = module.nodes.urn
}
