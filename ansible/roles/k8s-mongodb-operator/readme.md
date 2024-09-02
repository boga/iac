### Variables:

| Name                         | Description                                                                                                      | Default value |
|------------------------------|------------------------------------------------------------------------------------------------------------------|---------------|
| databases_namespace_name     | Kubernetes namespace which will contain all the databases. The operator will track the namespace for any changes | <none>        |
| operator_namespace_name      | Kubernetes namespace to install the app into, i.e. `postgres-operator`                                           | <none>        |
| mongo_operator_chart_version | Chart version to be installed, i.e. `2.12.8506`                                                                  | <none>        |

[k8s-mongodb-database](/ansible/roles/k8s-mongodb-database/readme.md) role can be used to create a database cluster.
