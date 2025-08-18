The role needs Tailscale [auth key](https://login.tailscale.com/admin/settings/keys)  
It can be used like this:
```bash
 export ts_authkey="tskey-auth-XXXXX"
ansible-playbook -e ts_authkey=$ts_authkey ./nas.yml
```