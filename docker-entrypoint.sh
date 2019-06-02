#!/bin/ash
for secret in $SECRETS; do shhh $secret > /dev/null; done;
chmod -R 755 /shhh && chmod -R 644 /shhh/*