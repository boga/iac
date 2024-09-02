### Variables:

| Name                            | Description                                                            | Default value     |
|---------------------------------|------------------------------------------------------------------------|-------------------|
| namespace_name                  | Kubernetes namespace to install the app into, i.e. `postgres-operator` | postgres-operator |
| postgres_operator_chart_version | Chart version to be installed, i.e. `2.12.8506`                        | `5.36.3`          |

Sample cluster manifest, secrets will be named `postgres.prophet.credentials.postgresql.acid.zalan.do` and `prophet.prophet.credentials.postgresql.acid.zalan.do`:
```yaml
- name: Create Postgres cluster
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: "acid.zalan.do/v1"
      kind: "postgresql"
      metadata:
        name: "prophet"
        namespace: "{{ namespace_name }}"
        labels:
          team: acid
      spec:
        teamId: "acid"
        postgresql:
          version: "15"
        numberOfInstances: 1
        volume:
          size: "10Gi"
          storageClass: "longhorn-ssd"
        users:
          prophet: []
        databases:
          prophet: prophet
          # allowedSourceRanges: # IP ranges to access your cluster go here
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 500m
            memory: 500Mi
```