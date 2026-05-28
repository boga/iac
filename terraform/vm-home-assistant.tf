# module "proxmox_vm" {
#   source = "./modules/proxmox-vm"
#
#   proxmox_node = var.proxmox_node
#
#   vm_id          = 501
#   vm_name        = "debian-01"
#   vm_description = "Debian VM managed by Terraform"
#
#   image_url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
#   image_file_name    = "debian-13-genericcloud-amd64.qcow2"
#   image_checksum     = "902ea07fa2328d77b68a7052c30979535503acbfb5c4443c64f4aba7700dc0f1659e8c0debc2e620ed98186542aeb4e9a06d0d0b3b30c0f1074a4825b1a48f06"
#   image_datastore_id = var.image_datastore_id
#
#   cpu_cores   = 1
#   cpu_sockets = 1
#
#   memory_dedicated = 512
#   memory_floating  = 512
#
#   disk_datastore_id = var.disk_datastore_id
#   disk_size_gb      = 4
#
#   cloud_init_datastore_id = var.cloud_init_datastore_id
#   vm_user                 = var.vm_user
#   vm_password             = var.debian_vm_password
#   ssh_public_key          = var.ssh_public_key
#
#   operating_system_type = var.operating_system_type
# }
#
# module "home_assistant" {
#   source = "./modules/proxmox-vm"
#
#   proxmox_node = var.proxmox_node
#
#   vm_id          = 502
#   vm_name        = "home-assistant"
#   vm_description = "Home Assistant OS managed by Terraform"
#   tags           = ["terraform", "home-assistant"]
#
#   image_url                = "https://github.com/home-assistant/operating-system/releases/download/17.3/haos_ova-17.3.qcow2.xz"
#   image_file_name          = "haos_ova-17.3.qcow2"
#   image_datastore_id       = var.image_datastore_id
#   image_checksum           = "d42fadf806c0690792a4460ff3a72c2846c4e16e2033aefad0835662e7a9696f"
#   image_checksum_algorithm = "sha256"
#   decompression_algorithm  = "xz"
#
#   cpu_cores   = 2
#   cpu_sockets = 1
#
#   memory_dedicated = 2048
#   memory_floating  = 2048
#
#   disk_datastore_id = var.disk_datastore_id
#   disk_size_gb      = 32
#   disk_interface    = "scsi0"
#   disk_file_format  = "raw"
#
#   cloud_init_enabled = false
#
#   network_bridge  = var.network_bridge
#   network_vlan_id = var.network_vlan_id
#
#   bios             = "ovmf"
#   machine          = "q35"
#   efi_disk_enabled = true
#
#   operating_system_type = "l26"
# }
