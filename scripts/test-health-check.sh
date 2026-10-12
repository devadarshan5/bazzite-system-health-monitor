#!/usr/bin/env bash

set -u

REPORT="reports/health-report.txt"

if [[ ! -f "$REPORT" ]]; then
    echo "FAIL: Health report does not exist."
    exit 1
fi

if grep -Eq '^OK: Home filesystem usage is [0-9]+%\.$' "$REPORT" ||
   grep -Eq '^WARNING: Home filesystem usage is [0-9]+\%\.$' "$REPORT"; then
    echo "PASS: Storage assessment is present."
else
    echo "FAIL: Storage assessment is missing or malformed."
    exit 1
fi
