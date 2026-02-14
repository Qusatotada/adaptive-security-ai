#!/bin/bash
# ============================================================================
# GUARDIAN SERVICE - GIÁM SÁT & PHÁT HIỆN BẤT THƯỜNG
# ============================================================================

CONFIG_DIR="$HOME/adaptive-security-ai/config"
MONITOR_DIR="$HOME/adaptive-security-ai/monitors"
LOG_DIR="$HOME/adaptive-security-ai/logs"
RECOVERY_DIR="$HOME/adaptive-security-ai/recovery"
INTEL_DIR="$HOME/adaptive-security-ai/intel"

# Học hỏi từ cộng đồng (phân tán, minh bạch)
learn_from_community() {
    # Kết nối đến các nguồn intel bảo mật công khai (MITRE ATT&CK, OWASP, v.v.)
    curl -s https://raw.githubusercontent.com/mitre/cti/master/enterprise-attack/enterprise-attack.json > "$INTEL_DIR/mitre-latest.json"
    echo "$(date): Cập nhật threat intel từ MITRE" >> "$LOG_DIR/intel.log"
}

# Tự động cấu hình lại dựa trên mối đe dọa mới
adaptive_reconfigure() {
    local threat_level="$1"
    local config_file="$CONFIG_DIR/security.conf"
    
    case $threat_level in
        low)
            sed -i '' 's/MONITORING_LEVEL=.*/MONITORING_LEVEL=normal/' "$config_file"
            ;;
        medium)
            sed -i '' 's/MONITORING_LEVEL=.*/MONITORING_LEVEL=enhanced/' "$config_file"
            ;;
        high)
            sed -i '' 's/MONITORING_LEVEL=.*/MONITORING_LEVEL=maximum/' "$config_file"
            ;;
    esac
    echo "$(date): Cấu hình lại thành mức $threat_level" >> "$LOG_DIR/adaptive.log"
}

# Giám sát chính
monitor_loop() {
    learn_from_community
    
    while true; do
        # Kiểm tra các chỉ số hệ thống
        CPU_LOAD=$(uptime | awk '{print $10}')
        MEM_USAGE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
        
        # Phát hiện bất thường
        if (( $(echo "$CPU_LOAD > 5.0" | bc -l) )); then
            echo "$(date): CẢNH BÁO - CPU cao bất thường" >> "$LOG_DIR/alerts.log"
            adaptive_reconfigure "high"
        fi
        
        sleep 60
    done
}

monitor_loop
