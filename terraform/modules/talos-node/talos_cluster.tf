resource "talos_machine_secrets" "machine_secrets" {}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = var.endpoints
  nodes                = var.nodes
}

data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = var.machine_type
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
  config_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "tailscale"
      environment = var.environment_variables
    })
  ]
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  depends_on = [proxmox_virtual_environment_vm.talos_vm]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  count                       = 1
  node                        = var.node
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.node
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.bootstrap
  ]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.node
}
