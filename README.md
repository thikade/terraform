# terraform hints

## check TF and plugins version

`terraform version`

## init & later-on, upgrade of downloaded providers

`terraform init -upgrade`

## Plan to see changes

```terraform plan [-o /dev/shm/tf_centos8.out]```



## Perform changes

```terraform apply [--auto-approve] [/dev/shm/tf_centos8.out]```

## Cleanup / delete the plan

```
terraform destroy [--auto-approve]
```

# LibVirt Provider

Get the provider from [github](https://github.com/dmacvicar/terraform-provider-libvirt/releases). To enable the provider please follow issue [#747](https://github.com/dmacvicar/terraform-provider-libvirt/issues/747) as the automatic registration of the provider does not work. Short version: You need to copy the compiled provider to ```~/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64/terraform-provider-libvirt```
