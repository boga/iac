# Verification and Follow-Ups

[Home network index](README.md)

## Verified Security Properties

The following have been explicitly tested:

- VLAN 20 is tagged only on the intended hAP <-> GS108 <-> wAP path.
- Devices behind GS108 port 3 / GS105 cannot successfully obtain IoT DHCP by injecting VLAN 20 tags.
- Trusted-LAN Layer-2 IPv6 multicast no longer leaks into the IoT WLAN after bridge VLAN filtering.
- Router management is reachable by SSH/WinBox from trusted LAN.
- Router HTTP/HTTPS management is currently disabled.
- `vlan-internet` is included in the RouterOS `WAN` interface list.
- Only one NAT masquerade rule remains.
- Duplicate default firewall rules were removed.
- Stale custom remote-WinBox forward rule was removed.
- IoT default routed forwarding is blocked except for explicit exceptions.
- Proxmox Ethernet path through GS105/GS108 operates at 1 Gbit/full duplex.

## Known Follow-Up Items

Possible future work:

- Enable WebFig over HTTPS with a proper trust model.
- Replace default/built-in MikroTik admin usage with a dedicated named admin account.
- Restrict router management from the entire trusted LAN to selected admin devices if desired.
- Audit and disable unused RouterOS connection-tracking helpers.
- Add CAPsMAN certificate authentication.
- Test IoT client-to-client isolation across different APs.
- Consider a management VLAN only if a concrete need emerges.
- Benchmark LAN forwarding performance after bridge VLAN filtering.
- Keep MikroTik and switch backups synchronized after major changes.

## Addressing and Naming Gaps

The following details are incomplete or intentionally not assumed:

- Exact IPs/roles for all Proxmox guests.
- GS105Ev2 management IP/firmware/configuration.
- Full DHCP reservation inventory.
- Full trusted Wi-Fi SSID/security configuration.
- Exact channel plan / channel widths / transmit power.
- Odido upload speed.
- Whether IPTV VLAN 640 is actively used.
- Final HTTPS certificate strategy for WebFig.
