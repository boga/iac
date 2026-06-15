# KubeBlocks PostgreSQL Cluster Role

This role installs KubeBlocks, installs the KubeBlocks PostgreSQL addon via Helm, creates a namespace, creates a PostgreSQL cluster, and waits until the cluster reports `Running`.

## Variables

| Name                                             | Description                            | Default value        |
|--------------------------------------------------|----------------------------------------|----------------------|
| `kb_postgres_namespace`                          | Kubernetes namespace                   | `kubeblocks-postgres` |
| `kb_postgres_cluster_name`                       | Name of the PostgreSQL cluster         | `postgres-cluster`   |
| `kb_postgres_version`                            | PostgreSQL service version             | `17.5.0`             |
| `kb_postgres_mode`                               | PostgreSQL mode for `PG_MODE`          | `standalone`         |
| `kb_postgres_replicas`                           | Number of PostgreSQL replicas          | `1`                  |
| `kb_postgres_cpu`                                | CPU limit/request per replica          | `0.5`                |
| `kb_postgres_memory`                             | Memory limit/request per replica       | `0.5Gi`              |
| `kb_postgres_storage`                            | Storage size for data volume           | `2Gi`                |
| `kb_postgres_storage_class`                      | StorageClass name                      | cluster default      |
| `kb_postgres_termination_policy`                 | KubeBlocks termination policy          | `Delete`             |
| `kb_postgres_addon_release_name`                 | Helm release name for PostgreSQL addon | `postgresql`         |
| `kb_postgres_addon_namespace`                    | Helm namespace for PostgreSQL addon    | `kubeblocks`         |
| `kb_postgres_addon_chart_version`                | PostgreSQL addon chart version         | `1.2.0-alpha.0`      |

## Notes

- Requires `KUBECONFIG` to be set in the environment.
- Includes the `k8s-kubeblocks` role before installing the PostgreSQL addon Helm chart.
- Installs the `kubeblocks/postgresql` chart into `kb_postgres_addon_namespace`.
- Uses the KubeBlocks `postgresql` cluster definition with a single-node `standalone` PostgreSQL cluster by default.
- Sets `storageClassName` only when `kb_postgres_storage_class` is non-empty, so Kubernetes can use the default StorageClass.
