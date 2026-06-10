### Variables:

| Name                                | Description                                      | Default value |
|-------------------------------------|--------------------------------------------------|---------------|
| kubeblocks_namespace                | Kubernetes namespace for KubeBlocks              | kubeblocks    |
| kubeblocks_release_name             | Helm release name                                | kubeblocks    |
| kubeblocks_chart_version            | Chart version to install                         | 1.0.2         |
| kubeblocks_storage_class            | Default StorageClass for KubeBlocks volumes      | _(empty — use cluster default)_ |
| kubeblocks_data_protection_enabled | Enable the data-protection controllers for backup | true          |

This role installs [KubeBlocks](https://github.com/apecloud/kubeblocks) — a Kubernetes operator for managing databases (MySQL, PostgreSQL, MongoDB, Redis, and more) via Helm. Use the `k8s-create-namespace` role beforehand to create the target namespace.

Notes:
- The role relies on `KUBECONFIG` being set in the environment.
- When `kubeblocks_storage_class` is empty, KubeBlocks uses the cluster default StorageClass (e.g. `local-path` on the looner cluster).
- KubeBlocks installs CRDs and controllers that manage database cluster lifecycles. To create an actual database, use `kubectl apply -f` or a separate role.
