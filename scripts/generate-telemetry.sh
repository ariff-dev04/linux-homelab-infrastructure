#!/bin/bash
set -euo pipefail

# Path to your NGINX web root (adjust if your folder name differs)
WEB_ROOT="/home/arifflabs/homelab/nginx/html/public"
OUT_FILE="${WEB_ROOT}/telemetry.json"
TMP_FILE="${WEB_ROOT}/telemetry.json.tmp"

# 1. Hardware Metrics (CPU Temp, Fan RPM, Frequency)
CPU_TEMP=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input 2>/dev/null | awk '{printf "%.1f", $1/1000}' || echo "0.0")
FAN_RPM=$(cat /sys/class/hwmon/hwmon*/fan1_input 2>/dev/null | head -n 1 || echo "0")
CPU_MHZ=$(awk -F': ' '/cpu MHz/ {printf "%.0f", $2; exit}' /proc/cpuinfo)
UPTIME_HUMAN=$(uptime -p | sed 's/^up //')
LOAD_1M=$(awk '{print $1}' /proc/loadavg)

# 2. Memory & Disk Metrics
read -r MEM_TOTAL MEM_USED MEM_PCT <<< $(free -m | awk '/^Mem:/ {printf "%d %d %.1f", $2, $3, ($3/$2)*100}')
read -r DISK_USED DISK_TOTAL DISK_PCT <<< $(df -BG / | awk 'NR==2 {gsub("G","",$3); gsub("G","",$2); gsub("%","",$5); printf "%s %s %s", $3, $2, $5}')

# 3. Docker Container Summary (JSON Array)
CONTAINERS_JSON=$(docker stats --no-stream --format '{"name":"{{.Name}}","cpu":"{{.CPUPerc}}","mem":"{{.MemUsage}}","mem_pct":"{{.MemPerc}}"}' | paste -sd, -)
RUNNING_COUNT=$(docker ps -q | wc -l)

# 4. Write Atomic JSON
cat << JSON > "$TMP_FILE"
{
  "hostname": "$(hostname)",
  "updated_at": "$(date -Iseconds)",
  "uptime": "${UPTIME_HUMAN}",
  "hardware": {
    "cpu_model": "Intel Core i7-3540M",
    "cpu_temp_c": ${CPU_TEMP},
    "fan_rpm": ${FAN_RPM},
    "cpu_mhz": ${CPU_MHZ},
    "load_1m": ${LOAD_1M},
    "mem_used_mb": ${MEM_USED},
    "mem_total_mb": ${MEM_TOTAL},
    "mem_pct": ${MEM_PCT},
    "disk_used_gb": ${DISK_USED},
    "disk_total_gb": ${DISK_TOTAL},
    "disk_pct": ${DISK_PCT}
  },
  "containers_running": ${RUNNING_COUNT},
  "containers": [${CONTAINERS_JSON}]
}
JSON

mv "$TMP_FILE" "$OUT_FILE"

# 5. Layer B Dead-Man's-Switch: Ping Healthchecks.io every 60s
curl -fsS -m 10 --retry 3 -o /dev/null https://hc-ping.com/https://hc-ping.com/7ab06b38-33ab-4fb1-8064-5ae74f6c7af4 || true
