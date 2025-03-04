module "talos_vm" {
  source = "./modules/talos-node"

  proxmox_node_name = "looner-proxmox"

  vm_name = "talos-cp-mod-01"
  disk_size_gb = 20
  ram_size_mb = 4096
  ipv4_address = "${var.talos_cp_01_ip_addr}/24"
  ipv4_gateway = var.default_gateway

  talos_extensions = [
    "siderolabs/qemu-guest-agent",
    "siderolabs/tailscale",
  ]
  talos_version = "v1.9.4"
  cluster_endpoint = "https://${var.talos_cp_01_ip_addr}:6443"
  cluster_name = var.cluster_name
  endpoints = [
    var.talos_cp_01_ip_addr,
    # var.talos_worker_01_ip_addr,
  ]
  environment_variables = [
    "TS_AUTHKEY=${var.tailscale_api_token}",
    "TS_HOSTNAME=talos-cp",
  ]
  machine_type = "controlplane"
  node = var.talos_cp_01_ip_addr
  nodes = [
    var.talos_cp_01_ip_addr,
    # var.talos_worker_01_ip_addr,
  ]
}
