## Ansible
### Initial setup
Sample inventory.yml:
```yaml
all:
  hosts:
    looner:
      ansible_host: 192.168.1.94
      ansible_ssh_private_key_file: ./id_ed25519-looner
```
To create Ansible user run this command:
```shell
 export bcmpss=${sudo user password}
ansible-playbook -u ${sudo user} --extra-vars="ansible_become_pass=$bcmpss" 01-setup-ansible-user.yml
```