# CIS-Aligned Host & SSH Security Hardening

## 1. Uncomplicated Firewall (UFW) Least-Privilege Policy
- **Default Policy:** `deny (incoming)`, `allow (outgoing)`, `deny (routed)`
- **Permitted Ingress Ports:**
  - `22/tcp` — OpenSSH Server (Key-Auth Only)
  - `53/tcp` & `53/udp` — Pi-hole v6 DNS Sinkhole
  - `80/tcp` — NGINX Alpine Portfolio Web Server
  - `8080/tcp` — Pi-hole Web Admin Console
  - `3001/tcp` — Uptime Kuma v2 Observability UI

## 2. OpenSSH Daemon Hardening (`/etc/ssh/sshd_config.d/01-homelab-hardening.conf`)
- **Cryptographic Auth:** Enforced `ed25519` public-key authentication (`PubkeyAuthentication yes`).
- **Brute-Force Mitigation:** Disabled cleartext password authentication (`PasswordAuthentication no`, `KbdInteractiveAuthentication no`) and restricted `MaxAuthTries 3`.
- **Privilege Escalation Control:** Disabled direct root login (`PermitRootLogin no`).
- **Precedence Troubleshooting:** Named drop-in file `01-homelab-hardening.conf` to precede Ubuntu `50-cloud-init.conf` under OpenSSH first-match-wins parsing rules; verified runtime config via `sudo sshd -T` and penetration-tested with `ssh -o PubkeyAuthentication=no`.
