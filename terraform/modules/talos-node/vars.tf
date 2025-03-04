variable "vm_name" {
  type = string
  description = "The name for Proxmox virtual machine"
}

variable "proxmox_node_name" {
  type = string
  description = "The name of the Proxmox node to create a VM on"
}

variable "ipv4_address" {
  type = string
  description = "IPv4 address for VM"
}

variable "ipv4_gateway" {
  type = string
  description = "IPv4 gateway for VM"
}

variable "disk_size_gb" {
  type = number
  description = "HDD size of the VM in gigabytes"
}

variable "ram_size_mb" {
  type = number
  description = "RAM size of the VM in gigabytes"
}

variable "talos_version" {
  type = string
  description = "Talos version, i.e. `v1.9.4`"
}

variable "talos_extensions" {
  type = list(string)
  description = "Talos extensions, see https://github.com/siderolabs/extensions"
}

variable "cluster_name" {
  type = string
  description = "Talos cluster name"
}

variable "cluster_endpoint" {
  type = string
  description = "The endpoint of the talos kubernetes cluster"
}

variable "endpoints" {
  type = list(string)
  description = "Talos endpoints"
}

variable "machine_type" {
  type = string
  description = "The type of machine to generate the configuration for, `worker` or `controlplane`"
}

variable "node" {
  type = string
  description = "The name of the node to bootstrap"
}

variable "nodes" {
  type = list(string)
  description = "Talos nodes"
}

variable "environment_variables" {
  type = list(string)
  description = "Environment variables for the node"
}



