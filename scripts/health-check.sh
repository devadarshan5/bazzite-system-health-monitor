#!/usr/bin/env bash

set -u

REPORT="reports/health-report.txt"
mkdir -p reports

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

    usage=$(df -P "$HOME" | awk 'NR == 2 {gsub(/%/, "", $5); print $5}')

    echo "=== Storage Assessment ==="
    if [[ "$usage" =~ ^[0-9]+$ ]]; then
        if (( usage >= 80 )); then
            echo "WARNING: Home filesystem usage is ${usage}%."
        else
            echo "OK: Home filesystem usage is ${usage}%."
        fi
    else
        echo "ERROR: Could not determine home filesystem usage."
    fi
    echo

} > "$REPORT"

echo "Health report saved to: $REPORT"
