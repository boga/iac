# Talos VM

## Identity

- VMID: `104`
- Name: `talos`
- Node: `proxmox`
- Pool: `automation-managed`
- Status: `planned`
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
- Boot order: `scsi0;ide2;net0`
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
- `scsi0`: `looner-ssd2`, `100G`, `raw`, `cache=none`, `discard=on`, `ssd=1`, `backup=1`
- Installer ISO: `ide2`, `looner-ssd2:iso/talos-nocloud-amd64-v1.13.3.iso`, `media=cdrom`

**Do not** use `virtio-scsi-single`; Talos docs warn it can hang bootstrap or break disk discovery.

## Network

- `net0`: `virtio`, `bridge=vmbr0`, `firewall=0`
- VLAN: none planned

## Devices and Guest Settings

- QEMU guest agent: `enabled=1`
- RNG: `source=/dev/urandom`
- Tablet: `0`

## Notes

- VMID `104` appears unused based on `qm list`.
- Sidero recommends OVMF, `q35`, CPU `host`, VirtIO network, and VirtIO SCSI.
- Talos does not support memory hotplug, so ballooning is disabled.
- Use Talos Factory schematic `f0bb6548d7e619433500f8e76a972241c81aac8d74d08e7bfdf6c1351a461105` for first boot.
- Factory customization includes these official extensions:
  - `siderolabs/qemu-guest-agent`
  - `siderolabs/iscsi-tools`
  - `siderolabs/util-linux-tools`
  - `siderolabs/nfs-utils`
  - `siderolabs/tailscale`
- First boot options:
  - Disk image: `https://factory.talos.dev/image/f0bb6548d7e619433500f8e76a972241c81aac8d74d08e7bfdf6c1351a461105/v1.13.3/nocloud-amd64.raw.xz`
  - ISO: `https://factory.talos.dev/image/f0bb6548d7e619433500f8e76a972241c81aac8d74d08e7bfdf6c1351a461105/v1.13.3/nocloud-amd64.iso`
  - PXE: `https://pxe.factory.talos.dev/pxe/f0bb6548d7e619433500f8e76a972241c81aac8d74d08e7bfdf6c1351a461105/v1.13.3/nocloud-amd64`
- Attach the Talos Factory NoCloud ISO, boot installer, then apply Talos machine config with `talosctl`.

## Proxmox Commands Preview

Create VM:

```bash
ssh looner-automation-agent 'qm create 104 --name talos --pool automation-managed --ostype l26 --machine q35 --bios ovmf --efidisk0 looner-ssd2:1,efitype=4m,pre-enrolled-keys=0 --cpu host --sockets 1 --cores 3 --memory 8192 --balloon 0 --scsihw virtio-scsi-pci --scsi0 looner-ssd2:100,format=raw,cache=none,discard=on,ssd=1 --net0 virtio,bridge=vmbr0,firewall=0 --serial0 socket --vga serial0 --agent enabled=1 --rng0 source=/dev/urandom --onboot 1'
```

Attach installer ISO:

```bash
ssh looner-automation-agent 'qm set 104 --ide2 looner-ssd2:iso/talos-nocloud-amd64-v1.13.3.iso,media=cdrom'
```

Set boot order:

```bash
ssh looner-automation-agent 'qm set 104 --boot order=scsi0;ide2;net0'
```
