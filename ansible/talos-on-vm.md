# Talos on Unraid VM — Continue with Ansible (Codex CLI Workflow)

This document describes how to continue **day-2 operations** for a Talos Linux
Kubernetes cluster running in an **Unraid VM**, using **Ansible** and working
iteratively from **Codex CLI**.

The focus is on:
- keeping state in Git
- running everything from your workstation
- avoiding SSH or node access
- staying aligned with Talos best practices

---

## Goal

Automate common post-install tasks for a **single-node Talos cluster**:

- manage Talos + Kubernetes access declaratively
- fetch kubeconfig
- install NFS CSI (Unraid as storage backend)
- create StorageClass
- test persistent storage
- provide a clean structure for future expansion

---

## Assumptions

- Talos node is already installed and `kubectl get nodes` shows `Ready`
- You run Ansible from the same machine that has:
  - `talosctl`
  - `kubectl`
  - `ansible`
- Talos node IP: `192.168.88.26`
- Unraid exports NFS at `/mnt/user/k8s-nfs`
- Kubernetes access is local (no bastion, no SSH)

---

## Repository Layout

Recommended structure:

