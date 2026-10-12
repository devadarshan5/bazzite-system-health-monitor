#!/usr/bin/env bash

set -u

REPORT="reports/health-report.txt"

{
    echo "================================="
    echo " Bazzite System Health Report"
    echo "================================="
    echo "Generated: $(date)"
    echo

    echo "=== Uptime and Load ==="
    uptime
    echo

    echo "=== Memory and Swap ==="
    free -h
    echo

    echo "=== Home Storage ==="
    df -h "$HOME"
    echo

} > "$REPORT"

echo "Health report saved to: $REPORT"
