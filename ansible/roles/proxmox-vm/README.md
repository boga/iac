# Proxmox VM Role

Create one Proxmox QEMU VM from an image URL.

## Behavior

- Authenticate with a Proxmox API token.
- Fail before download or import when `proxmox_vm_id` already exists.
- Download the image with `community.proxmox.proxmox_template` by default.
- Import and resize the disk with `community.proxmox.proxmox_disk`.
- Configure `net0` explicitly on `vmbr0` by default.
- Configure cloud-init only when `proxmox_vm_cloud_init_enabled` is `true`.
- Start the VM by default.

## Requirements

Install collections from `ansible/requirements.yml`:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

## Required Variables

Set these variables from the playbook, `group_vars`, or `host_vars`:

```yaml
proxmox_api:
  token_secret: "{{ vault_proxmox_api_token_secret }}"

proxmox_vm_id: 100
proxmox_vm_name: test-vm
proxmox_vm_image_url: https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
proxmox_vm_storage: local-lvm
```

The role reports all missing required variables in one failure.

## Proxmox API Settings

`proxmox_api` is the public connection mapping:

```yaml
proxmox_api:
  host: looner
  user: root@pam
  token_id: root@pam!ansible
  token_secret: "{{ vault_proxmox_api_token_secret }}"
  node: looner
  validate_certs: false
```

The role merges this mapping with internal defaults, so callers may set only the keys they need to override.

## Defaults

```yaml
proxmox_vm_cores: 1
proxmox_vm_memory: 512
proxmox_vm_disk_size: 5G
proxmox_vm_bridge: vmbr0
proxmox_vm_start: true
proxmox_vm_image_content_type: import
proxmox_vm_image_download_method: auto
proxmox_vm_disk: scsi0
proxmox_vm_disk_ssd: true
proxmox_vm_cloud_init_enabled: false
```

## Image Download

Default download mode is `auto`, which uses `community.proxmox.proxmox_template` with `content_type: import`.
This stores hard disk or cloud images in Proxmox storage for later disk import.

Set checksum values when available:

```yaml
proxmox_vm_image_checksum_algorithm: sha256
proxmox_vm_image_checksum: "<digest>"
```

Use a local host download only when Proxmox storage download is not suitable:

```yaml
proxmox_vm_image_download_method: get_url
proxmox_vm_image_dir: /var/lib/vz/template/qcow2
```

## Cloud-init

Cloud-init is disabled by default.
Enable it explicitly:

```yaml
proxmox_vm_cloud_init_enabled: true
proxmox_vm_cloud_init_storage: local-lvm
proxmox_vm_ciuser: ubuntu
proxmox_vm_ssh_keys:
  - "ssh-ed25519 AAAA... user@example"
proxmox_vm_ipconfig0: ip=dhcp
proxmox_vm_nameservers:
  - 1.1.1.1
proxmox_vm_searchdomain: example.test
```

## Example Playbook

```yaml
---
- name: Create Proxmox VM from image
  hosts: looner
  gather_facts: false
  roles:
    - role: proxmox-vm
      vars:
        proxmox_api:
          host: looner
          node: looner
          token_secret: "{{ vault_proxmox_api_token_secret }}"
        proxmox_vm_id: 100
        proxmox_vm_name: test-vm
        proxmox_vm_image_url: https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
        proxmox_vm_storage: local-lvm
```

## Existing VMs

If `proxmox_vm_id` already exists, the role fails and makes no changes.
The role does not update, recreate, or delete existing VMs.
