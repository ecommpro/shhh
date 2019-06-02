#!/bin/ash
set -e

if [ ! -z "$SECRETS" ]; then
    for secret in $SECRETS; do shhh $secret > /dev/null; done;
    mkdir -p /shhh \
    && find /shhh -type d -exec chmod 755 "{}" \; \
    && find /shhh -type f -exec chmod 644 "{}" \;
fi

if [ $# -gt 0 ]; then
    exec shhh "$@"
fi