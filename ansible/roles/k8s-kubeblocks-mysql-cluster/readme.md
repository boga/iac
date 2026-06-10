### Variables:

| Name                   | Description                          | Default value    |
|------------------------|--------------------------------------|------------------|
| kb_mysql_namespace     | Kubernetes namespace                 | kubeblocks-debug |
| kb_mysql_cluster_name  | Name of the MySQL cluster            | mysql-cluster    |
| kb_mysql_component_def | KubeBlocks component definition name | mysql-8.4        |
| kb_mysql_replicas      | Number of MySQL replicas             | 1                |
| kb_mysql_version       | MySQL version (e.g., 8.4.2)          | 8.4.2            |
| kb_mysql_cpu           | CPU limit/request per replica        | 0.5              |
| kb_mysql_memory        | Memory limit/request per replica     | 0.5Gi            |
| kb_mysql_storage       | Storage size for data volume         | 10Gi             |
| kb_mysql_storage_class | StorageClass name                    | cluster default  |

This role creates a MySQL cluster using KubeBlocks.

Notes:
- Requires the `k8s-kubeblocks` role to be installed first
- KubeBlocks automatically creates a root password secret named `<cluster-name>-mysql-account-root`
- The MySQL service is exposed as `<cluster-name>-mysql` on port 3306
- To connect: `kubectl exec -it <pod-with-mysql-client> -- mysql -h <cluster-name>-mysql -u root -p`
