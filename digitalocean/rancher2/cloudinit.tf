provider "template" {
  version = "~> 2.1"
}

# cloud init script for controller nodes: this one mounts the persistent volume

data "template_file" "shell-script" {
  template = "${file("scripts/cloudinit.sh")}"
  vars = {
    # DEVICE = "${data.digitalocean_volume.jmeter-data.urn}"
  }
}

data "template_cloudinit_config" "cloudinit" {

  gzip = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.shell-script.rendered}"
  }

}
