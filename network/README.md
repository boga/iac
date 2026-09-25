# Home Network Documentation

_Last updated: 2026-09-25_

This documentation describes the currently known home network topology, addressing, VLANs, network nodes, switching layout, MikroTik configuration, firewall policy, Wi-Fi/CAPsMAN design, and Proxmox connectivity.

The network is installed in a three-floor house in the Netherlands. Internet is provided by Odido at approximately **400 Mbps**.

## Design Goals

- Provide reliable wired and wireless connectivity across all floors.
- Keep routing and firewalling simple and maintainable.
- Isolate IoT devices without unnecessary complexity.
- Use wired backhaul where available.
- Restrict router management access.
- Preserve Home Assistant and Thread functionality.

## Documents

Load only the document needed for the current task.

| Document | Contents |
|---|---|
| [Topology](topology.md) | Physical links and current logical topology |
| [Addressing and WAN](addressing-and-wan.md) | Trusted LAN, IoT VLAN, DHCP assignments, and Odido WAN configuration |
| [MikroTik and Wi-Fi](mikrotik-and-wifi.md) | hAP ac3, wAP ac, CAPsMAN, SSIDs, and bridge VLAN configuration |
| [Switching](switching.md) | NETGEAR GS108PEv2 and GS105Ev2 configuration |
| [Proxmox](proxmox.md) | Host connectivity, guests, Talos, and Home Assistant observations |
| [Firewall and Management](firewall-and-management.md) | Router firewall policy, management hardening, IPv6, and Thread |
| [Verification and Follow-Ups](verification-and-follow-ups.md) | Tested security properties, planned work, and documentation gaps |
