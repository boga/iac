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

variable "cloud_init_datastore_id" {
  description = "Datastore for the cloud-init drive."
  type        = string
}

variable "vm_user" {
  description = "Default cloud-init username."
  type        = string
  default     = "r00t"
}

variable "debian_vm_password" {
  description = "Optional cloud-init password."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key content to inject into the VM."
  type        = string
}

variable "operating_system_type" {
  description = "Proxmox operating system type."
  type        = string
  default     = "l26"
}
