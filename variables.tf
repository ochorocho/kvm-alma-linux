# @todo: Get kubectlconfig file

variable "machines" {
  type = map(object({
    cpu        = number
    memory     = number
    name       = string
    size       = number
    ip_address = string
    dns        = string
  }))
  default = {
    "node-1" = {
      cpu        = 2
      memory     = 4096
      name       = "node-1"
      size       = 10737418240
      ip_address = "192.168.0.201"
      dns        = "192.168.0.1"
    }
    "node-2" = {
      cpu        = 2
      memory     = 4096
      name       = "node-2"
      size       = 10737418240
      ip_address = "192.168.0.202"
      dns        = "192.168.0.1"
    }
  }
}

variable "cloud_init_user_data" {
  type    = string
  default = "templates/user_data.yaml"
}

variable "cloud_init_network_config" {
  type    = string
  default = "templates/network_config.yaml"
}

variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
}

variable "os_uri" {
  type    = string
  default = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img"
}

variable "network_bridge" {
  type    = string
  default = "br0"
}

variable "storage_pool" {
  type    = string
  default = "/tmp/vm-storage"
}
