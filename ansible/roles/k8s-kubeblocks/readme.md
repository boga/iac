### Variables:

| Name                               | Description                                       | Default value   |
|------------------------------------|---------------------------------------------------|-----------------|
| kubeblocks_namespace               | Kubernetes namespace for KubeBlocks               | group var       |
| kubeblocks_release_name            | Helm release name                                 | kubeblocks      |
| kubeblocks_chart_version           | Chart version to install                          | 1.0.2           |
| kubeblocks_storage_class           | Default StorageClass for KubeBlocks volumes       | cluster default |
| kubeblocks_data_protection_enabled | Enable the data-protection controllers for backup | false           |

This role installs [KubeBlocks](https://github.com/apecloud/kubeblocks) — a Kubernetes operator for managing databases (MySQL, PostgreSQL, MongoDB, Redis, and more) via Helm.

Notes:
- The role relies on `KUBECONFIG` being set in the environment.
- When `kubeblocks_storage_class` is empty, KubeBlocks uses the cluster default StorageClass (e.g. `local-path` on the looner cluster).
- KubeBlocks installs CRDs and controllers that manage database cluster lifecycles. Database roles install their own addons and create their own database resources.
- Data protection is disabled by default because the cluster uses `local-path-provisioner`, which doesn't support CSI snapshots. Enabling it requires a CSI driver with snapshot support (e.g., Longhorn, OpenEBS cStor, or democratic-csi with ZFS/LVM).

