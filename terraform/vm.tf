module "proxmox_vm" {
  source = "./modules/proxmox-vm"

  proxmox_node = var.proxmox_node
  vm_id        = var.vm_id
  vm_name      = var.vm_name

  vm_description = var.vm_description
  tags           = var.tags

  image_url                 = var.image_url
  image_file_name           = var.image_file_name
  image_datastore_id        = var.image_datastore_id
  image_content_type        = var.image_content_type
  image_checksum            = var.image_checksum
  image_checksum_algorithm  = var.image_checksum_algorithm
  image_overwrite           = var.image_overwrite
  image_overwrite_unmanaged = var.image_overwrite_unmanaged

  on_boot = var.on_boot
  started = var.started

  cpu_cores   = var.cpu_cores
  cpu_sockets = var.cpu_sockets
  cpu_type    = var.cpu_type

  memory_dedicated = var.memory_dedicated
  memory_floating  = var.memory_floating

  disk_datastore_id = var.disk_datastore_id
  disk_interface    = var.disk_interface
  disk_size_gb      = var.disk_size_gb
  disk_file_format  = var.disk_file_format
  disk_ssd          = var.disk_ssd

  cloud_init_datastore_id = var.cloud_init_datastore_id
  vm_user                 = var.vm_user
  vm_password             = var.vm_password
  ssh_public_key          = var.ssh_public_key

  operating_system_type = var.operating_system_type
}
