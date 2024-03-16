# Terraform/OpenTofu for Kubernetes setup on KVM

Creates multiple VMs, installs Kubernetes (k3s) and connect
them to each other.

## Configuration 

To use a custom configuration create a tfvars file, e.g. `custom.tfvars`.
Make sure to use the uri (`libvirt_uri`) to connect to qemu and a
network bridge named `br0` does exist.

The `machines` contains all VMs to be created. The `main` VM
is mandatory, because all other nodes connect to it.

For all configuration options see [variables.tf](variables.tf)

```hcl
# Connect to remote KVM, for local connections use qemu:///system (default)
libvirt_uri = "qemu+ssh://root@192.168.0.100/system?sshauth=privkey"

# Must be a cloud init ready image
os_uri = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img"

# Define bridge "br0" in OMV Network -> Interface using "enp3s0" (second port)
network_bridge = "br0"

machines = {
  # "main" is mandatory. It represents the main node.
  # All others connect to this one.
  "main" = {
    cpu        = 2
    memory     = 4096
    name       = "cloud-main"
    # Disk size in byte
    size       = 10737418240
    ip_address = "192.168.0.200"
    dns        = "192.168.0.1"
  }
  "cloud-1" = {
    cpu        = 2
    memory     = 4096
    name       = "cloud-node-1"
    size       = 10737418240
    ip_address = "192.168.0.201"
    dns        = "192.168.0.1"
  }
  "cloud-2" = {
    cpu        = 1
    memory     = 2048
    name       = "cloud-node-2"
    size       = 8737418240
    ip_address = "192.168.0.202"
    dns        = "192.168.0.1"
  }
}
```

## Apply

Apply using defined variables in `custom.tfvars`. 

```bash
tofu apply -var-file="custom.tfvars" -auto-approve
```

To use `kubectl` from your local computer to connect to the cluster copy
the content of `/etc/rancher/k3s/k3s.yaml` (main) to `~/.kube/config`.

Detailed information:

https://docs.k3s.io/cluster-access#accessing-the-cluster-from-outside-with-kubectl

## Destroy

Delete all VMs and destroy its resources.

```bash
tofu destroy -var-file="custom.tfvars" -auto-approve
```

## Default user

Username: `k3s`

Password: `password`
