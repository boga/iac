### Variables:

| Name                  | Description                                             | Default value                                                |
|-----------------------|---------------------------------------------------------|--------------------------------------------------------------|
| kubeconfig_path       | Kubeconfig path for kubernetes.core modules             | ./kubeconfig                                                 |
| nfs_csi_version       | NFS CSI manifest version                                | v4.12.1                                                      |
| nfs_csi_repo_base     | Base URL for NFS CSI manifests                           | https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/{{ nfs_csi_version }}/deploy/{{ nfs_csi_version }} |
| nfs_storageclass_name | StorageClass name                                       | nfs-unraid                                                   |
| unraid_nfs_server     | NFS server address                                      | 192.168.88.178                                               |
| unraid_nfs_share      | NFS export path                                         | /mnt/user/k8s-nfs                                            |
| nfs_mount_options     | Mount options for the StorageClass                      | [nfsvers=4.1]                                                |

This role installs the NFS CSI driver using upstream manifests and creates a StorageClass.
