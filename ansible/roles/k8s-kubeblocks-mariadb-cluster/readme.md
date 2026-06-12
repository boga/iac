# KubeBlocks MariaDB Cluster Role

This role creates a MariaDB cluster using KubeBlocks.

## Requirements

- Install the `k8s-kubeblocks` role before this role.
- Keep `kb_mariadb_replicas` set to `1`; the MariaDB addon does not support replicate mode.

## Variables

| Name                       | Description                            | Default value      |
|----------------------------|----------------------------------------|--------------------|
| `kb_mariadb_namespace`     | Kubernetes namespace                   | `""` (required) |
| `kb_mariadb_cluster_name`  | Name of the MariaDB cluster            | `mariadb-cluster`  |
| `kb_mariadb_addon_release_name` | Helm release name for the addon   | `kb-addon-mariadb` |
| `kb_mariadb_addon_namespace` | Namespace for the addon release      | `kubeblocks`       |
| `kb_mariadb_addon_chart_ref` | Helm chart reference for the addon    | `kubeblocks/mariadb` |
| `kb_mariadb_addon_chart_version` | Helm chart version for the addon | `1.0.1`            |
| `kb_mariadb_addon_chart_parent_dir` | Local directory for the patched addon chart | `/tmp/kubeblocks-mariadb-addon-chart` |
| `kb_mariadb_addon_chart_path` | Local path for the patched addon chart | `{{ kb_mariadb_addon_chart_parent_dir }}/mariadb` |
| `kb_mariadb_component_def` | KubeBlocks component definition name   | `mariadb-1.0.1`    |
| `kb_mariadb_replicas`      | Number of MariaDB replicas             | `1`                |
| `kb_mariadb_version`       | MariaDB service version                | `10.6.15`          |
| `kb_mariadb_cpu`           | CPU limit/request per replica          | `0.5`              |
| `kb_mariadb_memory`        | Memory limit/request per replica       | `0.5Gi`            |
| `kb_mariadb_storage`       | Storage size for data volume           | `1Gi`              |
| `kb_mariadb_storage_class` | StorageClass name                      | cluster default    |
| `kb_mariadb_users`         | List of custom MariaDB users to create | `[]`               |

## Custom MariaDB Users

Set `kb_mariadb_users` to create users, databases, grants, and matching Kubernetes secrets.
Omit `password` to auto-generate one.

```yaml
kb_mariadb_users:
  - name: app_user
    password: changeme
    databases:
      - name: app_db
        privileges: "ALL PRIVILEGES"
  - name: readonly
    databases:
      - name: app_db
        privileges: "SELECT"
```

The role stores each user password in a secret named `<cluster-name>-<user>-mariadb-user`.

## Notes

- The role pulls and patches the `kubeblocks/mariadb` addon chart before installing it.
- The chart patch fixes an upstream `ComponentVersion` validation error where `changes` renders as `null`.
- The role waits for the MariaDB `ComponentDefinition` before creating the cluster.
- The role fails when `kb_mariadb_namespace` is empty.
- KubeBlocks creates the root password secret named `<cluster-name>-mariadb-account-root`.
- The MariaDB service is exposed as `<cluster-name>-mariadb` on port `3306`.
- Connect with `kubectl exec -it <pod-with-mariadb-client> -- mariadb -h <cluster-name>-mariadb -u root -p`.
