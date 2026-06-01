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

variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, for example https://pve.example.com:8006/."
  type        = string
}

variable "proxmox_insecure" {
  description = "Disable TLS verification for the Proxmox API."
  type        = bool
  default     = true
}

variable "proxmox_ssh_agent" {
  description = "Use ssh-agent for provider SSH operations."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH username for the Proxmox host when the provider needs SSH access."
  type        = string
  default     = "root"
}

