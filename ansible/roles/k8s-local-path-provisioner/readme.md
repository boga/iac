### Variables:

| Name                                            | Description                          | Default value                   |
|-------------------------------------------------|--------------------------------------|---------------------------------|
| local_path_provisioner_version                  | Container image version              | v0.0.36                         |
| local_path_provisioner_namespace                | Kubernetes namespace                 | local-path-storage              |
| local_path_provisioner_storageclass_name        | StorageClass name                    | local-path                      |
| local_path_provisioner_default_paths            | Host paths for dynamic provisioning  | `[]`                            |
| local_path_provisioner_reclaim_policy           | PV reclaim policy                    | Delete                          |
| local_path_provisioner_volume_binding_mode      | VolumeBindingMode                    | WaitForFirstConsumer            |
| local_path_provisioner_default_storageclass     | Mark StorageClass as cluster default | true                            |

This role installs [Rancher local-path-provisioner](https://github.com/rancher/local-path-provisioner) using inline resource definitions and creates a StorageClass.

Notes:
- The role relies on `KUBECONFIG` being set in the environment.
- The deployment includes a toleration for `node-role.kubernetes.io/control-plane:NoSchedule` so it schedules on single-node clusters.
- `local_path_provisioner_default_paths` is the default path list applied to all nodes that are not explicitly listed in `nodePathMap`. Per-node overrides are supported by the upstream ConfigMap format but not currently exposed as role variables — extend the ConfigMap task if needed.
- StorageClass parameters are immutable; changing `local_path_provisioner_storageclass_name` or `local_path_provisioner_reclaim_policy` requires deleting and recreating the StorageClass or using a new name.
- When `local_path_provisioner_default_storageclass` is `true`, the annotation `storageclass.kubernetes.io/is-default-class: "true"` is added, making PVCs without an explicit `storageClassName` use this class automatically.
- On Talos Linux, ensure the host paths exist and are writable by the provisioner. You may need to mount a host path via Talos machine config if the path is on a read-only filesystem.