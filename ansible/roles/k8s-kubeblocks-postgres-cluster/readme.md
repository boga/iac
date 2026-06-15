# KubeBlocks PostgreSQL Cluster Role

This role assumes KubeBlocks is already installed, installs the KubeBlocks PostgreSQL addon via Helm, creates a namespace, creates a PostgreSQL cluster, and waits until the cluster reports `Running`.

## Variables

| Name                                             | Description                            | Default value                           |
|--------------------------------------------------|----------------------------------------|-----------------------------------------|
| `kb_postgres_namespace`                          | Kubernetes namespace                   | `kubeblocks-postgres`                   |
| `kb_postgres_cluster_name`                       | Name of the PostgreSQL cluster         | `postgres-cluster`                      |
| `kb_postgres_version`                            | PostgreSQL service version             | `17.5.0`                                |
| `kb_postgres_mode`                               | PostgreSQL mode for `PG_MODE`          | `standalone`                            |
| `kb_postgres_replicas`                           | Number of PostgreSQL replicas          | `1`                                     |
| `kb_postgres_cpu`                                | CPU limit/request per replica          | `0.5`                                   |
| `kb_postgres_memory`                             | Memory limit/request per replica       | `0.5Gi`                                 |
| `kb_postgres_storage`                            | Storage size for data volume           | `2Gi`                                   |
| `kb_postgres_storage_class`                      | StorageClass name                      | cluster default                         |
| `kb_postgres_termination_policy`                 | KubeBlocks termination policy          | `Delete`                                |
| `kb_postgres_addon_release_name`                 | Helm release name for PostgreSQL addon | `kb-addon-postgresql`                   |
| `kubeblocks_namespace`                           | Helm namespace for PostgreSQL addon    | group var                               |
| `kb_postgres_addon_chart_version`                | PostgreSQL addon chart version         | `1.0.2`                                 |
| `kb_postgres_superuser_secret_name`              | Existing postgres superuser Secret     | `<cluster>-postgresql-account-postgres` |
| `kb_postgres_superuser_secret_key`               | Superuser password Secret key          | `password`                              |
| `kb_postgres_container_name`                     | PostgreSQL pod container name          | `postgresql`                            |
| `kb_postgres_user_secret_key`                    | Secret key used for user passwords     | `password`                              |
| `kb_postgres_users`                              | Managed PostgreSQL users to create     | `[]`                                    |

## Notes

- Requires `KUBECONFIG` to be set in the environment.
- Assumes KubeBlocks CRDs and controllers already exist in the cluster.
- Installs the `kubeblocks/postgresql` chart into `kubeblocks_namespace` using the `kb-addon-postgresql` release name used by KubeBlocks addon ownership metadata.
- Uses the KubeBlocks `postgresql` cluster definition with a single-node `standalone` PostgreSQL cluster by default.
- Sets `storageClassName` only when `kb_postgres_storage_class` is non-empty, so Kubernetes can use the default StorageClass.
- User passwords are stored in Kubernetes Secrets named `<cluster-name>-<normalized-username>-postgres-user` unless `secret_name` is set.

## Managed Users

Set `kb_postgres_users` to create PostgreSQL roles, matching password Secrets, databases, and grants.

Password handling:

- Omit `password` to reuse the existing Secret value, or generate a secure 24-character random password when the Secret does not exist or contains an empty value.
- Set `password` to a non-empty value to use that value.
- Set `password` to an empty string to fail the playbook.

User structure:

- `name`: PostgreSQL role name.
- `password`: optional password.
- `secret_name`: optional Kubernetes Secret name. Defaults to `<cluster-name>-<normalized-username>-postgres-user`.
- `databases`: optional list of databases to create and grant access to.
  - `name`: database name.
  - `privileges`: database privileges. Defaults to `ALL PRIVILEGES`.

Example:

```yaml
kb_postgres_users:
  - name: app
    password: changeme
    databases:
      - name: app
  - name: readonly
    databases:
      - name: app
        privileges: CONNECT
```

The role writes each password to a Kubernetes Secret, then executes SQL in the primary PostgreSQL pod.
