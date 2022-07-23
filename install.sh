#!/bin/sh

curl -sO https://raw.githubusercontent.com/fire1ce/UDM-Better-Fan-Speeds/main/30-cloudflare-ddns.sh
mv 30-cloudflare-ddns.sh /mnt/data/on_boot.d/30-cloudflare-ddns.sh
chmod +x /mnt/data/on_boot.d/30-cloudflare-ddns.sh
echo "==> 30-cloudflare-ddns.sh installed successfully"
echo "==> Edit configuration at /mnt/data/on_boot.d/30-cloudflare-ddns.sh"
echo "==> Then run /mnt/data/on_boot.d/30-cloudflare-ddns.sh"
exit 0
