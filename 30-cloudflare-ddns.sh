#!/bin/bash

# Get DataDir location
DATA_DIR="/mnt/data"
case "$(ubnt-device-info firmware || true)" in
1*)
  DATA_DIR="/mnt/data"
  ;;
2*)
  DATA_DIR="/data"
  ;;
3*)
  DATA_DIR="/data"
  ;;
*)
  echo "ERROR: No persistent storage found." 1>&2
  exit 1
  ;;
esac

# Set up the cron job
(
  crontab -l
  echo "* * * * * $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh"
) | crontab -
