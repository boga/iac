output "talosconfig" {
  value     = module.talos_vm.talosconfig
  description = "Talos config file"
  sensitive = true
}

output "kubeconfig" {
  value     = module.talos_vm.kubeconfig
  description = "kubectl config file"
  sensitive = true
}
