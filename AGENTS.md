# Repository Guidelines

## Project Structure
- `talos/` contains Talos configuration inputs and patches (e.g., `talos/patch.yml`); generated configs like `talosconfig` and `kubeconfig` are ignored.
- `terraform/` is reserved for infrastructure-as-code (not all modules may be present yet).
- `tmp/` is scratch space; do not rely on it for source of truth.

## Commit & Pull Request Guidelines
- Commit messages in history are short, sentence-style (“Added …”, “Refactored …”). Follow that pattern and keep them descriptive.
- PRs should include: a concise summary, the commands used (if any), and notes about impacted hosts or clusters. Attach screenshots only when UI changes are involved.

## Security & Configuration Tips
- Treat Talos machine configs and `talosconfig` as sensitive; do not commit them unless intentionally sanitized.
