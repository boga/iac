data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = var.talos_extensions
  }
}

resource "talos_image_factory_schematic" "talos_cp" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

locals {
  version = data.talos_image_factory_extensions_versions.this.talos_version
  schematic = talos_image_factory_schematic.talos_cp.id
}

resource "proxmox_virtual_environment_download_file" "this" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "looner-proxmox"

  file_name               = "talos-${local.version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${local.schematic}/${local.version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}
