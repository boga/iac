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

module "demo_debian" {
  source = "./modules/proxmox-vm"

  count = var.demo_debian_enabled ? 1 : 0

  proxmox_node       = var.proxmox_node
  vm_id              = var.demo_debian_vm_id
  vm_name            = var.demo_debian_vm_name
  vm_description     = "Demo Debian 12 VM managed by Terraform"
  tags               = ["terraform", "demo", "debian"]
  image_url          = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  image_file_name    = "debian-12-generic-amd64.qcow2"
  image_datastore_id = var.image_datastore_id
  disk_datastore_id  = var.disk_datastore_id
  network_bridge     = var.network_bridge
  network_vlan_id    = var.network_vlan_id
  ssh_public_key     = var.demo_debian_ssh_public_key
  vm_user            = var.demo_debian_vm_user

  cpu_cores        = 2
  memory_dedicated = 2048
  memory_floating  = 2048
  disk_size_gb     = 16
}

