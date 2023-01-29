### how to use

1. Edit `secret/env.sh` and put your DO token there
1. Run `source secret/env.sh`
1. Edit `terraform.tfvars` and define:
   - droplet sizes for controller and slaves: `droplet-size`
   - `scripts/cloudinit.sh`: bash script to be executed once when droplets are created
1. Create a volume for the master droplet. Will use XFS format.
   Adjust size before creation

1. Run TF plan/apply/destroy to manage droplets

#### Hints/caveats
- Slaves are completely stateless and do not require a volume (see Optional actions)
- Master (controller) requires a volume, but does not manage it. Recycling the master will not delete the volume!

#### Optional actions
1. Create a DO volume inside `volume` directory. Keeps its own terraform state to enable a separate lifecycle.
1. Create 2 DO firewalls (for master and slaves) inside `firewall` directory. Keeps its own terraform state to enable a separate lifecycle.
