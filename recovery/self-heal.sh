#!/bin/bash
# ============================================================================
# SELF-HEALING MECHANISM - TỰ ĐỘNG PHỤC HỒI
# ============================================================================

BACKUP_DIR="$HOME/adaptive-security-ai/recovery/backups"
CONFIG_DIR="$HOME/adaptive-security-ai/config"
LOG_DIR="$HOME/adaptive-security-ai/logs"

# Tạo backup tự động
create_backup() {
    local backup_name="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$BACKUP_DIR/$backup_name" "$CONFIG_DIR" 2>/dev/null
    echo "$(date): Backup created: $backup_name" >> "$LOG_DIR/recovery.log"
    
    # Chỉ giữ 7 backup gần nhất
    ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n +8 | xargs rm -f 2>/dev/null
}

# Phát hiện và sửa lỗi
detect_and_repair() {
    local service="$1"
    
    case $service in
        guardian)
            if ! pgrep -f "guardian.service.sh" > /dev/null; then
                echo "$(date): Guardian service died, restarting..." >> "$LOG_DIR/recovery.log"
                cd ~/adaptive-security-ai/core && nohup ./guardian.service.sh > /dev/null 2>&1 &
            fi
            ;;
        config)
            if [ ! -f "$CONFIG_DIR/security.conf" ]; then
                echo "$(date): Config file missing, restoring from latest backup..." >> "$LOG_DIR/recovery.log"
                latest_backup=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -1)
                if [ -n "$latest_backup" ]; then
                    tar -xzf "$latest_backup" -C "$CONFIG_DIR" 2>/dev/null
                fi
            fi
            ;;
    esac
}

# Tự động phục hồi
while true; do
    create_backup
    detect_and_repair "guardian"
    detect_and_repair "config"
    sleep 300
done
