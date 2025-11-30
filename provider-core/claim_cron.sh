#!/bin/sh
# Periodically trigger provider claims via the local admin API.

set -u

INTERVAL="${CLAIM_CRON_INTERVAL:-1800}"  # seconds; default 30 minutes
API_PORT="${ADMIN_API_PORT:-9999}"
URL="http://127.0.0.1:${API_PORT}/api/provider-claims"

echo "Starting provider-claims cron loop: interval=${INTERVAL}s url=${URL}"

while true; do
    TS="$(date -Iseconds)"
    if RESP="$(curl -sS --max-time 60 -X POST "${URL}")"; then
        echo "${TS} provider-claims response: ${RESP}"
    else
        echo "${TS} provider-claims request failed"
    fi
    sleep "${INTERVAL}"
done

