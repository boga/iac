# Talos Linux on Unraid — Repeatable VM Installation Guide

This document describes **exactly how to create and install a Talos Linux VM on Unraid**, in a way that reliably boots and produces a working **single-node Kubernetes control plane**.

Follow the steps **in order**. Do **not** skip verification steps.

## Mise Setup

Use `mise` from the repository root before running Ansible commands:

```bash
mise install
mise run ansible-deps
```

This prepares the local control environment:

- Installs the configured Python runtime.
- Creates or uses the project Python environment.
- Installs Python packages from `ansible/requirements.txt`.
- Installs Ansible roles and collections from `ansible/requirements.yml`.

Use this check before running a playbook:

```bash
mise run syntax-looner
```

## Nastromo Bootstrap

Run the bootstrap tag once from `ansible/` to create the `ans` automation user and grant passwordless sudo. `ansible.cfg` provides `inventory.yml` and the default `ans` remote user for normal runs.

The bootstrap tasks are tagged with both `bootstrap` and `never`, so normal playbook runs skip them. They run only when `--tags=bootstrap` is passed.

```bash
export INITIAL_ADMIN_USER=foo
ansible-playbook nastromo.yml --tags=bootstrap      \
  --extra-vars ansible_user="${INITIAL_ADMIN_USER}" \
  --ask-become-pass
```
Make sure the SSH key is added to the `ans` user
After bootstrap, run normal playbooks as the `ans` user configured by `ansible.cfg`:

```bash
ansible-playbook nastromo.yml
```

If Ansible reports missing Python libraries such as `proxmoxer`, rerun:

```bash
mise run ansible-python-deps
```

If Ansible reports missing roles or collections, rerun:

```bash
mise run ansible-galaxy-deps
```

---

## 1. Create the VM in Unraid

### VM settings

- **BIOS**: `OVMF (UEFI)`
    - Reset OVMF variables (fresh)
- **Machine**: `Q35`
- **CPU**: Host passthrough
- **Memory**: ≥ 4 GiB (8 GiB recommended)
- **Network bridge**: `br0`
- **Network model**: `virtio-net`

### Disk (CRITICAL)

- **Primary vDisk size**: **≥ 20 GB** (40 GB recommended)
- **vDisk bus**: `VirtIO`
- **vDisk type**: `raw` or `qcow2`
- **Read/Write**: enabled

> ⚠️ If the disk is not several **GB**, Talos may “install” but will never boot.

### CD-ROM

- Attach the **Talos ISO**  
  (used **only** for installation)

---

## 2. Boot Talos into maintenance mode

Start the VM.

Talos should boot into **maintenance mode** and display:
- Node IP address (example: `192.168.88.26`)
- Maintenance banner

---

## 3. Verify the disk before installing (MANDATORY)

From your workstation:

```bash
talosctl get disks --insecure -n <NODE_IP>
