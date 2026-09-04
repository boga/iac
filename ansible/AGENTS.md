# Ansible Directory Guidelines

## Safety

- **MUST NOT** run `ansible`, `ansible-playbook`, or any command that applies Ansible changes.
- `ansible-lint` is available and may be used for static inspection.
- **MUST NOT** access or print secret values from `vault.enc`, `vault.yml`, or `vault.yaml`.
- Treat `vault-password.sh`, `vault.enc`, and any `vault.yml` or `vault.yaml` under `group_vars/` or `host_vars/` as sensitive.
- Do not assume other files under `group_vars/` or `host_vars/` contain secrets.
- Use static inspection only unless the user explicitly authorizes another action.

## Scope

- Follow repository-wide instructions in [`../AGENTS.md`](../AGENTS.md).
- The Kubernetes cluster is a single Talos VM on Proxmox.
- Keep YAML formatted with 2-space indentation.
- Prefer Ansible feature modules over `ansible.builtin.command` when proposing changes.
- Keep roles under `roles/` and feature playbooks under `playbooks/`.

## Validation

- `ansible-lint` may be used to validate Ansible files.
- Do not run `ansible` or `ansible-playbook` validation commands.
- Review changed YAML statically and report validation limitations.
