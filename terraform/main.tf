terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.71.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://looner-proxmox:8006"
  insecure = true

  api_token = var.proxmox_api_token

  ssh {
    agent    = false
    username = "root"
    node {
      name    = "looner-proxmox"
      address = "100.98.58.63"
    }
  }
}
