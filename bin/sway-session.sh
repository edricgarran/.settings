#!/bin/sh
set -euo pipefail

trap 'kill $(jobs -p) 2>/dev/null' EXIT

aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
nimf

service() {
    tries=0
    while ! "$@"; do
        tries=$((tries+1))
        if [[ $tries -gt 5 ]]; then
            echo "[$@] retry limit reached, giving up"
            break
        fi
    done &
}

service foot --server
service mako --default-timeout 5000 --anchor bottom-right
service swayfocus 0.8

# service swayidle -w \
#     before-sleep 'lock.sh' \
#     timeout 540  'lock.sh' \
#     timeout 600  'swaymsg "output * dpms off"' \
#     resume       'swaymsg "output * dpms on"'

wait
