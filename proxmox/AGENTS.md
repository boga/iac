# Proxmox VM Management Instructions

## Mandatory Rules

- Manage Proxmox only through `ssh looner-automation-agent '<command>'`.
- **MUST NOT** SSH as `root` for routine VM management.
- **MUST NOT** run raw shell commands through the automation user.
- **MUST NOT** use pipes, redirects, command substitution, or shell metacharacters.
- **MUST NOT** destroy, delete, or unlink VM resources unless the user explicitly confirms the exact VMID and action.
- **MUST** inspect current state before changing a VM.
- **MUST** show intended commands before applying changes.
- **MUST** keep VM source-of-truth files under `proxmox/vms/`.
- **MUST** use one Markdown file per VM.
- **MUST** assume there is one Proxmox node unless the user says the cluster changed.

## Transport

Use this SSH target for Proxmox operations:

```bash
ssh looner-automation-agent '<pve-command>'
```

Examples:

```bash
ssh looner-automation-agent 'qm list'
ssh looner-automation-agent 'qm config 501'
ssh looner-automation-agent 'pvesh get /nodes'
ssh looner-automation-agent 'pvecm status'
```

The SSH key is forced through `/usr/local/bin/automation-pve-runner.sh` on the Proxmox host. The runner allowlists selected Proxmox VE commands and blocks interactive shells.

## Allowed Command Families

Use only commands accepted by the runner:

- `qm list`
- `qm status <vmid>`
- `qm config <vmid>`
- `qm pending <vmid>`
- `qm create <vmid> ...`
- `qm clone <template-vmid> <new-vmid> ...`
- `qm set <vmid> ...`
- `qm resize <vmid> ...`
- `qm start <vmid>`
- `qm stop <vmid>`
- `qm shutdown <vmid>`
- `qm reboot <vmid>`
- `qm reset <vmid>`
- `qm migrate <vmid> <target-node> ...` only when more than one node exists
- `qm template <vmid>`
- `pct list`
- `pct status <ctid>`
- `pct config <ctid>`
- `pct pending <ctid>`
- `pvesh get <path>`
- `pvesh get /nodes`
- `pvesh get /nodes/<node>/storage`
- `pvesh get /pools`
- `pvesh get /pools/automation-managed`
- `pvesh get /cluster/resources`
- `pvecm status`
- `ha-manager status`
- `ha-manager config`

## Blocked Actions

The runner blocks these by design:

- interactive shells: `bash`, `sh`, `zsh`, `sudo`, `su`
- file tools: `cat`, `rm`, `mv`, `cp`, `dd`
- shell-capable LXC commands: `pct exec`, `pct enter`, `pct push`, `pct pull`
- destructive VM commands: `qm destroy`, `qm unlink`
- mutating API commands: `pvesh create`, `pvesh set`, `pvesh delete`
- non-allowlisted paths and path traversal in requested commands
- pipes, redirects, semicolons, quotes, command substitution, and other shell metacharacters

## VM Specs

Store VM specs under `proxmox/vms/`.

Rules:

- Use one Markdown file per VM.
- Name files after the VM when practical, such as `proxmox/vms/home-assistant.md`.
- Keep desired CPU, memory, disks, network, boot, and notes in the VM file.
- Do not combine multiple VM specs in one file.
- Do not store secrets in VM specs.

## Cluster Assumptions

There is currently one Proxmox node.

Rules:

- Do not plan migrations unless the user says another node exists.
- Treat `--target <node>` as optional for clone/create flows unless Proxmox requires it.
- Query `pvesh get /nodes` when the node name is needed.
- Include `--pool automation-managed` when creating or cloning VMs.
- Expect mutating commands for existing guests to fail unless the VM is in `automation-managed`.

## VM Change Workflow

1. Read the relevant VM spec under `proxmox/vms/`.
2. Query current Proxmox state:

   ```bash
   ssh looner-automation-agent 'qm list'
   ssh looner-automation-agent 'qm config <vmid>'
   ssh looner-automation-agent 'qm pending <vmid>'
   ```

3. Compare desired state with current state.
4. Prepare the exact Proxmox commands.
5. Show the commands to the user.
6. Ask for confirmation if the change is destructive, disruptive, or ambiguous.
7. Apply commands through `ssh looner-automation-agent`.
8. Query state again to verify the result.
9. Update the matching Markdown spec under `proxmox/vms/` if needed.

## Create VM Checklist

Before creating a VM:

- [ ] Confirm the VMID is unused with `qm list`.
- [ ] Confirm the single Proxmox node name with `pvesh get /nodes` if the command needs it.
- [ ] Confirm the template exists with `qm list` or `qm config <template-vmid>`.
- [ ] Confirm target storage exists with `pvesh get /nodes/<node>/storage`.
- [ ] Confirm bridge and VLAN requirements are known.
- [ ] Confirm CPU, memory, disk, and network settings.
- [ ] Show the create or clone command before running it.

Typical clone flow:

```bash
ssh looner-automation-agent 'qm clone <template-vmid> <new-vmid> --name <name> --full 1 --pool automation-managed'
ssh looner-automation-agent 'qm set <new-vmid> --cores <cores> --memory <memory-mb>'
ssh looner-automation-agent 'qm set <new-vmid> --net0 virtio,bridge=<bridge>'
ssh looner-automation-agent 'qm resize <new-vmid> scsi0 <size>'
ssh looner-automation-agent 'qm start <new-vmid>'
```

## Update VM Checklist

Before updating a VM:

- [ ] Query current config with `qm config <vmid>`.
- [ ] Query pending changes with `qm pending <vmid>`.
- [ ] Confirm whether the change requires shutdown or reboot.
- [ ] Show the exact `qm set`, `qm resize`, or lifecycle command.
- [ ] Verify after apply with `qm config <vmid>` or `qm status <vmid>`.

## Destructive Changes

Destructive changes require explicit user confirmation with VMID and action.

Examples that require confirmation:

- stopping a running VM with `qm stop`
- resetting a VM with `qm reset`
- resizing disks downward if ever supported
- replacing network devices
- removing disks or cloud-init media
- any future use of `qm destroy`, `qm unlink`, or `pvesh delete`

If the runner blocks the command, do not bypass it. Explain the block and ask whether the runner policy should change.

## Verification Commands

Use these commands after changes:

```bash
ssh looner-automation-agent 'qm status <vmid>'
ssh looner-automation-agent 'qm config <vmid>'
ssh looner-automation-agent 'qm pending <vmid>'
ssh looner-automation-agent 'qm list'
```
