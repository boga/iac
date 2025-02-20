locals {
  talos = {
    version = "v1.9.4"
    # Your image schematic ID is: 7d4c31cbd96db9f90c874990697c523482b2bae27fb4631d5583dcd9c281b1ff
    # customization:
    #   systemExtensions:
    #     officialExtensions:
    #       - siderolabs/qemu-guest-agent
    #       - siderolabs/tailscale
    schematic = "7d4c31cbd96db9f90c874990697c523482b2bae27fb4631d5583dcd9c281b1ff"
  }
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "looner-proxmox"

  file_name               = "talos-${local.talos.version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${local.talos.schematic}/${local.talos.version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}
