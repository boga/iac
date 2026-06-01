resource "proxmox_download_file" "cloud_image" {
  content_type            = var.image_content_type
  datastore_id            = var.image_datastore_id
  node_name               = var.proxmox_node
  url                     = var.image_url
  file_name               = var.image_file_name
  checksum                = var.image_checksum
  checksum_algorithm      = var.image_checksum == null ? null : var.image_checksum_algorithm
  decompression_algorithm = var.decompression_algorithm
  overwrite               = var.image_overwrite
  overwrite_unmanaged     = var.image_overwrite_unmanaged
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  description = var.vm_description
  tags        = var.tags

  node_name = var.proxmox_node
  vm_id     = var.vm_id
  on_boot   = var.on_boot
  started   = var.started
  bios      = var.bios
  machine   = var.machine

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
  }

  disk {
    datastore_id = var.disk_datastore_id
    import_from  = proxmox_download_file.cloud_image.id
    interface    = var.disk_interface
    size         = var.disk_size_gb
    file_format  = var.disk_file_format
    ssd          = var.disk_ssd
  }

  serial_device {
    device = "socket"
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk_enabled ? [1] : []

    content {
      datastore_id      = coalesce(var.efi_disk_datastore_id, var.disk_datastore_id)
      file_format       = var.efi_disk_file_format
      type              = var.efi_disk_type
      pre_enrolled_keys = var.efi_disk_pre_enrolled_keys
    }
  }

  dynamic "initialization" {
    for_each = var.cloud_init_enabled ? [1] : []

    content {
      datastore_id = var.cloud_init_datastore_id

      user_account {
        username = var.vm_user
        keys     = var.ssh_public_key == null ? [] : [var.ssh_public_key]
        password = var.vm_password
      }

      ip_config {
        ipv4 {
          address = var.ipv4_address
          gateway = var.ipv4_gateway
        }
      }
    }
  }

  // Docs say network_device is optional and has defaults. Yet the block is not being created if it's not configured
  network_device {
    bridge  = var.network_bridge
    model   = var.network_model
    vlan_id = var.network_vlan_id
  }

  operating_system {
    type = var.operating_system_type
  }
}
