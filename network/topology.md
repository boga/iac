# Home Network Topology

[Home network index](README.md)

## Physical Topology

```text
                                  INTERNET
                                     |
                              Odido ~400 Mbps
                                     |
                                  ether1
                                     |
                         +-----------------------+
                         | MikroTik hAP ac3      |
                         | Main router / CAPsMAN |
                         | 192.168.88.1          |
                         +-----------------------+
                                  |
                               ether4
                                  |
                           Ethernet trunk
                                  |
                         +-----------------------+
                         | NETGEAR GS108PEv2     |
                         | 192.168.88.21         |
                         +-----------------------+
                          |         |         |
                       port 2    port 3     other ports
                          |         |         |
                          |         |         +--> Trusted LAN / VLAN 1
                          |         |
                          |         +----------------------+
                          |                                |
                          |                         +---------------+
                          |                         | GS105Ev2      |
                          |                         +---------------+
                          |                                |
                          |                         +---------------+
                          |                         | Proxmox VE    |
                          |                         | 192.168.88.115|
                          |                         +---------------+
                          |
                  +-------------------+
                  | MikroTik wAP ac   |
                  | 192.168.88.51     |
                  +-------------------+
```

Known physical links:

- Odido uplink -> hAP ac3 `ether1`
- hAP ac3 `ether4` -> GS108PEv2 port 1
- GS108PEv2 port 2 -> MikroTik wAP ac `ether1`
- GS108PEv2 port 3 -> GS105Ev2
- GS105Ev2 -> Proxmox host
- GS105Ev2 -> Unraid server (`192.168.88.96`)

## Current Logical Topology

```text
                            INTERNET
                               |
                        Odido VLAN 300
                               |
                     vlan-internet on hAP
                               |
                    +--------------------+
                    | MikroTik hAP ac3   |
                    | 192.168.88.1       |
                    |                    |
                    | VLAN 1 / Trusted   |
                    | VLAN 20 / IoT      |
                    +--------------------+
                               |
                       ether4 trunk
                    VLAN 1 untagged
                    VLAN 20 tagged
                               |
                    +--------------------+
                    | GS108PEv2          |
                    | 192.168.88.21      |
                    +--------------------+
                      |               |
                 port 2 trunk      port 3 access-like
                      |               |
               VLAN1 + VLAN20       VLAN1 only
                      |               |
               +-------------+    +----------+
               | wAP ac      |    | GS105Ev2 |
               | .88.51      |    +----------+
               +-------------+          |
                    |                   |
              Trusted SSID(s)        Proxmox
              IoT SSID VLAN20       192.168.88.115
                                         |
                                 +-------+-------+
                                 |               |
                           Home Assistant      Talos
                           192.168.88.31       192.168.88.26
```
