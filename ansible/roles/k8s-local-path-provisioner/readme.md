### Variables:

| Name                                       | Description                         | Default value                   |
|--------------------------------------------|-------------------------------------|---------------------------------|
| local_path_provisioner_version             | Container image version             | v0.0.36                         |
| local_path_provisioner_namespace           | Kubernetes namespace                | local-path-storage              |
| local_path_provisioner_storageclass_name   | StorageClass name                   | local-path                      |
| local_path_provisioner_default_paths       | Host paths for dynamic provisioning | ["/opt/local-path-provisioner"] |
| local_path_provisioner_reclaim_policy      | PV reclaim policy                   | Delete                          |
| local_path_provisioner_volume_binding_mode | VolumeBindingMode                   | WaitForFirstConsumer            |

This role installs [Rancher local-path-provisioner](https://github.com/rancher/local-path-provisioner) using inline resource definitions and creates a StorageClass.

Notes:
- The role relies on `KUBECONFIG` being set in the environment.
- `local_path_provisioner_default_paths` is the default path list applied to all nodes that are not explicitly listed in `nodePathMap`. Per-node overrides are supported by the upstream ConfigMap format but not currently exposed as role variables — extend the ConfigMap task if needed.
- StorageClass parameters are immutable; changing `local_path_provisioner_storageclass_name` or `local_path_provisioner_reclaim_policy` requires deleting and recreating the StorageClass or using a new name.
- On Talos Linux, ensure the host paths exist and are writable by the provisioner. You may need to mount a host path via Talos machine config if `/opt/local-path-provisioner` is on a read-only filesystem.
