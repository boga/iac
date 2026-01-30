### Variables:

| Name                       | Description                                   | Default value                    |
|----------------------------|-----------------------------------------------|----------------------------------|
| namespace_name             | Kubernetes namespace for Longhorn             | longhorn-system                  |
| longhorn_release_name      | Helm release name                             | longhorn                         |
| longhorn_chart_version     | Chart version to install                      | 1.5.1                            |
| longhorn_data_path         | Longhorn data path on nodes                   | /var/lib/longhorn-nfs            |
| longhorn_replicas          | Default replica count                         | 1                                |
| longhorn_storage_class_name| StorageClass name for Longhorn                | longhorn-nfs-unraid              |
| longhorn_ui_host           | Longhorn UI host                              | longhorn.{{ tailscale_tailnet_name }} |

This role installs Longhorn, creates a Tailnet ingress for the UI, and sets a default StorageClass.
