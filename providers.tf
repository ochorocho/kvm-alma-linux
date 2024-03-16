terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

# Connect to libvirt via SSH using key authentication
provider "libvirt" {
  uri = var.libvirt_uri
}
