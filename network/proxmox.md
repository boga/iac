# Proxmox

[Home network index](README.md)

## Proxmox VE

```text
Host IP:      192.168.88.115/24
Gateway:      192.168.88.1
Physical NIC: nic0
Bridge:       vmbr0
```

Current bridge path:

```text
nic0 -> vmbr0
```

Observed link state:

```text
Speed:         1000 Mb/s
Duplex:        Full
Link detected: yes
```

Physical path:

```text
Proxmox -> GS105Ev2 -> GS108PEv2 port 3 -> hAP
```

The Proxmox firewall is enabled.

An explicit host firewall rule now permits trusted-LAN ICMP to `192.168.88.115`.

Observed guests during troubleshooting:

| ID | Name | State at observation |
|---:|---|---|
| 100 | win10 | running |
| 101 | tailscale | running |
| 102 | test-debian | running |
| 103 | home-assistant | running |
| 105 | talos | stopped at the time of observation |

The Talos state above is only a point-in-time observation.

### Talos

```text
IP: 192.168.88.26
VMID: 105
```

The Talos VM is connected to the trusted LAN through Proxmox `vmbr0`.

### Home Assistant

```text
IP: 192.168.88.31
```

Observed during troubleshooting:

- Layer-2 connectivity is healthy.
- HA exchanges traffic with LAN devices and the Internet.
- TCP/443 responded.
- TCP/8123 returned TCP RST, meaning HA itself was not listening on 8123 at that moment.

This was not caused by the MikroTik or NETGEAR switching path.
