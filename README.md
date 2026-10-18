# Enterprise Linux Homelab Infrastructure

Bare-metal Ubuntu Server 24.04 LTS homelab deploying containerized network and infrastructure services via Docker Compose.

## Phase 2.1: Local DNS & Network Sinkhole (Pi-hole v6)
- **Service:** Pi-hole DNS Sinkhole (`pihole/pihole:latest`)
- **Ports:** `53/tcp`, `53/udp` (DNS), `8080/tcp` (Web Admin UI)
- **Key Engineering & Troubleshooting Steps:**
  1. Diagnosed local port 53 binding conflict (`systemd-resolved` stub listener) using `ss -tulnp`.
  2. Configured a drop-in systemd resolver override (`/etc/systemd/resolved.conf.d/pihole.conf`) to disable `DNSStubListener` while preserving upstream resolution.
  3. Migrated Docker Compose configuration to Pi-hole v6 `FTLCONF_` environment variables (`FTLCONF_dns_listeningMode=all`) to permit LAN bridge queries.
  4. Secured sensitive credentials using isolated `.env` files (`chmod 600`) excluded via `.gitignore`.

## Phase 2.2: NGINX Web Server (`nginx:alpine`)
- **Service:** Lightweight Alpine-based NGINX HTTP server hosting custom portfolio & homelab dashboard.
- **Ports:** `80/tcp` (HTTP)
- **Security:** Configured container volume bind-mount with `:ro` (Read-Only) flag to prevent container-to-host file tampering.

## Phase 2.3: Enterprise Service & Network Monitoring (`uptime-kuma:2`)
- **Service:** Uptime Kuma v2 monitoring HTTP, DNS, ICMP latency, and Docker container states.
- **Ports:** `3001/tcp` (Web Dashboard)
- **Integration:** Mounted `/var/run/docker.sock:ro` for read-only container health inspection and configured custom local DNS A-records (`ariff.lab`, `status.ariff.lab`) in Pi-hole.

## Phase 3.1: Host Security Hardening (UFW & OpenSSH)
- **Firewall (`ufw`):** Enforced default-deny ingress policy allowing only active service ports (`22`, `53`, `80`, `8080`, `3001`).
- **SSH Hardening:** Configured `ed25519` key-based authentication and disabled root/password logins via `/etc/ssh/sshd_config.d/01-homelab-hardening.conf` (overriding `50-cloud-init.conf` first-match precedence).
