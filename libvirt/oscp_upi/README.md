# Terraform root workspace for OSCP v4 UPI setup on KVM / libvirt

This terraform root workspace allows the creation of the KVM VMs to run Openshift v4 on libvirt hypervisor using KVMs.

***Note***: This workspace creates only the VMs using the *ignition files* created via the OSCP installer before. It does not setup DNS, load balancer etc.

## Pre-Requisits

This workspace requires the following versions of

- terraform
- libvirt terraform provider


```
[hhuebler@hhuelinux oscp_upi]$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.rootvol_module_bootstrap
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.rootvol_module_master
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.rootvol_module_worker
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.stgpool_module
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.cloudimage_module
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.ignition_module_bootstrap
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
├── module.ignition_module_master
│   └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3
└── module.ignition_module_worker
    └── provider[registry.terraform.io/dmacvicar/libvirt] 0.6.3

[hhuebler@hhuelinux oscp_upi]$ terraform version
Terraform v0.14.4
+ provider registry.terraform.io/dmacvicar/libvirt v0.6.3

```

## Customizing the workspace for your needs

The workspace was designed so that updates in `variables.tf` to set the desired values matching your environment should be sufficient. There you can for example adjust:

1. the number of master VMs
2. the number of worker VMs
3. memory size
4. disk size
5. etc.

## Execution of the workspace

As the workspace used local volumes you need to run the following sequence of commands to build the infrastructure once you've customized the `variables.tf` file:

1. `terraform init`
2. `terraform plan -out /dev/shm/tf_rhcos.out`
3. `terraform apply --auto-approve /dev/shm/tf_rhcos.out`

This should create the required VMs using the ***ignition files*** created by the *oscp installer*. If you want to delete the objects again just run:

1. `terraform destroy --auto-approve`

Hope that helps. Good luck :)
