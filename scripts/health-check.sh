#!/usr/bin/env bash

set -u

REPORT="reports/health-report.txt"
WARN_THRESHOLD="${WARN_THRESHOLD:-80}"

if ! [[ "$WARN_THRESHOLD" =~ ^(0|[1-9][0-9]?|100)$ ]]; then
    echo "ERROR: WARN_THRESHOLD must be an integer from 0 to 100." >&2
    exit 2
fi

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

    usage=$(df -P "$HOME" |
        awk 'NR == 2 {gsub(/%/, "", $5); print $5}')

    echo "=== Storage Assessment ==="
    if [[ "$usage" =~ ^[0-9]+$ ]]; then
        if (( usage >= WARN_THRESHOLD )); then
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
