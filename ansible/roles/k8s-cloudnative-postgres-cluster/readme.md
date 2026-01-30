### Variables:

| Name                         | Description                                                   | Default value |
|------------------------------|---------------------------------------------------------------|---------------|
| namespace_name               | Kubernetes namespace to create the cluster in                 | default       |
| cnpg_cluster_name            | CNPG cluster name                                             | postgres      |
| cnpg_instances               | Number of instances                                           | 1             |
| cnpg_storage_size            | PVC size                                                      | 10Gi          |
| cnpg_storage_class           | StorageClass name (empty uses the default StorageClass)       | <empty>       |
| cnpg_image_name              | Postgres image (empty lets the operator choose default image) | <empty>       |
| cnpg_bootstrap_initdb        | Enable initdb bootstrap                                       | false         |
| cnpg_bootstrap_database      | Database name for initdb bootstrap                            | <empty>       |
| cnpg_bootstrap_owner         | Owner role for initdb bootstrap                               | <empty>       |
| cnpg_db_secret_name          | Secret name for initdb owner credentials                      | <empty>       |
| cnpg_db_username             | Username for the credentials secret (store in vault)          | <empty>       |
| cnpg_db_password             | Password for the credentials secret (store in vault)          | <empty>       |
| cnpg_enable_superuser_access | Enable superuser access                                       | false         |

This role creates a CloudNativePG `Cluster` resource. If you enable `cnpg_bootstrap_initdb`, provide the bootstrap database, owner, and a secret containing the owner credentials.
