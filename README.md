# Infrastructure

## Terraform

Terraform uses an S3-compatible backend for remote state and 1Password for local secret injection. Stack files live in `terraform/src`; `terraform/mise.toml` wraps commands with `terraform -chdir=src`.

Setup:

```sh
cd terraform
mise install
mise run tf:init
mise run tf:plan
```

Create the object storage bucket before first backend initialization. See [`terraform/README.md`](terraform/README.md).

## Ansible

### Bootstrapping a server
Create temporary inventory file with hardcoded host options, i.e. 
```yaml
# ./inventory-bootstrap.yml
all:
  hosts:
    looner-proxmox:
      ansible_host: 192.168.212.8506
      ansible_user: root
```
Host name should match the host name in the main inventory file  
Run there commands to bootstrap the server:
```shell
# Install Ansible roles and collections
ansible-galaxy collection install --requirements-file ./requirements.txt
ansible-galaxy role install --role-file ./requirements.yml
# Perform initial installation: Tailscale, Docker, NFS, Samba, etc.
ansible-playbook --ask-pass --user=root --inventory=./inventory-bootstrap.yml ./looner-proxmox.yml
# Add Ansible user
ansible all --inventory 192.168.88.218, --become --user root --ask-pass --module-name user --args "name=ans groups=sudo append=yes state=present"
# Add sudo group to enable Ansible user to become with no password
ansible all --inventory 192.168.88.218, --become --user root --ask-pass --module-name copy --args "dest=/etc/sudoers.d/sudo_group content='%sudo ALL=(ALL) NOPASSWD: ALL' validate='visudo -cf %s'"
```
Remove temporary inventory file
