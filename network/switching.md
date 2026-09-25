# Switching

[Home network index](README.md)

## NETGEAR GS108PEv2

Management IP:

```text
192.168.88.21
```

Advanced 802.1Q VLAN configuration:

### VLAN 1

```text
Ports 1-8: untagged
PVID 1 on ports 1-8
```

### VLAN 20

```text
Port 1: tagged   # uplink to hAP ether4
Port 2: tagged   # uplink to wAP
Ports 3-8: excluded
```

Thus VLAN 20 exists only across the hAP <-> GS108 <-> wAP path.

A VLAN-injection test from Proxmox confirmed that a VLAN 20 tagged frame sent from behind the GS105/GS108-port-3 path does not receive DHCP from the IoT VLAN.

## NETGEAR GS105Ev2

The GS105Ev2 sits downstream of GS108 port 3 and provides trusted-LAN connectivity to both Proxmox and Unraid.

Current behavior:

```text
Trusted LAN / VLAN 1 only
No VLAN 20 path toward the router
```

Known downstream nodes:

```text
Unraid       192.168.88.96
Proxmox VE   192.168.88.115
```

The exact current GS105Ev2 management IP, firmware, and configuration are not documented.

Because GS108 port 3 excludes VLAN 20, devices behind the GS105 cannot currently join VLAN 20 merely by transmitting tagged VLAN 20 frames.
