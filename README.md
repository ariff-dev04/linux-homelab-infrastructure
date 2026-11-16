# Enterprise Linux Homelab Infrastructure

Bare-metal **Ubuntu Server 26.04.1 LTS** (`homelab-svr` / Dell Latitude E6330) homelab deploying containerized network, observability, and application stacks via Docker Compose, secured behind Zero-Trust Cloudflare Tunnels.

## Architecture Overview

```mermaid
flowchart TD
    EXT["External Users / Admin"] -->|"HTTPS 443 + Cloudflare Access"| CF["Cloudflare Tunnel (openrvm_tunnel)"]
    LAN["LAN Clients (192.168.1.0/24)"] -->|"22/tcp SSH, 53/tcp+udp DNS"| UFW["UFW Firewall (Default Deny)"]
    CF -->|"Docker Internal:80"| NGINX["NGINX Alpine (127.0.0.1:80)"]
    CF -->|"Docker Internal:80"| PIHOLE["Pi-hole v6 (127.0.0.1:8080)"]
    CF -->|"Docker Internal:3001"| KUMA["Uptime Kuma v2 (127.0.0.1:3001)"]
    CF -->|"Docker Internal:3000"| GRAF["Grafana (127.0.0.1:3000)"]
    PROM["Prometheus (:9090)"] -->|"Scrapes :9100"| NE["node-exporter"]
    GRAF -->|"PromQL"| PROM
    BAK["scripts/backup.sh (cron 20:00 MYT)"] -->|"rclone sync (3-2-1 DR)"| GD["Google Drive"]
Phase 2.1: Local DNS & Network Sinkhole (Pi-hole v6)
Service: Pi-hole DNS Sinkhole (pihole/pihole:latest)

Ports: 53/tcp, 53/udp (LAN DNS), 127.0.0.1:8080/tcp (Loopback Web UI via Cloudflare Access)

Key Engineering Steps:
Resolved port 53 binding conflict (systemd-resolved stub listener) via /etc/systemd/resolved.conf.d/pihole.conf.

Configured FTLCONF_dns_listeningMode=all and isolated secrets in .env (chmod 600).

Phase 2.2: Zero-Trust Ingress & Web Portals (nginx:alpine + cloudflared)
Service: Loopback-only NGINX (127.0.0.1:80) with :ro volume mounts, fronted by Cloudflare Tunnel (openrvm_tunnel).

Portals: Public portfolio (ariffzakaria.dev), Public NOC (lab.ariffzakaria.dev), and Zero-Trust Admin Console (admin.ariffzakaria.dev).

Phase 2.3: Full-Stack Observability (uptime-kuma:2, node_exporter, prometheus, grafana)
Availability: Uptime Kuma v2 (127.0.0.1:3001) monitoring HTTP, DNS, ICMP, and Docker states (/var/run/docker.sock:ro).

Metrics & Dashboards: node_exporter (:9100) → Prometheus (:9090, 15d TSDB retention) → Grafana (127.0.0.1:3000, Dashboard 1860).

Phase 3.1: Host Security Hardening (UFW, OpenSSH, Fail2ban, Unattended Upgrades)
Firewall (ufw): Default-deny ingress allowing only 22/tcp (SSH) and 53/tcp+udp (DNS). All web UIs (80, 3000, 3001, 8080) are bound to 127.0.0.1 and accessed via Cloudflare Tunnel + Access.

SSH & Intrusion Prevention: ed25519 key-only SSH (/etc/ssh/sshd_config.d/01-homelab-hardening.conf), fail2ban (sshd jail with systemd backend), and unattended-upgrades for automated security patching.

Phase 3.2: 3-2-1 Disaster Recovery & Self-Healing (scripts/backup.sh + rclone)
Automation: Daily cron Bash script (set -euo pipefail) creating chmod 600 .tar.gz archives with 7-day rolling retention and off-site rclone sync to Google Drive (drive:homelab-backups).

Self-Healing: systemd L3 network watchdog (homelab-net-watchdog.service/.timer) and TLP power tuning (configs/tlp/01-headless-server.conf).

Phase 4.1: Application Hosting & CI/CD
Stacks: openrvm-cloud (Vue 3, FastAPI, PostgreSQL 16, Redis 7) and chargetrail-v2 (Flutter/Web, FastAPI) with a self-hosted GitHub Actions runner.
