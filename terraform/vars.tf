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

variable "talos_worker_01_ip_addr" {
  type = string
  description = "Talos #1 worker IP address"
}

variable "tailscale_api_token" {
  type = string
  description = "Tailscale API OAuth token to connect Talos control plane to tailnet"
}
