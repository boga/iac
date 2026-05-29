variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, for example https://pve.example.com:8006/."
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token id in the format user@realm!token."
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Disable TLS verification for the Proxmox API."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH username for the Proxmox host when the provider needs SSH access."
  type        = string
  default     = "root"
}

variable "proxmox_ssh_agent" {
  description = "Use ssh-agent for provider SSH operations."
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node that will host the VM."
  type        = string
}

variable "image_datastore_id" {
  description = "Datastore where the downloaded cloud image is stored."
  type        = string
}

variable "disk_datastore_id" {
  description = "Datastore for the VM disk."
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

variable "demo_debian_enabled" {
  description = "Create the demo Debian VM."
  type        = bool
  default     = true
}

variable "demo_debian_vm_id" {
  description = "Static VM ID for the demo Debian VM."
  type        = number
  default     = 100
}

variable "demo_debian_vm_name" {
  description = "Name for the demo Debian VM."
  type        = string
  default     = "demo-debian"
}

variable "demo_debian_vm_user" {
  description = "Default cloud-init username for the demo Debian VM."
  type        = string
  default     = "debian"
}

variable "demo_debian_ssh_public_key" {
  description = "SSH public key content to inject into the demo Debian VM."
  type        = string
  default     = null
  nullable    = true
}

