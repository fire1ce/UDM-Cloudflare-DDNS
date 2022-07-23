#!/bin/sh
CONTAINER=cloudflare-ddns

# Starts a cloudflare ddns container that is deleted after it is stopped.
# All configs stored in /mnt/data/cloudflare-ddns
if podman container exists "$CONTAINER"; then
  podman start "$CONTAINER"
else
  podman run -i -d \
    --name "$CONTAINER" \
    --restart=always \
    -v /run \
    -e API_KEY=change_me \
    -e ZONE=example.com \
    -e SUBDOMAIN=change_me \
    -e CRON="* * * * *" \
    oznu/cloudflare-ddns:latest
fi
