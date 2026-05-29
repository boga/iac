module "demo_debian" {
  source = "./modules/proxmox-vm"

  proxmox_node       = var.proxmox_node
  vm_id              = 100
  vm_name            = "demo-debian"
  vm_description     = "Demo Debian 12 VM managed by Terraform"
  tags               = ["terraform", "demo", "debian"]
  image_url          = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  image_file_name    = "debian-12-generic-amd64.qcow2"
  image_datastore_id = "looner-ssd2"
  disk_datastore_id  = "looner-ssd2"
  network_bridge     = "vmbr0"
  network_vlan_id    = null
  ssh_public_key     = null
  vm_user            = "debian"

  cpu_cores        = 2
  memory_dedicated = 2048
  memory_floating  = 2048
  disk_size_gb     = 16
}
