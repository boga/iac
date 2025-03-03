provider "talos" {}

data "talos_image_factory_extensions_versions" "talos_cp" {
  # get the latest talos version
  talos_version = "v1.9.4"
  filters = {
    names = [
      "siderolabs/qemu-guest-agent",
      "siderolabs/tailscale",
    ]
  }
}

resource "talos_image_factory_schematic" "talos_cp" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.talos_cp.extensions_info.*.name
        }
      }
    }
  )
}
