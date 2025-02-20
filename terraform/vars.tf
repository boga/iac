variable "proxmox_api_token" {
  type = string
  sensitive = true
}

variable "cluster_name" {
  type    = string
}

variable "default_gateway" {
  type = string
  description = "Default gateway for Talos nodes"
}

variable "talos_cp_01_ip_addr" {
  type = string
  description = "Talos #1 control plane IP address"
}
