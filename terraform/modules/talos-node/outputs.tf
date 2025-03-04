output "talosconfig" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  description = "Talos config file"
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  description = "kubectl config file"
  sensitive = true
}
