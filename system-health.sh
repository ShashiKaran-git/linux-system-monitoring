#!/bin/bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

LOG_FILE="health.log"

echo "========================================"
echo "      System Health Monitoring"
echo "========================================"

# CPU Usage
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

# Memory Usage
MEMORY_USAGE=$(free | awk '/Mem:/ {printf("%.2f"), $3/$2 * 100}')

# Disk Usage
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

# Running Processes
PROCESS_COUNT=$(ps -e --no-headers | wc -l)

echo "CPU Usage       : ${CPU_USAGE}%"
echo "Memory Usage    : ${MEMORY_USAGE}%"
echo "Disk Usage      : ${DISK_USAGE}%"
echo "Running Process : ${PROCESS_COUNT}"

echo ""

# Alerts
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: CPU usage is above ${CPU_THRESHOLD}%!" | tee -a "$LOG_FILE"
fi

if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "ALERT: Memory usage is above ${MEMORY_THRESHOLD}%!" | tee -a "$LOG_FILE"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: Disk usage is above ${DISK_THRESHOLD}%!" | tee -a "$LOG_FILE"
fi

echo "Health check completed at $(date)" >> "$LOG_FILE"