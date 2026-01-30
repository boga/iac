### Variables:

| Name               | Description                               | Default value  |
|--------------------|-------------------------------------------|----------------|
| namespace_name     | Kubernetes namespace to install CNPG into | cnpg-system    |
| cnpg_release_name  | Helm release name for the CNPG operator   | cloudnative-pg |
| cnpg_chart_version | Chart version to install                  | 0.27.0         |

This role installs the CloudNativePG operator only. It does not create any database clusters.
