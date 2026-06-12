# MariaDB Cluster Role

This role creates a MariaDB cluster with the upstream [`mariadb-cluster`](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) Helm OCI chart.

## Variables

| Name                                            | Description                                     | Default value     |
|-------------------------------------------------|-------------------------------------------------|-------------------|
| `mariadb_cluster_namespace`                     | Kubernetes namespace for the cluster            | `mariadb`         |
| `mariadb_cluster_release_name`                  | Helm release name                               | `mariadb-cluster` |
| `mariadb_cluster_name`                          | MariaDB custom resource name                    | `mariadb`         |
| `mariadb_cluster_chart_version`                 | MariaDB cluster chart version                   | `26.6.0`          |
| `mariadb_cluster_replicas`                      | Number of MariaDB replicas                      | `1`               |
| `mariadb_cluster_galera_enabled`                | Enable Galera clustering                        | `false`           |
| `mariadb_cluster_storage_size`                  | Data volume size                                | `1Gi`             |
| `mariadb_cluster_root_password_secret_name`     | Existing root password Secret name              | `""`              |
| `mariadb_cluster_root_password_secret_key`      | Root password Secret key                        | `root`            |
| `mariadb_cluster_root_password_secret_generate` | Let the chart generate the root password Secret | `true`            |
| `mariadb_cluster_databases`                     | Database CR values                              | `[]`              |
| `mariadb_cluster_users`                         | Managed MariaDB users to create                 | `[]`              |
| `mariadb_cluster_user_secret_key`               | Secret key used for generated user passwords    | `password`        |
| `mariadb_cluster_grants`                        | Grant CR values                                 | `[]`              |
| `mariadb_cluster_backups`                       | Backup CR values                                | `[]`              |
| `mariadb_cluster_physical_backups`              | PhysicalBackup CR values                        | `[]`              |
| `mariadb_cluster_values`                        | Extra values merged into the Helm chart values  | `{}`              |
| `mariadb_cluster_wait`                          | Wait for the MariaDB CR `Ready=True` condition  | `true`            |

## Notes

- Install `k8s-mariadb-operator` before this role.
- The role uses OCI charts, so no Helm repository setup is required.
- Override `mariadb_cluster_values` for chart options that do not have first-class role variables.
- Set `mariadb_cluster_root_password_secret_generate` to `false` when using an externally managed root password Secret.
- User passwords are stored in Kubernetes Secrets named `<cluster-name>-<username>-mariadb-user` unless `secret_name` is set.

## Managed Users

Set `mariadb_cluster_users` to create MariaDB `User` custom resources and matching password Secrets.

Password handling:

- Omit `password` to reuse the existing Secret value, or generate a secure 24-character random password when the Secret does not exist.
- Set `password` to a non-empty value to use that value.
- Set `password` to an empty string to fail the playbook.

User structure:

- `name`: MariaDB username.
- `password`: optional password.
- `host`: optional host. Defaults to `%`.
- `secret_name`: optional Kubernetes Secret name. Defaults to `<cluster-name>-<username>-mariadb-user`.

Example:

```yaml
mariadb_cluster_users:
  - name: app
    password: changeme
  - name: readonly
```

The role writes each password to a Kubernetes Secret and passes `passwordSecretKeyRef` to the Helm chart.

Use `mariadb_cluster_grants` to grant privileges to users.

## Example

```yaml
- name: Create MariaDB cluster
  ansible.builtin.include_role:
    name: k8s-mariadb-cluster
  vars:
    mariadb_cluster_namespace: mariadb
    mariadb_cluster_name: app-mariadb
    mariadb_cluster_replicas: 3
    mariadb_cluster_galera_enabled: true
    mariadb_cluster_storage_size: 10Gi
```
