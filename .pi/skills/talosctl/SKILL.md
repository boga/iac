---
name: talosctl
description: Manage Talos Kubernetes clusters with the `talosctl` CLI. Use for cluster health, node status, logs, diagnostics, machine configuration validation, upgrades, and controlled lifecycle operations.
---

# Talos Cluster Management

## Credentials and Secrets

- **MUST NOT** read, print, copy, modify, or commit `talosconfig`, kubeconfig files, certificates, private keys, tokens, or secret values.
- **MUST NOT** run commands that expose credential contents, including `talosctl config info`, `talosctl config endpoints`, `talosctl config nodes`, `env`, `printenv`, or shell expansion of `$TALOSCONFIG`.
- Assume `$TALOSCONFIG` exists and is valid. Run `talosctl` without a `--talosconfig` argument unless the user explicitly provides a safe alternate path.
- Treat Talos machine configuration as sensitive. Do not display generated configuration or decrypted values.

## Safe Read Operations

Start with narrowly scoped, read-only checks:

```bash
talosctl version --nodes <node-ip-or-hostname>
talosctl health --nodes <control-plane-node>
talosctl service --nodes <node-ip-or-hostname>
talosctl get members --nodes <control-plane-node>
talosctl get machinestatus --nodes <node-ip-or-hostname>
talosctl logs <service> --nodes <node-ip-or-hostname>
```

- Use `--nodes <node-ip-or-hostname>` to target an explicit node.
- Use `--endpoints <control-plane-endpoint>` when the API endpoint must be explicit.
- Request a bounded log window with `--tail <count>` when supported.
- Run `talosctl <command> --help` before an unfamiliar command or flag.

## Configuration Changes

Before applying a configuration change:

1. Validate the local configuration without printing sensitive content.
2. Identify exact target nodes and impact.
3. Show the command and explain expected disruption.
4. Obtain explicit user confirmation for any mutation.
5. Apply to one node at a time unless the user explicitly requests a rollout.
6. Verify node and cluster health after the change.

```bash
talosctl validate --config <machine-config.yaml>
talosctl apply-config --nodes <node-ip-or-hostname> --file <machine-config.yaml>
talosctl health --nodes <control-plane-node>
```

## Destructive and Disruptive Operations

**STOP and obtain explicit confirmation immediately before** `apply-config`, `patch`, `bootstrap`, `reboot`, `restart`, `shutdown`, `reset`, `upgrade`, `upgrade-k8s`, `rollback`, `rotate-ca`, `wipe`, `meta`, or any command that changes cluster or node state.

- State affected nodes, workload impact, rollback path, and whether quorum remains available.
- Never reset, wipe, bootstrap, rotate CAs, or upgrade multiple control-plane nodes concurrently.
- Preserve etcd quorum: operate on one control-plane node at a time and confirm health between nodes.

## Diagnostics

For investigation, prefer targeted commands and redact sensitive output before reporting it:

```bash
talosctl health --nodes <control-plane-node>
talosctl service --nodes <node-ip-or-hostname>
talosctl dmesg --nodes <node-ip-or-hostname>
talosctl logs <service> --nodes <node-ip-or-hostname> --tail 200
talosctl get etcdmembers --nodes <control-plane-node>
```

Do not run `talosctl support` unless the user explicitly requests a support bundle. It can collect sensitive cluster diagnostics.

## Verification

After a non-destructive check or an approved change:

- Confirm targeted node status with `talosctl service` or `talosctl get machinestatus`.
- Confirm control-plane health with `talosctl health`.
- Report only operational results; never include credentials, keys, certificates, or configuration contents.
