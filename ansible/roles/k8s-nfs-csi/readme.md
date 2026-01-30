### Variables:

| Name                       | Description                                   | Default value                    |
|----------------------------|-----------------------------------------------|----------------------------------|
| namespace_name             | Kubernetes namespace for NFS CSI              | nfs-csi                          |
| nfs_csi_release_name       | Helm release name                             | nfs-csi                          |
| nfs_csi_chart_ref          | Helm chart reference                          | csi-driver-nfs/csi-driver-nfs    |
| nfs_csi_chart_version      | Chart version to install                      | "4.12.1"                         |
| nfs_csi_server             | NFS server address                            | 192.168.88.178                   |
| nfs_csi_share              | NFS export path                               | /mnt/user/k8s-nfs-csi       |
| nfs_csi_storage_class_name | StorageClass name for NFS CSI                 | nfs-csi-unraid                   |

This role installs the NFS CSI driver and creates a default StorageClass.
