# Network Documentation Instructions

## Progressive Loading

- **MUST** start with `network/README.md` to identify the relevant document.
- **MUST** load only the documents needed for the current task.
- **MUST NOT** load every network document unless the task requires a cross-network review.
- Follow links from the index instead of searching unrelated repository areas.

## Source of Truth

- Treat these documents as records of known or observed network state, not desired-state configuration.
- **MUST NOT** invent addresses, device roles, VLAN membership, firewall behavior, or test results.
- Mark point-in-time observations as observations.
- Record planned changes as follow-up work until their implementation is verified.
- Preserve uncertainty where the documentation identifies missing information.

## Document Boundaries

- Use `topology.md` for physical links and logical traffic paths.
- Use `addressing-and-wan.md` for subnets, VLANs, DHCP assignments, and WAN details.
- Use `mikrotik-and-wifi.md` for MikroTik devices, bridge VLANs, CAPsMAN, and wireless configuration.
- Use `switching.md` for NETGEAR switch configuration and port behavior.
- Use `proxmox.md` for the hypervisor, guests, Talos, and Home Assistant connectivity.
- Use `firewall-and-management.md` for firewall policy, router access, IPv6, and Thread behavior.
- Use `verification-and-follow-ups.md` for verified properties, planned work, and documentation gaps.

## Editing Rules

- Update the smallest relevant document.
- Update every affected document when one fact appears in multiple places.
- Update `network/README.md` when adding, renaming, or removing a document.
- Keep each document independently understandable without duplicating unrelated sections.
- Preserve device names, interface names, addresses, VLAN IDs, and command output exactly unless verified information replaces them.
- **MUST NOT** add passwords, private keys, authentication tokens, unsanitized configuration exports, or other credentials.

## Verification

Before completing documentation changes:

- Confirm local Markdown links resolve.
- Confirm changed facts do not contradict another network document.
- Confirm observed, current, and planned states remain clearly distinguished.
- Run `git diff --check`.
