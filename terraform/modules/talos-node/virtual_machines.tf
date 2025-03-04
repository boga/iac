resource "proxmox_virtual_environment_vm" "talos_vm" {
  name        = var.vm_name
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = var.proxmox_node_name
  on_boot     = true

  cpu {
    cores = 2
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.ram_size_mb
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.this.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = var.disk_size_gb
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}
