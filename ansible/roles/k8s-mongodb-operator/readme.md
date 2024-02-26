### Variables:

| Name                         | Description                                                            | Default value     |
|------------------------------|------------------------------------------------------------------------|-------------------|
| namespace_name               | Kubernetes namespace to install the app into, i.e. `postgres-operator` | postgres-operator |
| mongo_operator_chart_version | Chart version to be installed, i.e. `2.12.8506`                        | `5.36.3`          |

Sample cluster manifest:
```yaml
- name: "Create MongoDB password secret"
  kubernetes.core.k8s:
    state: "present"
    namespace: "apps"
    definition:
      apiVersion: v1
      kind: Secret
      metadata:
        name: my-user-password
      type: Opaque
      stringData:
        password: "SomeRandomPass"

- name: "Create MongoDB cluster"
  kubernetes.core.k8s:
    state: "present"
    namespace: "apps"
    definition:
      apiVersion: "mongodbcommunity.mongodb.com/v1"
      kind: "MongoDBCommunity"
      metadata:
        name: "example-mongodb"
      spec:
        members: 3
        type: ReplicaSet
        version: "6.0.7"
        security:
          authentication:
            modes: ["SCRAM"]
        users:
          - name: my-user
            db: admin
            passwordSecretRef: # a reference to the secret that will be used to generate the user's password
              name: my-user-password
            roles:
              - name: clusterAdmin
                db: admin
              - name: userAdminAnyDatabase
                db: admin
            scramCredentialsSecretName: my-scram
        additionalMongodConfig:
          storage.wiredTiger.engineConfig.journalCompressor: zlib
```
