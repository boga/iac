# Proxmox Automation Agent Setup

## What This Replaces

This setup replaces Terraform-driven Proxmox changes with:

- Markdown VM specs under `proxmox/vms/`, one file per VM.
- A dedicated Proxmox VE user named `automation-agent@pve`.
- A dedicated Linux SSH user named `automation-agent`.
- A forced SSH command boundary at `/usr/local/bin/automation-pve-runner.sh`.
- Passwordless sudo only for approved Proxmox VE binaries.

## Files In This Repository

| Path | Purpose |
|---|---|
| `proxmox/automation-pve-runner.sh` | Forced-command SSH wrapper installed on each Proxmox node. |
| `proxmox/README.md` | Current setup notes. |

## Proxmox User Model

Created a Proxmox VE identity for automation:

```bash
pveum user add automation-agent@pve --comment "Automation agent"
```

Created a managed resource pool:

```bash
pvesh create /pools --poolid automation-managed --comment "VMs managed by automation agent"
```

Created a restricted VM management role.

`VM.Monitor` was rejected by Proxmox VE as invalid, so the role uses `VM.Audit` for read access:

```bash
pveum role add AutomationVmManager \
  -privs "VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Migrate VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit SDN.Use"
```

Assigned the role only to the managed pool:

```bash
pveum aclmod /pool/automation-managed -user automation-agent@pve -role AutomationVmManager
```

## Linux SSH User

`pveum user` does not create a Linux home directory. A separate Linux user is required for SSH transport.

Created Linux user:

```bash
useradd --create-home --shell /bin/bash automation-agent
passwd -l automation-agent
```

SSH key lives at:

```text
/home/automation-agent/.ssh/authorized_keys
```

Directory and file permissions:

```bash
install -d -o automation-agent -g automation-agent -m 0700 /home/automation-agent/.ssh
chown automation-agent:automation-agent /home/automation-agent/.ssh/authorized_keys
chmod 0600 /home/automation-agent/.ssh/authorized_keys
```

## SSH Command Boundary

The SSH key is forced to run the automation wrapper.

Current `authorized_keys` line:

```text
command="/usr/local/bin/automation-pve-runner.sh",no-agent-forwarding,no-X11-forwarding,no-port-forwarding,no-pty ssh-ed25519 <public-key> automation-agent
```

Boundary effects:

- `command="..."` forces every SSH request through the wrapper.
- `no-pty` blocks interactive terminal allocation.
- `no-port-forwarding` blocks SSH tunnels.
- `no-agent-forwarding` blocks SSH agent forwarding.
- `no-X11-forwarding` blocks X11 forwarding.

## Runner Installation

The wrapper from this repository was installed on the Proxmox node as:

```text
/usr/local/bin/automation-pve-runner.sh
```

Install command:

```bash
install -o root -g root -m 0755 ./proxmox/automation-pve-runner.sh /usr/local/bin/automation-pve-runner.sh
```

The wrapper:

- Reads `SSH_ORIGINAL_COMMAND`.
- Rejects empty commands.
- Rejects shell metacharacters.
- Rejects path traversal.
- Allows only approved `pvesh get` paths.
- Allows selected Proxmox commands only.
- Blocks shells and common non-PVE utilities.
- Logs accepted and rejected commands.
- Runs approved PVE binaries through `sudo -n`.
- Requires `qm create` and `qm clone` to include `--pool automation-managed`.
- Requires mutating `qm` and `pct` commands for existing guests to target resources in `automation-managed`.

Allowed command families:

- `qm`
- `pct`
- `pvesh get` for allowlisted read-only paths
- `pvecm status`
- `ha-manager status`
- `ha-manager config`

Explicitly blocked examples:

- `bash`
- `sh`
- `sudo`
- `cat`
- `rm`
- `dd`
- `qm destroy`
- `pct exec`
- `pvesh create`
- `pvesh set`
- `pvesh delete`

## Runner Log

Create a log file for the runner:

```bash
touch /var/log/automation-pve-runner.log
chown automation-agent:automation-agent /var/log/automation-pve-runner.log
chmod 0600 /var/log/automation-pve-runner.log
```

Security note: this lets `automation-agent` modify its own log. For tamper-resistant logs, use syslog or a root-owned logging path.

## Sudo Boundary

Proxmox CLI tools need root/PVE daemon access for local IPC and ACL loading. The runner validates the command first, then runs approved binaries through `sudo -n`.

Install `sudo` if needed:

```bash
apt update
apt install sudo
```

Create sudoers file:

```bash
cat > /etc/sudoers.d/automation-agent <<'EOF'
automation-agent ALL=(root) NOPASSWD: /usr/sbin/qm, /usr/sbin/pct, /usr/bin/pvesh, /usr/bin/pvecm, /usr/sbin/ha-manager
EOF
```

Validate sudoers:

```bash
chmod 0440 /etc/sudoers.d/automation-agent
visudo -cf /etc/sudoers.d/automation-agent
```

TODO:

- [ ] Keep sudoers limited to absolute PVE binary paths.
- [ ] Do not grant broad shell, editor, file, or package-manager commands.
- [ ] Revalidate sudoers after changing the runner allowlist.

## Current Security Shape

```text
SSH key
  -> forced command /usr/local/bin/automation-pve-runner.sh
  -> wrapper validates requested command
  -> wrapper rejects shells, metacharacters, unsafe paths, and blocked subcommands
  -> wrapper enforces automation-managed pool checks for mutating guest commands
  -> sudo permits only approved Proxmox VE binaries
  -> Proxmox command executes as root
```

## Backup Notes

For NFS-backed backups of unprivileged LXC containers, configure `vzdump` to use a local temporary directory instead of staging temporary backup data on the NFS mount.

Set `/etc/vzdump.conf` on the Proxmox node:

```text
tmpdir: /mnt/sdb1/tmp
```

Ensure `/mnt/sdb1/tmp` exists and has enough free local space for the temporary backup archive.

## Next Steps

- [ ] Add `proxmox/vms/example.md`.
- [ ] Define Markdown VM schema.
- [ ] Add dry-run planner for VM specs.
- [ ] Use `ssh looner-automation-agent '<command>'` as the Proxmox execution transport.
- [ ] Require explicit confirmation before destructive actions.
- [ ] Keep destructive operations such as `qm destroy` blocked until a separate approval flow exists.
