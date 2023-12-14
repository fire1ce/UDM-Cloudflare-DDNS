#!/bin/bash

# Set error mode
set -e
set -x

# Define color codes
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m' # No Color

# Define URLs for the DDNS script and configuration
DDNS_SCRIPT_URL="https://raw.githubusercontent.com/fire1ce/DDNS-Cloudflare-Bash/main/update-cloudflare-dns.sh"
DDNS_CONFIG_URL="https://raw.githubusercontent.com/fire1ce/DDNS-Cloudflare-Bash/main/update-cloudflare-dns.conf"

# Get DataDir location and firmware version
DATA_DIR=""
FIRMWARE_VERSION=$(ubnt-device-info firmware || true)

echo -e "${GREEN}Detected firmware version: $FIRMWARE_VERSION${NC}"

case "$FIRMWARE_VERSION" in
1*)
  echo -e "${RED}ERROR: Firmware version 1.x is not supported by this script.${NC}" 1>&2
  exit 1
  ;;
2* | 3*)
  DATA_DIR="/data"
  echo -e "${GREEN}Using /data for installation.${NC}"
  ;;
*)
  echo -e "${RED}ERROR: Unsupported firmware version or no persistent storage found.${NC}" 1>&2
  exit 1
  ;;
esac

# Ensure the target directory exists
mkdir -p "$DATA_DIR/cloudflare-ddns"

# Download the DDNS script directly into the target directory and set execute permission
curl -s -o "$DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh" "$DDNS_SCRIPT_URL"
chmod +x "$DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh"

# Download the configuration file directly into the target directory
curl -s -o "$DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf" "$DDNS_CONFIG_URL"

# Modify the what_ip parameter from "internal" to "external"
sed -i 's/what_ip="internal"/what_ip="external"/' "$DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf"

# Define the DDNS update service name
DDNS_SERVICE_NAME="cloudflare-ddns-update"

# Prompt the user for the interval with validation
while true; do
  read -p "Enter the interval for the DDNS update (1-60 minutes): " INTERVAL
  if [[ "$INTERVAL" =~ ^[1-9][0-9]?$ ]] && [ "$INTERVAL" -ge 1 ] && [ "$INTERVAL" -le 60 ]; then
    break
  else
    echo -e "${YELLOW}Invalid input. Please enter a number between 1 and 60.${NC}"
  fi
done

# Function to create systemd service file
create_ddns_service() {
  echo -e "${BLUE}Creating DDNS systemd service file${NC}"

  # Create the systemd service file
  cat <<EOF >/etc/systemd/system/$DDNS_SERVICE_NAME.service
[Unit]
Description=Cloudflare DDNS Update Service
After=network.target

[Service]
Type=simple
ExecStart=$DATA_DIR/cloudflare-ddns/update-cloudflare-dns.sh

[Install]
WantedBy=multi-user.target
EOF

  # Reload systemd to recognize new service
  systemctl daemon-reload

  # Enable the service
  systemctl enable $DDNS_SERVICE_NAME.service
}

# Function to create systemd timer file
create_ddns_timer() {
  echo -e "${BLUE}Creating DDNS systemd timer file${NC}"

  # Create the systemd timer file
  cat <<EOF >/etc/systemd/system/$DDNS_SERVICE_NAME.timer
[Unit]
Description=Run Cloudflare DDNS update every $INTERVAL minutes

[Timer]
OnCalendar=*:0/$INTERVAL
Persistent=true

[Install]
WantedBy=timers.target
EOF

  # Reload systemd to recognize new timer
  systemctl daemon-reload

  # Enable the timer
  systemctl enable $DDNS_SERVICE_NAME.timer
}

# Main script execution
create_ddns_service
create_ddns_timer

# Start the timer
systemctl start $DDNS_SERVICE_NAME.timer

# Inform the user about the configuration file and the log file locations
echo -e "${GREEN}The DDNS script will run every $INTERVAL minutes and has been successfully set up.${NC}"
echo -e "${BLUE}Log files for the DDNS can be found at $DATA_DIR/cloudflare-ddns${NC}"
echo -e "${YELLOW}IMPORTANT: Edit configuration at $DATA_DIR/cloudflare-ddns/update-cloudflare-dns.conf${NC}"
