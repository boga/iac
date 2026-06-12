# MariaDB Operator Role

This role installs [`mariadb-operator`](https://github.com/mariadb-operator/mariadb-operator) with Helm OCI charts from GitHub Container Registry.

## Variables

| Name                                  | Description                                   | Default value                          |
|---------------------------------------|-----------------------------------------------|----------------------------------------|
| `mariadb_operator_namespace`          | Kubernetes namespace for the operator release | `mariadb-operator`                     |
| `mariadb_operator_release_name`       | Helm release name for the operator chart      | `mariadb-operator`                     |
| `mariadb_operator_crds_release_name`  | Helm release name for the CRDs chart          | `mariadb-operator-crds`                |
| `mariadb_operator_chart_version`      | MariaDB operator chart version                | `26.6.0`                               |
| `mariadb_operator_crds_chart_version` | MariaDB operator CRDs chart version           | `{{ mariadb_operator_chart_version }}` |
| `mariadb_operator_values`             | Values passed to the operator Helm chart      | `{}`                                   |

## Notes

- The role relies on `KUBECONFIG` being set in the environment.
- The CRDs chart installs before the operator chart, matching the upstream Helm installation order.
- The role uses OCI charts, so no Helm repository setup is required.
- Deploy actual MariaDB instances with `MariaDB` custom resources after the operator is ready.
