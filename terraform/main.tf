locals {
  proxmox_api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = local.proxmox_api_token
  insecure  = var.proxmox_insecure

  ssh {
    agent    = var.proxmox_ssh_agent
    username = var.proxmox_ssh_username
  }
}

module "src" {
  source = "./src"

  proxmox_node       = var.proxmox_node
  image_datastore_id = var.image_datastore_id
  disk_datastore_id  = var.disk_datastore_id
  network_bridge     = var.network_bridge
  network_vlan_id    = var.network_vlan_id
}
