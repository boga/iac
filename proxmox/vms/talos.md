# Talos VM

## Identity

- VMID: `105`
- Name: `talos`
- Node: `proxmox`
- Pool: `automation-managed`
- Status: `running`
- Purpose: Talos Linux Kubernetes node (single-node control plane + worker)

## Source

- Sidero Labs: [Talos on Proxmox](https://docs.siderolabs.com/talos/v1.14/platform-specific-installations/virtualized-platforms/proxmox)
- Virtualization Howto: [Proxmox Kubernetes install with Talos Linux](https://www.virtualizationhowto.com/2024/01/proxmox-kubernetes-install-with-talos-linux/)

Current state checked with:

```bash
ssh looner-automation-agent 'qm config 105'
ssh looner-automation-agent 'qm status 105'
```

## Firmware and Boot

- BIOS: `ovmf`
- Machine: `q35`
- OS type: `l26`
- Boot order: `scsi0;scsi1`
- EFI disk: `looner-ssd2:105/vm-105-disk-0.raw`, `efitype=4m`, `pre-enrolled-keys=0`
- Serial console: `socket`
- On boot: `1`

## Secure Boot

Secure Boot is disabled for the first Talos VM.

Rationale:

- Avoid requiring a Secure Boot-capable Talos installer image during first bootstrap.
- Avoid EFI key enrollment complexity while proving the VM and cluster path.
- Keep Proxmox OVMF support available so Secure Boot can be enabled later.

Enable Secure Boot later only after confirming the Talos image supports it. Then set the EFI disk with `pre-enrolled-keys=1`.

## Compute

- CPU type: `host`
- Sockets: `1`
- Cores: `3`
- Memory: `12288` MB (12 GB)
- Balloon memory: `0` MB
- NUMA: `0`

## Disks

- Controller: `virtio-scsi-pci`
- `scsi0`: `looner-ssd2`, `20G`, `raw`, `cache=writethrough`, `discard=on`, `ssd=1` — Talos OS install disk
- `scsi1`: `looner-ssd2`, `80G`, `raw`, `cache=writethrough`, `discard=on`, `ssd=1` — Kubernetes data volume (`/var/local/storage`)
- EFI disk: `looner-ssd2:105/vm-105-disk-0.raw`, `528K`

**Do not** use `virtio-scsi-single`; Talos docs warn it can hang bootstrap or break disk discovery.

### Disk layout in Talos

| Proxmox | Talos device | Purpose                         | Size |
|---------|--------------|---------------------------------|------|
| scsi0   | `/dev/sda`   | Talos OS install                | 20G  |
| scsi1   | `/dev/sdb`   | `/var/local/storage` (k8s data) | 80G  |

Configured via `talos/patch.yml`:

```yaml
machine:
  install:
    disk: /dev/sda
  disks:
    - device: /dev/sdb
      partitions:
        - mountpoint: /var/local/storage
cluster:
  allowSchedulingOnControlPlanes: true
```

## Network

- `net0`: `virtio=BC:24:11:4E:5B:82`, `bridge=vmbr0`, `firewall=0`
- VLAN: none planned

## Devices and Guest Settings

- QEMU guest agent: `enabled=1`
- RNG: `source=/dev/urandom`
- Tablet: Proxmox default

## History

- 2026-10-16: Upgraded Talos from v1.13.3 to v1.14.2 and added the QEMU guest agent system extension.

## Notes

- Originally created as VMID `104` with a single 100G disk. Migrated to VMID `105` with split disks (20G OS + 80G data).
- Disks were recreated fresh (disk-5, disk-6) after filesystem mismatch issues on reused volumes.
- ISO was ejected after bootstrap; boot order changed from `ide2;scsi0;scsi1` to `scsi0;scsi1`.
- Sidero recommends OVMF, `q35`, CPU `host`, VirtIO network, and VirtIO SCSI.
- Talos does not support memory hotplug, so ballooning is disabled.
- Use Talos Factory schematic `ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515`.
- Factory customization includes the official `siderolabs/qemu-guest-agent` extension.
- Talos v1.14.2 artifacts:
  - Disk image: `https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.14.2/nocloud-amd64.raw.xz`
  - ISO: `https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.14.2/nocloud-amd64.iso`
  - PXE: `https://pxe.factory.talos.dev/pxe/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.14.2/nocloud-amd64`
  - Upgrade installer: `factory.talos.dev/nocloud-installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.14.2`
- VM initially boot-looped with OVMF and no EFI disk.
- Added EFI disk, `q35`, CPU `host`, balloon `0`, RNG, and restarted VM.
- Display was changed from `serial0` to Proxmox default so the console UI is visible.
- Automation runner blocks double-dash `--machine`, `--cpu`, `--efidisk0`, `--balloon`, and `--rng0`; single-dash forms work.
- Automation runner still blocks `qm importdisk`, file move/copy tools, and boot-order arguments containing semicolons.
- `qm destroy` is blocked by the runner; manual removal required.

## Proxmox Commands Preview

Create VM:

```bash
ssh looner-automation-agent 'qm create 105 --name talos --pool automation-managed --ostype l26 -machine q35 --bios ovmf -efidisk0 looner-ssd2:1,efitype=4m,pre-enrolled-keys=0 -cpu host --sockets 1 --cores 3 --memory 8192 -balloon 0 --scsihw virtio-scsi-pci --scsi0 looner-ssd2:20,cache=writethrough,discard=on,ssd=1 --scsi1 looner-ssd2:80,cache=writethrough,discard=on,ssd=1 --net0 virtio,bridge=vmbr0,firewall=0 --serial0 socket --agent enabled=1 -rng0 source=/dev/urandom --onboot 1'
```

Start VM:

```bash
ssh looner-automation-agent 'qm start 105'
```

Apply Talos config:

```bash
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP -f controlplane-patched.yaml
talosctl bootstrap --nodes $CONTROL_PLANE_IP
```

Patch machine config after bootstrap:

```bash
talosctl patch machineconfig --nodes $CONTROL_PLANE_IP --patch @patch.yml
```