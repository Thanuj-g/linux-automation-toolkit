#!/usr/bin/env bash

# Linux Server Automation Toolkit
# Automated Backup Script

set -euo pipefail

SOURCE_DIR="test-data"
BACKUP_DIR="backup"
LOG_FILE="logs/backup.log"

mkdir -p "$BACKUP_DIR" logs

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found!"
    exit 1
fi

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Backup filename
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

echo "Starting backup..."

# Create compressed backup
if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then

    echo "SUCCESS: Backup created!"
    echo "Backup file: $BACKUP_FILE"

    # Verify archive
    if tar -tzf "$BACKUP_FILE" > /dev/null; then
        echo "SUCCESS: Backup archive verified."
        echo "$(date): Backup successful - $BACKUP_FILE" >> "$LOG_FILE"
    else
        echo "ERROR: Backup verification failed!"
        rm -f "$BACKUP_FILE"
        exit 1
    fi

else
    echo "ERROR: Backup creation failed!"
    exit 1
fi

# Keep only the latest 5 backups
echo "Cleaning old backups..."

BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "backup-*.tar.gz" | wc -l)

if [ "$BACKUP_COUNT" -gt 5 ]; then
    find "$BACKUP_DIR" -maxdepth 1 -type f -name "backup-*.tar.gz" \
        -printf '%T@ %p\n' |
        sort -nr |
        tail -n +6 |
        cut -d' ' -f2- |
        while IFS= read -r OLD_BACKUP; do
            rm -f -- "$OLD_BACKUP"
            echo "Deleted old backup: $OLD_BACKUP"
        done
fi

echo "Backup cleanup completed."
