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

  # These are in env vars
  # username = "root@pam"
  # password = "the-password-set-during-installation-of-proxmox-ve"
  # uncomment (unless on Windows...)
  # tmp_dir  = "/var/tmp"

  ssh {
    agent    = false
    username = "root"
    node {
      name    = "looner-proxmox"
      address = "100.98.58.63"
    }
  }
}

resource "proxmox_virtual_environment_vm" "debian_vm" {
  name      = "test-debian"
  node_name = "looner-proxmox"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  initialization {
    user_account {
      # do not use this in production, configure your own ssh key instead!
      username = "user"
      password = "password"
    }
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/debian-12.9.0-amd64-netinst.iso"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
}