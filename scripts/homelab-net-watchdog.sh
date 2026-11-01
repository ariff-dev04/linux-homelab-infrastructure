#!/bin/bash
# Homelab L3 Self-Healing Network Watchdog (Ubuntu 24.04 LTS)
LOG_FILE="/var/log/homelab-net-watchdog.log"
WIFI_IF="wlp2s0"
GW_IP="192.168.1.254"

# Always enforce Wi-Fi power_save off on Intel Centrino 6205
/usr/sbin/iw dev "$WIFI_IF" set power_save off 2>/dev/null || true

# Test L3 connectivity to Local Gateway (192.168.1.254) and Cloudflare (1.1.1.1)
if ! ping -c 2 -W 3 "$GW_IP" >/dev/null 2>&1 && ! ping -c 2 -W 3 1.1.1.1 >/dev/null 2>&1; then
    echo "$(date -Iseconds) [WARN] L3 Network Unreachable (GW: $GW_IP). Initiating self-healing recovery..." >> "$LOG_FILE"

    /usr/sbin/ip link set "$WIFI_IF" up 2>/dev/null || true
    /usr/bin/networkctl reconfigure "$WIFI_IF" 2>/dev/null || true
    /usr/sbin/netplan apply 2>/dev/null || true
    sleep 8

    NEW_IP=$(ip -br -4 a show "$WIFI_IF" | awk '{print $3}')
    echo "$(date -Iseconds) [INFO] Recovery applied. Current $WIFI_IF IPv4: ${NEW_IP:-NONE}" >> "$LOG_FILE"

    if [ -n "$NEW_IP" ]; then
        docker restart openrvm_tunnel openrvm_ngrok >/dev/null 2>&1 || true
        echo "$(date -Iseconds) [OK] Restarted openrvm_tunnel and openrvm_ngrok." >> "$LOG_FILE"
    fi
fi
