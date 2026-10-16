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
