# Ansible Directory Guidelines

## Safety

- **MUST NOT** run `ansible`, `ansible-playbook`, or any command that applies Ansible changes.
- `ansible-lint` is available and may be used for static inspection.
- **MUST NOT** access or print secret values from `vault.enc`, `vault.yml`, or `vault.yaml`.
- Treat `vault-password.sh`, `vault.enc`, and any `vault.yml` or `vault.yaml` under `group_vars/` or `host_vars/` as sensitive.
- Do not assume other files under `group_vars/` or `host_vars/` contain secrets.
- Avoid putting credentials in plain YAML; use vault files and reference variables from `group_vars/` and `host_vars/`.
- Use static inspection only unless the user explicitly authorizes another action.

## Scope

- Follow repository-wide instructions in [`../AGENTS.md`](../AGENTS.md).
- The Kubernetes cluster is a single Talos VM on Proxmox.
- `inventory.yml` defines inventory; playbooks live in `*.yml` and `playbooks/*/main.yml`.
- Roles live under `roles/` with `tasks/`, `defaults/`, `vars/`, and `templates/`.
- The bootstrap guide lives in [`readme.md`](readme.md).

## Dependencies

- Install Ansible collections with `ansible-galaxy collection install -r requirements.yml`.
- Install Ansible roles with `ansible-galaxy role install -r requirements.yml`.

## Style

- Keep YAML formatted with 2-space indentation and keys ordered logically.
- Prefer Ansible feature modules such as `kubernetes.core.k8s` over `ansible.builtin.command`.
- Use `ansible.builtin.command` only when a module is impossible or unreasonably cumbersome.
- Use lowercase, hyphenated role and playbook names such as `k8s-longhorn` and `ingress-nginx`.

## Validation

- `ansible-list` and `ansible-lint` may be used for static inspection and validation.
- Do not run `ansible` or `ansible-playbook` commands.
- No automated test suite is defined; review changed YAML statically and report validation limitations.
