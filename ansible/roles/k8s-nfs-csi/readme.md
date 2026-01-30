### Variables:

| Name                  | Description                        | Default value                                                                                                      |
|-----------------------|------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| nfs_csi_version       | NFS CSI manifest version           | v4.12.1                                                                                                            |
| nfs_csi_repo_base     | Base URL for NFS CSI manifests     | https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/{{ nfs_csi_version }}/deploy/{{ nfs_csi_version }} |
| nfs_storageclass_name | StorageClass name                  | nfs-unraid                                                                                                         |
| unraid_nfs_server     | NFS server address                 | 192.168.88.178                                                                                                     |
| unraid_nfs_share      | NFS export path                    | /mnt/user/k8s-nfs                                                                                                  |
| nfs_mount_options     | Mount options for the StorageClass | [nfsvers=4.1]                                                                                                      |

This role installs the NFS CSI driver using upstream manifests and creates a StorageClass.

NFS share setup (Unraid):
- Create a share (example: `k8s-nfs`)
  - `Export: Yes`
  - `Security: Private`.
- Export rules should allow your Kubernetes node subnet (for example `192.168.88.0/24`).
- Recommended export options: `rw,async,secure,no_subtree_check,no_root_squash` (match your Unraid export settings).
- Ensure the export path exists and has write permissions for the UID/GID your pods will use.
- Verify from a node: `showmount -e {{ unraid_nfs_server }}` and `mount -t nfs -o nfsvers=4.1 {{ unraid_nfs_server }}:{{ unraid_nfs_share }} /mnt`.

Generic `/etc/exports` example (non-Unraid):
`{{ unraid_nfs_share }} 192.168.88.0/24(rw,sync,no_subtree_check,no_root_squash)`

Notes:
- The role relies on `KUBECONFIG` being set in the environment.
