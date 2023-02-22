#!/bin/sh

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

curl -sO https://raw.githubusercontent.com/fire1ce/DDNS-Cloudflare-Bash/main/update-cloudflare-dns.sh
mkdir -p $DATA_DIR/cloudflare-ddns
mv update-cloudflare-dns.sh $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh
chmod +x $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh
curl -sO https://raw.githubusercontent.com/fire1ce/UDM-Cloudflare-DDNS/main/update-cloudflare-dns.conf
mv update-cloudflare-dns.conf $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf

# Define the cron job
cron_job="* * * * * $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh"

# Add the cron job to the user's crontab file
echo "==> Adding cron job to crontab"
(
  crontab -l
  echo "$cron_job"
) | crontab -

echo "==> Edit configuration at $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf"
echo "==> The script will run every minute, you can change this in the crontab file"
exit 0
