# Talos VM

## Identity

- VMID: `104`
- Name: `talos`
- Node: `proxmox`
- Pool: `automation-managed`
- Status: `running`
- Purpose: Talos Linux Kubernetes node

## Source

- Sidero Labs: [Talos on Proxmox](https://docs.siderolabs.com/talos/v1.13/platform-specific-installations/virtualized-platforms/proxmox)
- Virtualization Howto: [Proxmox Kubernetes install with Talos Linux](https://www.virtualizationhowto.com/2024/01/proxmox-kubernetes-install-with-talos-linux/)

Current state checked with:

```bash
ssh looner-automation-agent 'qm list'
ssh looner-automation-agent 'pvesh get /nodes'
ssh looner-automation-agent 'pvesh get /nodes/proxmox/storage'
```

## Firmware and Boot

- BIOS: `ovmf`
- Machine: `q35`
- OS type: `l26`
- Boot order: `ide2`
- EFI disk: `looner-ssd2`, `efitype=4m`, `pre-enrolled-keys=0`
- Serial console: `socket`
- VGA: `serial0`
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
- Memory: `8192` MB (8 GB)
- Balloon memory: `0` MB
- NUMA: `0`

## Disks

- Controller: `virtio-scsi-pci`
- `scsi0`: `looner-ssd2`, `100G`, `raw`, `cache=writethrough`, `discard=on`, `ssd=1`
- `ide2`: `looner-ssd2:iso/talos-v1.13.3-nocloud-amd64-90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13.iso`, `media=cdrom`
- Talos raw image staged at `/mnt/sdb1/import/talos-v1.13.3-nocloud-amd64-90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13.raw` but not used

**Do not** use `virtio-scsi-single`; Talos docs warn it can hang bootstrap or break disk discovery.

## Network

- `net0`: `virtio`, `bridge=vmbr0`, `firewall=0`
- VLAN: none planned

## Devices and Guest Settings

- QEMU guest agent: `enabled=1`
- RNG: `source=/dev/urandom`
- Tablet: Proxmox default

## Notes

- VMID `104` exists as `talos` and is running.
- Sidero recommends OVMF, `q35`, CPU `host`, VirtIO network, and VirtIO SCSI.
- Talos does not support memory hotplug, so ballooning is disabled.
- Use Talos Factory schematic `90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13` for first boot.
- Factory customization includes these official extensions:
  - `siderolabs/iscsi-tools`
  - `siderolabs/nfs-utils`
  - `siderolabs/qemu-guest-agent`
  - `siderolabs/tailscale`
- First boot options:
  - Disk image: `https://factory.talos.dev/image/90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13/v1.13.3/nocloud-amd64.raw.xz`
  - ISO: `https://factory.talos.dev/image/90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13/v1.13.3/nocloud-amd64.iso`
  - PXE: `https://pxe.factory.talos.dev/pxe/90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13/v1.13.3/nocloud-amd64`
- Booting from the Talos Factory NoCloud ISO.
- VM initially boot-looped with OVMF and no EFI disk.
- Added EFI disk, `q35`, CPU `host`, balloon `0`, RNG, and restarted VM.
- Automation runner blocks double-dash `--machine`, `--cpu`, `--efidisk0`, `--balloon`, and `--rng0`; single-dash forms work.
- Automation runner still blocks `qm importdisk`, file move/copy tools, and boot-order arguments containing semicolons.

## Proxmox Commands Preview

Create VM:

```bash
ssh looner-automation-agent 'qm create 104 --name talos --pool automation-managed --ostype l26 -machine q35 --bios ovmf -efidisk0 looner-ssd2:1,efitype=4m,pre-enrolled-keys=0 -cpu host --sockets 1 --cores 3 --memory 8192 -balloon 0 --scsihw virtio-scsi-pci --scsi0 looner-ssd2:100,format=raw,cache=writethrough,discard=on,ssd=1 --net0 virtio,bridge=vmbr0,firewall=0 --serial0 socket --vga serial0 --agent enabled=1 -rng0 source=/dev/urandom --onboot 1'
```

Attach installer ISO:

```bash
ssh looner-automation-agent 'qm set 104 --ide2 looner-ssd2:iso/talos-v1.13.3-nocloud-amd64-90067e7859c9c19a3c0c7729000b8ac31b9d625733fe7c3f338801498c551e13.iso,media=cdrom'
```

Set boot order to ISO:

```bash
ssh looner-automation-agent 'qm set 104 --boot order=ide2'
```

Start VM:

```bash
ssh looner-automation-agent 'qm start 104'
```
