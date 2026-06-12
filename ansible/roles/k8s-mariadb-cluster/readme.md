# MariaDB Cluster Role

This role creates a MariaDB cluster with the upstream [`mariadb-cluster`](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) Helm OCI chart.

## Variables

| Name                                           | Description                                      | Default value     |
|------------------------------------------------|--------------------------------------------------|-------------------|
| `mariadb_cluster_namespace`                    | Kubernetes namespace for the cluster             | `mariadb`         |
| `mariadb_cluster_release_name`                 | Helm release name                                | `mariadb-cluster` |
| `mariadb_cluster_name`                         | MariaDB custom resource name                     | `mariadb`         |
| `mariadb_cluster_chart_version`                | MariaDB cluster chart version                    | `26.6.0`          |
| `mariadb_cluster_replicas`                     | Number of MariaDB replicas                       | `1`               |
| `mariadb_cluster_galera_enabled`               | Enable Galera clustering                         | `false`           |
| `mariadb_cluster_storage_size`                 | Data volume size                                 | `1Gi`             |
| `mariadb_cluster_root_password_secret_name`    | Existing root password Secret name               | `""`             |
| `mariadb_cluster_root_password_secret_key`     | Root password Secret key                         | `root`            |
| `mariadb_cluster_root_password_secret_generate`| Let the chart generate the root password Secret  | `true`            |
| `mariadb_cluster_databases`                    | Database CR values                               | `[]`              |
| `mariadb_cluster_users`                        | User CR values                                   | `[]`              |
| `mariadb_cluster_grants`                       | Grant CR values                                  | `[]`              |
| `mariadb_cluster_backups`                      | Backup CR values                                 | `[]`              |
| `mariadb_cluster_physical_backups`             | PhysicalBackup CR values                         | `[]`              |
| `mariadb_cluster_values`                       | Extra values merged into the Helm chart values   | `{}`              |
| `mariadb_cluster_wait`                         | Wait for the MariaDB CR `Ready=True` condition   | `true`            |

## Notes

- Install `k8s-mariadb-operator` before this role.
- The role uses OCI charts, so no Helm repository setup is required.
- Override `mariadb_cluster_values` for chart options that do not have first-class role variables.
- Set `mariadb_cluster_root_password_secret_generate` to `false` when using an externally managed root password Secret.

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
