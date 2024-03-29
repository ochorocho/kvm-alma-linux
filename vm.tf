resource "libvirt_pool" "vm-storage" {
  name = "cloud-storage"
  type = "dir"
  path = var.storage_pool
}

resource "libvirt_volume" "vm-os-image" {
  name   = "k3s-vm-os"
  pool   = libvirt_pool.vm-storage.name
  source = var.os_uri
}

resource "libvirt_volume" "vm-qcow2" {
  for_each       = var.machines
  name           = each.value.name
  pool           = libvirt_pool.vm-storage.name
  base_volume_id = libvirt_volume.vm-os-image.id
  size           = each.value.size
  format         = "qcow2"
}

# @todo: Enable once we decided what todo with the network.
#resource "local_file" "network_config" {
#  for_each = var.machines
#  filename = "${path.module}/.generated/network_config_rendered-${each.value.name}.yaml"
#
#  content = templatefile("${path.module}/${var.cloud_init_network_config}", {
#        ip_address = each.value.ip_address
#        gateway    = each.value.dns
#        dns        = each.value.dns
#  })
#}

resource "libvirt_domain" "vm-node" {
  for_each  = var.machines
  name      = each.value.name
  memory    = each.value.memory
  vcpu      = each.value.cpu
  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id

  # Required for "wait_for_lease" to work
  qemu_agent = true
  #  network_interface {
  #    hostname       = var.machines[each.key].name
  #    bridge         = var.network_bridge
  #    wait_for_lease = false
  #  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.vm-qcow2[each.key].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_network" "terraform_network" {
  name = "terraform-centos"

  # mode can be: "nat" (default), "none", "route", "open", "bridge"
  mode = "nat"

  #  the domain used by the DNS server in this network
  domain = "k8s.local"

  addresses = ["10.17.3.0/24", "2001:db8:ca2:2::1/64"]

  dns {
    enabled = true
    #￼   local_only = true
  }
}

resource "local_file" "user_data_nodes" {
  for_each = var.machines
  filename = "${path.module}/.generated/user_data_rendered-${each.value.name}.yaml"

  content = templatefile("${path.module}/${var.cloud_init_user_data}", {
    hostname    = each.value.name
  })
}

resource "libvirt_cloudinit_disk" "commoninit" {
  for_each       = var.machines
  name           = "commoninit-${each.value.name}.iso"
  user_data      = local_file.user_data_nodes[each.key].content
  # @todo: enable once we have a up and running image
  # network_config = local_file.network_config[each.key].content
  pool           = libvirt_pool.vm-storage.name
}
