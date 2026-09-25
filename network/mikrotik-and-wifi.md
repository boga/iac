# MikroTik and Wi-Fi

[Home network index](README.md)

## MikroTik hAP ac3

```text
Model:       RBD53iG-5HacD2HnD
RouterOS:    7.24.4
Role:        Main router, DHCP/DNS/NTP, firewall, CAPsMAN controller
LAN bridge:  bridge
LAN IP:      192.168.88.1/24
```

Bridge:

```text
bridge
vlan-filtering=yes
ingress-filtering=yes
```

Static bridge VLAN entry:

```text
VLAN 20
tagged: bridge,ether4
```

Dynamic entries include:

```text
VLAN 1:
  untagged: bridge,wlan1,wlan2,ether4

VLAN 20:
  tagged: wlan4
```

`ether4` is the trunk toward the GS108PEv2:

- VLAN 1 untagged
- VLAN 20 tagged

After enabling bridge VLAN filtering, the visible `H` hardware-offload flag disappeared from `ether4`, although `hw=yes` remains configured. The hAP uses an Atheros 8327 switch chip. Benchmark with `iperf3` if switching performance becomes a concern.

## MikroTik wAP ac

```text
Model:       RBwAPG-5HacT2HnD
RouterOS:    7.24.4
Role:        Wireless AP / CAP
Bridge:      bridgeLocal
Mgmt IP:     192.168.88.51
```

Bridge:

```text
bridgeLocal
vlan-filtering=yes
```

Static VLAN configuration:

```text
VLAN 20
tagged: ether1
```

Dynamic entries:

```text
VLAN 1:
  untagged: bridgeLocal,ether1,wlan1,wlan2

VLAN 20:
  tagged: wlan3
```

## Wi-Fi / CAPsMAN

Legacy CAPsMAN is in use with local forwarding.

Trusted datapath:

```text
dp-local
bridge=bridge
local-forwarding=yes
client-to-client-forwarding=yes
```

IoT datapath:

```text
dp-iot
local-forwarding=yes
client-to-client-forwarding=no
vlan-mode=use-tag
vlan-id=20
```

IoT SSID:

```text
SSID:        t8k_2_iot
Security:    WPA2/AES
Country:     Netherlands
```

IoT is provisioned on both 2.4 GHz radios.

Stable CAP radio MACs:

```text
hAP 2.4 GHz: 48:8F:5A:A1:11:11
wAP 2.4 GHz: CC:2D:E0:10:5F:DB
```

CAP interface names may change after reprovisioning and should not be treated as stable identifiers.

CAPsMAN certificate authentication is not currently enforced.
