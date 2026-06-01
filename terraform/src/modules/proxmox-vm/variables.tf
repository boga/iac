variable "proxmox_node" {
  description = "Proxmox node that will host the VM."
  type        = string
}

variable "vm_id" {
  description = "Static VM ID."
  type        = number
}

variable "vm_name" {
  description = "VM name."
  type        = string
}

variable "vm_description" {
  description = "VM description."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Proxmox tags to apply to the VM."
  type        = list(string)
  default     = ["terraform"]
}

variable "image_url" {
  description = "Public URL for the cloud image to download."
  type        = string
}

variable "image_file_name" {
  description = "File name to store in Proxmox for the downloaded image."
  type        = string
}

variable "image_datastore_id" {
  description = "Datastore where the downloaded cloud image is stored."
  type        = string
}

variable "decompression_algorithm" {
  description = "Optional decompression algorithm for compressed image downloads. Possible values: gz, lzo, zst, bz2, xz."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.decompression_algorithm == null || contains(["gz", "lzo", "zst", "bz2", "xz"], var.decompression_algorithm)
    error_message = "decompression_algorithm must be one of: gz, lzo, zst, bz2, xz."
  }
}

variable "image_content_type" {
  description = "Proxmox content type for the downloaded image."
  type        = string
  default     = "import"
}

variable "image_checksum" {
  description = "Optional checksum for the downloaded image."
  type        = string
  default     = null
  nullable    = true
}

variable "image_checksum_algorithm" {
  description = "Checksum algorithm for the downloaded image."
  type        = string
  default     = "sha512"
  nullable    = false
}

variable "image_overwrite" {
  description = "Overwrite an existing managed file."
  type        = bool
  default     = true
}

variable "image_overwrite_unmanaged" {
  description = "Overwrite an existing unmanaged file."
  type        = bool
  default     = false
}

variable "on_boot" {
  description = "Start the VM automatically on node boot."
  type        = bool
  default     = true
}

variable "started" {
  description = "Whether the VM should be started after creation."
  type        = bool
  default     = true
}

variable "cpu_cores" {
  description = "Number of CPU cores."
  type        = number
  default     = 2
}

variable "cpu_sockets" {
  description = "Number of CPU sockets."
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory_dedicated" {
  description = "Dedicated memory in MB."
  type        = number
  default     = 4096
}

variable "memory_floating" {
  description = "Ballooned memory in MB."
  type        = number
  default     = 4096
}

variable "disk_datastore_id" {
  description = "Datastore for the VM disk."
  type        = string
}

variable "disk_interface" {
  description = "Disk interface name."
  type        = string
  default     = "scsi0"
}

variable "disk_size_gb" {
  description = "Disk size in GB."
  type        = number
  default     = 10
}

variable "disk_file_format" {
  description = "Disk file format."
  type        = string
  default     = "raw"
}

variable "disk_ssd" {
  description = "Mark the disk as SSD-backed."
  type        = bool
  default     = true
}

variable "cloud_init_enabled" {
  description = "Create a cloud-init drive and initialization settings."
  type        = bool
  default     = true
}

variable "cloud_init_datastore_id" {
  description = "Datastore for the cloud-init drive."
  type        = string
  default     = null
  nullable    = true
}

variable "vm_user" {
  description = "Default cloud-init username."
  type        = string
  default     = "r00t"
}

variable "vm_password" {
  description = "Optional cloud-init password."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key content to inject into the VM."
  type        = string
  default     = null
  nullable    = true
}

variable "network_bridge" {
  description = "Network bridge for the VM NIC."
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network device model."
  type        = string
  default     = "virtio"
}

variable "network_vlan_id" {
  description = "Optional VLAN ID for the VM NIC."
  type        = number
  default     = null
  nullable    = true
}

variable "ipv4_address" {
  description = "IPv4 address in CIDR notation or dhcp."
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  description = "IPv4 gateway."
  type        = string
  default     = null
  nullable    = true
}

variable "operating_system_type" {
  description = "Proxmox operating system type."
  type        = string
  default     = "l26"
}

variable "bios" {
  description = "VM BIOS type."
  type        = string
  default     = "seabios"
}

variable "machine" {
  description = "VM machine type."
  type        = string
  default     = null
  nullable    = true
}

variable "efi_disk_enabled" {
  description = "Create an EFI disk for UEFI boot."
  type        = bool
  default     = false
}

variable "efi_disk_datastore_id" {
  description = "Datastore for the EFI disk. Defaults to disk_datastore_id when null."
  type        = string
  default     = null
  nullable    = true
}

variable "efi_disk_file_format" {
  description = "EFI disk file format."
  type        = string
  default     = "raw"
}

variable "efi_disk_type" {
  description = "EFI disk size/type."
  type        = string
  default     = "4m"
}

variable "efi_disk_pre_enrolled_keys" {
  description = "Use pre-enrolled secure boot keys for the EFI disk."
  type        = bool
  default     = false
}
