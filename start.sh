#!/bin/bash
# ============================================================================
# KHỞI ĐỘNG ADAPTIVE SECURITY AI SYSTEM
# ============================================================================

cd ~/adaptive-security-ai

echo "🛡️  KHỞI ĐỘNG ADAPTIVE SECURITY AI"
echo "Owner: Dang Viet Quang"
echo "────────────────────────────────────"

# Dừng tiến trình cũ
pkill -f "guardian.service.sh" 2>/dev/null
pkill -f "self-heal.sh" 2>/dev/null
pkill -f "community-intel.sh" 2>/dev/null

# Khởi động các thành phần
nohup ./core/guardian.service.sh > logs/guardian.log 2>&1 &
echo "✅ Guardian service started (PID: $!)"

nohup ./recovery/self-heal.sh > logs/recovery.log 2>&1 &
echo "✅ Self-heal service started (PID: $!)"

nohup ./intel/community-intel.sh > logs/intel.log 2>&1 &
echo "✅ Community intel started (PID: $!)"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  ✅ HỆ THỐNG ĐÃ KHỞI ĐỘNG                                    ║"
echo "║  📁 Logs: ~/adaptive-security-ai/logs/                       ║"
echo "║  🔄 Tự động học hỏi từ cộng đồng mỗi 24h                     ║"
echo "║  🛠️  Tự động phục hồi khi phát hiện lỗi                      ║"
echo "║  ⚙️  Tự động cấu hình lại dựa trên mối đe dọa                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
