# WanderfulTravels — A Linux Enterprise Environment

Final project for the Operating Systems Architecture course (ISLA Gaia, Computer Engineering, 2025/2026). A 3-VM Linux infrastructure built from scratch for a fictional travel agency, covering the core services a small company network relies on: internal DNS/DHCP, file sharing, a web server with a CMS, and secure remote access.

📄 Full write-up with configs, commands, and screenshots: [`WanderfulTravels_OSA_FP.pdf`](./WanderfulTravels_OSA_FP.pdf)

## Overview

Wanderful Travels, Lda. is a fictional 10-person travel agency. The project simulates its internal IT infrastructure across three Ubuntu Server 22.04 LTS virtual machines on an isolated host-only network, hosted in Oracle VirtualBox on a Windows host.

| VM | IP | Role |
|---|---|---|
| `srv-infra` | 192.168.56.10 (static) | DNS (BIND9), DHCP (isc-dhcp-server), Samba, OpenVPN |
| `srv-web` | 192.168.56.20 (static) | Apache, MariaDB, PHP, WordPress (HTTPS) |
| `srv-client` | 192.168.56.50–100 (DHCP) | Client workstation / backup target |

Subnet: `192.168.56.0/24` (Host-Only `vboxnet0`) · Domain: `wanderful.local`

## Services implemented

- **Networking & firewall** — static IPs via Netplan on infra/web, UFW with default-deny inbound and explicit per-service rules on all three VMs
- **Users & SSH** — non-root users on every VM, key-based auth with ed25519, password authentication disabled on `srv-web`
- **DNS & DHCP** — authoritative BIND9 zone (forward + reverse) for `wanderful.local`, DHCP leases with gateway/DNS options delivered to `srv-client`
- **Samba** — a public (guest) share and a private (authenticated) share, accessible from both Linux and Windows clients
- **LAMP + WordPress** — Apache, MariaDB, PHP; WordPress served over HTTPS via a dedicated VirtualHost with a self-signed certificate and HTTP→HTTPS redirect
- **OpenVPN** — encrypted tunnel from the Windows host into the internal subnet, PKI managed with easy-rsa
- **Backups** — Bash script backing up the WordPress files, a MariaDB dump, and the Apache config

## Repository contents

```
├── WanderfulTravels_OSA_FP.pdf   # Full project report (architecture, configs, screenshots, troubleshooting)
├── configs/                      # Exported config files (netplan, bind9, dhcpd, samba, apache, openvpn, backup.sh)
└── README.md
```

## Notable troubleshooting

- Fixed `srv-client` DNS resolution after DHCP by relinking `/etc/resolv.conf` to the systemd-resolved stub
- Diagnosed Apache serving the default page instead of WordPress (VirtualHost config file didn't exist before `a2ensite`)
- Recovered `srv-infra` from an accidental DHCP self-lease that conflicted with its static IP

See the [PDF](./WanderfulTravels_OSA_FP.pdf) (§6) for the full list of problems and fixes.

## Future improvements

- Replace the self-signed HTTPS certificate with a CA-signed one
- Automate backups with cron + `rsync` to `srv-client`
- Add a periodic health-monitoring script
- Add `fail2ban` on `srv-web` and `srv-infra`

## Author

Sonia Peiov — Computer Engineering student, ISLA Gaia (Erasmus+) / Universitatea Politehnica Timișoara
