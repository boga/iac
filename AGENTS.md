# Repository Guidelines

## Project Structure & Module Organization
- `ansible/` holds automation: inventories (`ansible/inventory.yml`), playbooks (`ansible/*.yml` and `ansible/playbooks/*/main.yml`), and roles (`ansible/roles/*` with `tasks/`, `defaults/`, `vars/`, `templates/`).
- `talos/` contains Talos configuration inputs and patches (e.g., `talos/patch.yml`); generated configs like `talosconfig` and `kubeconfig` are ignored.
- `terraform/` is reserved for infrastructure-as-code (not all modules may be present yet).
- `tmp/` is scratch space; do not rely on it for source of truth.

## Build, Test, and Development Commands
- Install Ansible dependencies:
  - `ansible-galaxy collection install -r ansible/requirements.yml`
  - `ansible-galaxy role install -r ansible/requirements.yml`
- Run a playbook locally:
  - `ansible-playbook -i ansible/inventory.yml ansible/nastromo.yml`
  - Per-feature playbooks live under `ansible/playbooks/<name>/main.yml`.
- Bootstrap guide (Talos on Unraid) lives in `ansible/readme.md`.

## Coding Style & Naming Conventions
- YAML uses 2-space indentation; keep keys ordered logically and avoid deep nesting.
- Prefer Ansible feature modules (e.g., `kubernetes.core.k8s`) over `ansible.builtin.command`; only use `command` when a module is impossible or unreasonably cumbersome.
- Use lowercase, hyphenated role/playbook names (e.g., `k8s-longhorn`, `ingress-nginx`).
- Secrets live in `ansible/group_vars/*/vault.yml`, `ansible/host_vars/*/vault.yml`, and `ansible/vault.enc`; edit with `ansible-vault`.

## Testing Guidelines
- No automated test suite is defined. Validate by running the relevant playbook in a staging or lab environment and checking resources (e.g., `kubectl -n kube-system get pods`).

## Commit & Pull Request Guidelines
- Commit messages in history are short, sentence-style (“Added …”, “Refactored …”). Follow that pattern and keep them descriptive.
- PRs should include: a concise summary, the commands used (if any), and notes about impacted hosts or clusters. Attach screenshots only when UI changes are involved.

## Security & Configuration Tips
- Treat Talos machine configs and `talosconfig` as sensitive; do not commit them unless intentionally sanitized.
- Avoid putting credentials in plain YAML; use vault files and reference variables from `group_vars`/`host_vars`.
