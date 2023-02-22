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
mv update-cloudflare-dns.sh $DATA_DIR/cloudflare-ddns
chmod +x $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh
curl -sO https://raw.githubusercontent.com/fire1ce/UDM-Cloudflare-DDNS/main/30-cloudflare-ddns.sh
mv 30-cloudflare-ddns.sh $DATA_DIR/on_boot.d/30-cloudflare-ddns.sh
chmod +x $DATA_DIR/on_boot.d/30-cloudflare-ddns.sh
curl -sO https://raw.githubusercontent.com/fire1ce/UDM-Cloudflare-DDNS/main/update-cloudflare-dns.conf
mv update-cloudflare-dns.conf $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf

echo "==> 30-cloudflare-ddns.sh installed successfully"
echo "==> Edit configuration at $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf"
echo "==> Then run $DATA_DIR/on_boot.d/30-cloudflare-ddns.sh"
exit 0
