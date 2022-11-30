k8s-k3s
=========

The role installs k3s https://k3s.io/ and fetches kubeconfig to the local machine.

Role Variables
--------------

| Name                     | Description                                              | Default                                                                           |
|--------------------------|----------------------------------------------------------|-----------------------------------------------------------------------------------|
| k3s_tmp_dir              | directory to store temporary files: install script, etc. | /home/{{ ansible_user }}/k3s-tmp-dir                                              |
| k3s_install_script       | path to install script                                   | {{ k3s_tmp_dir }}/install-k3s.sh                                                  |
| k3s_systemd_service_file | path to systemd service unit file                        | /etc/systemd/system/k3s.service                                                   |
| k3s_kubeconfig_local     | path to save kubeconfig file to on local machine         | kubeconfig-{{ ansible_facts.hostname }}-{{ ansible_date_time.iso8601_basic }}.yml |
| k3s_kubeconfig           | path to kubeconfig on remote host                        | /etc/rancher/k3s/k3s.yaml                                                         |

Example Playbook
----------------
```yaml
---
- hosts: all
  gather_facts: true

  roles:
    - role: k8s-k3s
```
