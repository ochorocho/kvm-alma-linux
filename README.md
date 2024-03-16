# AlmaLinux KVM based testing setup

## Configuration 

To use a custom configuration create a tfvars file, e.g. `custom.tfvars`.
Make sure to use the uri (`libvirt_uri`) to connect to qemu and a
network bridge named `br0` does exist.

The `machines` contains all VMs to be created. The `main` VM
is mandatory, because all other nodes connect to it.

For all configuration options see [variables.tf](variables.tf)

@todo: Add example tvars file. 

## Apply

Apply using defined variables in `custom.tfvars`. 

## Destroy

Delete all VMs and destroy its resources.

```bash
tofu destroy -var-file="custom.tfvars" -auto-approve
```

## Default user

Username: `k3s`
