### To add Tailscale to Talos node:
1) add Talos extension to `talos_extensions`:
   ```terraform
    talos_extensions = [
       ...
       "siderolabs/tailscale",
       ...
   ]
   ```
2) add an environment variable with authentication key:
   ```terraform
    environment_variables = [
    ...
    "TS_AUTHKEY=tskey-auth-...",
    "TS_HOSTNAME=talos-cp",
    ... 
    ]

   ```
