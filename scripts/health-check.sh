
#!/usr/bin/env bash

# ==========================================
# Linux Server Health Monitoring Toolkit
# Project 1 - DevOps Learning Project
# ==========================================

# Log file configuration
LOG_FILE="logs/health-$(date +%F).log"

# Create logs directory if it does not exist
mkdir -p logs

# Collect and display health information
{
    echo "=================================="
    echo "       LINUX SERVER HEALTH"
    echo "=================================="

    echo "Date: $(date)"
    echo "Hostname: $(hostname)"

    # --------------------------------------
    # 1. SYSTEM UPTIME
    # --------------------------------------

    echo ""
    echo "----- SYSTEM UPTIME -----"
    uptime

    # --------------------------------------
    # 2. CPU LOAD MONITORING
    # --------------------------------------

    echo ""
    echo "----- CPU LOAD ALERT -----"

    CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
    CPU_CORES=$(nproc)

    echo "1-minute load average: $CPU_LOAD"
    echo "Available CPU cores: $CPU_CORES"

    awk -v cpu_load="$CPU_LOAD" -v cores="$CPU_CORES" '
    BEGIN {
        if (cpu_load > cores)
            print "WARNING: High CPU load!"
        else
            print "CPU load is healthy."
    }'

    # --------------------------------------
    # 3. MEMORY MONITORING
    # --------------------------------------

    echo ""
    echo "----- MEMORY USAGE -----"
    free -h

    echo ""
    echo "----- MEMORY SPACE ALERT -----"

    MEMORY_USAGE=$(free | awk '/Mem:/ {
        printf "%.0f", ($2 - $7) / $2 * 100
    }')

    if [ "$MEMORY_USAGE" -ge 80 ]; then
        echo "WARNING: Memory usage is ${MEMORY_USAGE}%"
    else
        echo "Memory usage is healthy: ${MEMORY_USAGE}%"
    fi

    # --------------------------------------
    # 4. DISK MONITORING
    # --------------------------------------

    echo ""
    echo "----- DISK USAGE -----"
    df -h /

    echo ""
    echo "----- DISK SPACE ALERT -----"

    DISK_USAGE=$(df -P / | awk 'NR==2 {
        gsub("%","",$5)
        print $5
    }')

    if [ "$DISK_USAGE" -ge 80 ]; then
    echo "WARNING: Disk usage is ${DISK_USAGE}%"
    echo "ALERT: Disk space is running low!" | tee -a "$LOG_FILE"
else
    echo "Disk usage is healthy: ${DISK_USAGE}%"
fi

    # --------------------------------------
    # 5. PROCESS MONITORING
    # --------------------------------------

    echo ""
    echo "----- TOP 5 MEMORY-CONSUMING PROCESSES -----"

    ps aux --sort=-%mem | head -n 6

    # --------------------------------------
    # COMPLETION
    # --------------------------------------

    echo ""
    echo "Health check completed."
    echo "=================================="

} | tee -a "$LOG_FILE"

