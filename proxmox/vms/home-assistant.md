# Home Assistant VM

## Identity

- VMID: `103`
- Name: `home-assistant`
- Status: `stopped`
- Description: `Managed by Terraform`
- Tags: `terraform`

## Compute

- CPU type: `x86-64-v2-AES`
- Sockets: `1`
- Cores: `2`
- Memory: `2048` MB
- Balloon memory: `2048` MB
- NUMA: `0`

## Boot and Firmware

- BIOS: `ovmf`
- Machine: `q35`
- Boot order: `scsi0;net0`
- OS type: `l26`
- EFI disk: `looner-ssd2:103/vm-103-disk-0.raw,efitype=4m,pre-enrolled-keys=0,size=528K`

## Disks

- Controller: `virtio-scsi-pci`
- `scsi0`: `looner-ssd2:103/vm-103-disk-1.raw,aio=io_uring,backup=1,cache=none,discard=ignore,iothread=0,replicate=1,size=32GB,ssd=1`

## Network

- `net0`: `virtio=BC:24:11:2D:D7:32,bridge=vmbr0,firewall=0`

## Devices and Guest Settings

- ACPI: `1`
- QEMU guest agent: `enabled=0,fstrim_cloned_disks=0,type=virtio`
- Keyboard: `en-us`
- On boot: `1`
- Protection: `0`
- Serial console: `socket`
- Tablet: `1`
- Template: `0`

## Metadata

- Creation metadata: `creation-qemu=10.1.2,ctime=1780436706`
- SMBIOS UUID: `02bac867-e21f-4682-94e9-4156509dba63`
- VM generation ID: `df9efb17-1ed9-45e1-9927-aeca997c34fd`

## Pending Changes

No pending changes reported by `qm pending 103`.

## Source

Fetched with:

```bash
ssh looner-automation-agent 'qm list'
ssh looner-automation-agent 'qm status 103'
ssh looner-automation-agent 'qm config 103'
ssh looner-automation-agent 'qm pending 103'
```
