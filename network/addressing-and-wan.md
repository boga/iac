# Addressing and WAN

[Home network index](README.md)

## IP Networks and VLANs

### VLAN 1 / Trusted LAN

```text
Subnet:        192.168.88.0/24
Gateway:       192.168.88.1
Router:        MikroTik hAP ac3
```

| Device | Address | Notes |
|---|---:|---|
| MikroTik hAP ac3 | `192.168.88.1` | Main router |
| NETGEAR GS108PEv2 | `192.168.88.21` | Managed switch |
| Talos VM | `192.168.88.26` | VM on Proxmox |
| Home Assistant | `192.168.88.31` | VM on Proxmox |
| MikroTik wAP ac | `192.168.88.51` | Wireless AP |
| Unraid | `192.168.88.96` | NAS/server via GS105Ev2 |
| Proxmox VE | `192.168.88.115` | Hypervisor |
| Apple TV 4K | `192.168.88.159` | Thread border / edge router |

### VLAN 20 / IoT

```text
VLAN ID:       20
Subnet:        192.168.20.0/24
Gateway:       192.168.20.1
DHCP pool:     192.168.20.100-199
DHCP server:   dhcp-iot
DNS:           192.168.20.1
NTP:           192.168.20.1
```

Known static DHCP assignments:

| Device | Address | MAC |
|---|---:|---|
| Test phone | `192.168.20.100` | `4C:63:71:D5:A3:F8` |
| Existing IoT device | `192.168.20.101` | static lease currently in use |
| Vacuum | `192.168.20.102` | `B0:4A:39:15:1B:B5` |

The hAP VLAN interface is `vlan20-iot` with `192.168.20.1/24`.

## Odido WAN Configuration

Physical WAN interface:

```text
ether1
```

Configured VLAN interfaces:

```text
vlan-internet  VLAN ID 300  parent ether1
vlan-iptv      VLAN ID 640  parent ether1
```

The Internet DHCP client/default route is on `vlan-internet`.

The RouterOS `WAN` interface list contains:

```text
ether1
vlan-internet
```

Current NAT:

```routeros
chain=srcnat
action=masquerade
out-interface-list=WAN
ipsec-policy=out,none
```

There is currently one masquerade rule and no destination-NAT rules.
