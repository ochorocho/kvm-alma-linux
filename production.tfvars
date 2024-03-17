# Connect to remote KVM
libvirt_uri = "qemu:///system"

# Must be a cloud init ready image
#os_uri = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img"
#os_uri = "https://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud.qcow2"
os_uri = "https://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud.qcow2"
# CentOS-7-x86_64-GenericCloud.qcow2


# @todo: Get some sane network config up and running
# Define bridge for the other VMs to connect to
network_bridge = "virbr0"

# Storage pool path
storage_pool = "/tmp/alma-storage"

machines = {
  "centos-1" = {
    cpu        = 2
    memory     = 2048
    name       = "centos-6"
    size       = 10737418240
    #    ip_address = "192.168.178.201"
    #    dns        = "192.168.178.1"
  }
  "centos-2" = {
    cpu        = 2
    memory     = 2048
    name       = "centos-7"
    size       = 10737418240
    #    ip_address = "192.168.178.202"
    #    dns        = "192.168.178.1"
  }
}
