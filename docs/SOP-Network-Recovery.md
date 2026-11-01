# 📋 Standard Operating Procedure (SOP): L2/L3 Network Outage & SSH Timeout Recovery

**Document ID:** `SOP-NET-002`
**Target Host:** `homelab-svr` (`192.168.1.62` / Dell Latitude E6330 / Ubuntu Server 24.04 LTS)
**Primary Interface:** `wlp2s0` (Intel Centrino Advanced-N 6205)
**Automated Mitigation:** Static IPv4 Netplan (`ignore-carrier: true`) + `homelab-net-watchdog.timer` (60s interval)

---

## 1. Symptoms & Failure Indicators

| Layer | Symptom Observed | Root Cause |
| :--- | :--- | :--- |
| **Client (Windows)** | `ssh: connect to host 192.168.1.62 port 22: Connection timed out` | Host is unreachable at Layer 3. |
| **Client (Windows)** | `Reply from 192.168.1.x: Destination host unreachable` | Layer 2 ARP broadcast for `192.168.1.62` received no reply. |
| **Host Console** | `ping: connect: Network is unreachable` | Default route `via 192.168.1.254` dropped due to DHCP lease loss or carrier drop. |
| **Public Ingress** | `ERR_NGROK_3200` or Cloudflare `Error 1033` | Outbound tunnel containers (`openrvm_tunnel`, `openrvm_ngrok`) lost WAN routing. |

---

## 2. Permanent Prevention & Self-Healing Architecture

1. **Static IPv4 Netplan (`/etc/netplan/`):** Configured `dhcp4: false`, `ignore-carrier: true`, static `192.168.1.62/24`, and gateway `192.168.1.254` so `systemd-networkd` never flushes the IPv4 address during 5GHz WPA rekeying.
2. **Watchdog Timer (`homelab-net-watchdog.timer`):** Enforces `iw dev wlp2s0 set power_save off` every 60s, pings `192.168.1.254` and `1.1.1.1`, and auto-reapplies Netplan and restarts tunnels on failure.

---

## 3. Manual Console Recovery Procedure (If Needed)

```bash
sudo iw dev wlp2s0 set power_save off
sudo netplan apply
ip -br -4 a show wlp2s0
docker restart openrvm_tunnel openrvm_ngrok
