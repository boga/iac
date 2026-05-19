# Talos Linux on Unraid — Repeatable VM Installation Guide

This document describes **exactly how to create and install a Talos Linux VM on Unraid**, in a way that reliably boots and produces a working **single-node Kubernetes control plane**.

Follow the steps **in order**. Do **not** skip verification steps.

## Mise Setup

Use `mise` from the repository root before running Ansible commands:

```bash
mise install
mise run ansible-deps
```

This installs the configured Python runtime, Python packages from `ansible/requirements.txt`, and Ansible roles and collections from `ansible/requirements.yml`.

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
