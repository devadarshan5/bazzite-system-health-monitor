#!/usr/bin/env bash

set -u

REPORT="reports/health-report.txt"

fail() {
    echo "FAIL: $1"
    exit 1
}

bash -n scripts/health-check.sh ||
    fail "Health monitor syntax check failed."

usage=$(df -P "$HOME" |
    awk 'NR == 2 {gsub(/%/, "", $5); print $5}')

if ! [[ "$usage" =~ ^[0-9]+$ ]]; then
    fail "Could not determine home filesystem usage."
fi

if (( usage >= 100 )); then
    fail "Cannot test the OK path while usage is 100%."
fi

ok_threshold=$((usage + 1))

WARN_THRESHOLD="$ok_threshold" bash scripts/health-check.sh ||
    fail "Health monitor failed during OK-path test."

grep -Eq '^OK: Home filesystem usage is [0-9]+%\.$' "$REPORT" ||
    fail "Expected an OK assessment."

WARN_THRESHOLD=0 bash scripts/health-check.sh ||
    fail "Health monitor failed during WARNING-path test."

grep -Eq '^WARNING: Home filesystem usage is [0-9]+%\.$' "$REPORT" ||
    fail "Expected a WARNING assessment."

if WARN_THRESHOLD=101 bash scripts/health-check.sh >/dev/null 2>&1; then
    fail "Invalid threshold was accepted."
fi

echo "PASS: OK and WARNING paths tested; invalid threshold rejected."
