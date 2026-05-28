variable "proxmox_node" {
  description = "Proxmox node that will host the VM."
  type        = string
}

variable "image_datastore_id" {
  description = "Datastore where downloaded images are stored."
  type        = string
}

variable "disk_datastore_id" {
  description = "Datastore for VM disks."
  type        = string
}

variable "network_bridge" {
  description = "Network bridge for VM NICs."
  type        = string
  default     = "vmbr0"
}

variable "network_vlan_id" {
  description = "Optional VLAN ID for VM NICs."
  type        = number
  default     = null
  nullable    = true
}
