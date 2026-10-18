#!/usr/bin/env bash
# ==============================================================================
# Script Name: backup.sh
# Description: Automated Disaster Recovery Backup for Homelab Docker Volumes
# Author:      Muhammad 'Ariff
# ==============================================================================

set -euo pipefail

# 1. Define Variables
SOURCE_DIR="/home/arifflabs/homelab"
BACKUP_DIR="/home/arifflabs/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="homelab-backup-${TIMESTAMP}.tar.gz"
LOG_FILE="${BACKUP_DIR}/backup.log"
RETENTION_DAYS=7

# 2. Ensure backup directory exists with strict permissions (Owner Only)
mkdir -p "${BACKUP_DIR}"
chmod 700 "${BACKUP_DIR}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: Starting homelab backup..." | tee -a "${LOG_FILE}"

# 3. Create compressed tar.gz archive of the entire homelab directory
sudo tar -czf "${BACKUP_DIR}/${ARCHIVE_NAME}" -C "/home/arifflabs" "homelab"

# 4. Change ownership of the backup file back to arifflabs and lock permissions
sudo chown arifflabs:arifflabs "${BACKUP_DIR}/${ARCHIVE_NAME}"
chmod 600 "${BACKUP_DIR}/${ARCHIVE_NAME}"

# 5. Calculate backup file size for audit logging
BACKUP_SIZE=$(du -h "${BACKUP_DIR}/${ARCHIVE_NAME}" | cut -f1)
echo "[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS: Created ${ARCHIVE_NAME} (Size: ${BACKUP_SIZE})" | tee -a "${LOG_FILE}"

# 6. Enforce 7-Day Rolling Retention Policy (Delete archives older than 7 days)
find "${BACKUP_DIR}" -name "homelab-backup-*.tar.gz" -type f -mtime +${RETENTION_DAYS} -delete
echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: Retention cleanup complete (kept last ${RETENTION_DAYS} days)." | tee -a "${LOG_FILE}"
